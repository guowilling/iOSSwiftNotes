
import Foundation
import FMDB

/// 最大的数据库缓存时间, 单位 s
private let maxDBCacheTime: TimeInterval = 60 * 60 // -5 * 24 * 60 * 60

// 理解:
// 1. 数据库开发, 应用代码几乎都是一致的, 区别在于 SQL 语句, 最好在 Navicat 中测试 SQL 语句的正确性
// 2. 数据库本质上是保存在沙盒中的一个文件.

// 步骤:
// 1. 创建并且打开数据库
// 2. 创建数据表
// 3. 增删改查

/// SQLite 管理器
class SQLiteManager {
    /// 单例
    static let shared = SQLiteManager()
    
    /// 数据库队列
    let queue: FMDatabaseQueue
    
    /// 构造函数
    private init() {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = (path as NSString).appendingPathComponent("status.db") // 数据库文件的全路径
        //print("数据库文件的路径: " + path)
        queue = FMDatabaseQueue(path: path) // 创建数据库队列, 自动创建或者打开数据库.
        createTable() // 创建数据表
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(clearDBCache),
                                               name: NSNotification.Name.UIApplicationDidEnterBackground,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func clearDBCache() {
        let dateString = Date.wb_dateString(delta: maxDBCacheTime)
        print("清理数据库缓存: \(dateString)")
        let SQLString = "DELETE FROM T_Status WHERE createTime < ?;"
        queue.inDatabase { (db) in
            if db?.executeUpdate(SQLString, withArgumentsIn: [dateString]) == true {
                print("删除了: \(db?.changes()) 条记录")
            }
        }
    }
}

extension SQLiteManager {
    
    func createTable() {
        guard let path = Bundle.main.path(forResource: "status.sql", ofType: nil),
            let SQLString = try? String(contentsOfFile: path) else {
                return
        }
        //print(SQLString)
        
        // 执行 SQL 语句, FMDB 内部队列, 串行队列, 同步执行, 保证同一时间只有一个任务操作数据库, 从而保证数据库的读写一致性.
        queue.inDatabase { (db) in
            // executeStatements 只用在创表的时候, 可以执行多条语句, 一次创建多个表.
            // 增删改的时候, 不要使用 executeStatements, 否则有可能会被注入!
            if db?.executeStatements(SQLString) == true {
                print("创建表成功")
            } else {
                print("创建表失败")
            }
        }
    }
    
    /// 读取数据库缓存的微博数据
    ///
    /// - parameter userId:   当前用户帐号
    /// - parameter since_id: ID 比 since_id 大的微博
    /// - parameter max_id:   ID 比 max_id 小的微博
    ///
    /// - returns: 微博字典数组
    func loadStatus(userId: String, since_id: Int64 = 0, max_id: Int64 = 0) -> [[String: AnyObject]] {
        var SQLString = "SELECT statusId, userId, status FROM T_Status \n"
        SQLString += "WHERE userId = \(userId) \n"
        if since_id > 0 {
            SQLString += "AND statusId > \(since_id) \n"
        } else if max_id > 0 {
            SQLString += "AND statusId < \(max_id) \n"
        }
        SQLString += "ORDER BY statusId DESC LIMIT 20;"
        print(SQLString) // 准备好 SQL 语句后最好测试一下.
        
        let array = executeQueryAction(SQLString: SQLString)
        
        var statusM = [[String: AnyObject]]()
        for dict in array {
            guard let jsonData = dict["status"] as? Data,
                let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: AnyObject] else {
                    continue
            }
            statusM.append(json ?? [:])
        }
        return statusM
    }
    
    func executeQueryAction(SQLString: String) -> [[String: AnyObject]] {
        var arrayM = [[String: AnyObject]]()
        
        // 执行 SQL 语句, 查询数据不会修改数据, 所以不需要开启事务. 事务: 是为了保证数据的有效性, 一旦失败回滚到初始状态.
        queue.inDatabase { (db) in
            guard let result = db?.executeQuery(SQLString, withArgumentsIn: []) else {
                return
            }
            while result.next() {
                let colCount = result.columnCount()
                for col in 0..<colCount {
                    guard let name = result.columnName(for: col),
                        let value = result.object(forColumnIndex: col) else {
                            continue
                    }
                    arrayM.append([name: value as AnyObject])
                }
            }
        }
        return arrayM
    }
    
    func updateStatus(userId: String, array: [[String: AnyObject]]) {
        // statusId:  要保存的微博 Id
        // userId:    当前用户的 Id
        // status:    要保存的微博二进制数据
        let SQLString = "INSERT OR REPLACE INTO T_Status (statusId, userId, status) VALUES (?, ?, ?);"
        queue.inTransaction { (db, rollback) in
            // 遍历数组, 逐条插入微博数据
            for dict in array {
                guard let statusId = dict["idstr"] as? String,
                    let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                        continue
                }
                if db?.executeUpdate(SQLString, withArgumentsIn: [statusId, userId, jsonData]) == false {
                    // 回滚 *rollback = YES;
                    // Swift 1.x & 2.x => rollback.memory = true;
                    // Swift 3.0
                    rollback?.pointee = true
                    break
                }
                // 测试回滚
                // rollback?.pointee = true
                // break
            }
        }
    }
}

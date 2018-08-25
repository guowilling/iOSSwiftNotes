
import UIKit

class AnchorModel: BaseModel {
    
    var uid: String = ""
    var roomid: Int = 0
    var name: String = ""
    var pic51: String = ""
    var pic74: String = ""
    
    var live: Int = 0 // 是否正在直播
    var push: Int = 0 // 直播方式
    var focus: Int = 0 // 关注数量
    
    var isEvenIndex: Bool = false
}

extension AnchorModel {
    
    func inserIntoDB() {
        let insertSQL = "INSERT INTO t_focus (roomid, name, pic51, pic74, live) VALUES (\(roomid), '\(name)', '\(pic51)', '\(pic74)', \(live));"
        if SQLiteTool.execSQL(insertSQL) {
            print("插入成功")
        } else {
            print("插入失败")
        }
    }
    
    func deleteFromDB() {
        let deleteSQL = "DELETE FROM t_focus WHERE roomid = \(roomid);"
        if SQLiteTool.execSQL(deleteSQL) {
            print("删除成功")
        } else {
            print("删除失败")
        }
    }
}

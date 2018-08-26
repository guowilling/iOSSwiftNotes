
import UIKit

private let accountFile: NSString = "useraccount.json"

/// 用户账户信息
class WBUserAccount: NSObject {
    /// 访问令牌
    var access_token: String?
    
    /// 用户代号
    var uid: String?
    
    /// access_token 生命周期单位秒
    var expires_in: TimeInterval = 0 {
        didSet {
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    /// 过期日期
    var expiresDate: Date?
    
    /// 用户昵称
    var screen_name: String?
    
    /// 用户头像地址, 180×180 像素
    var avatar_large: String?
    
    override var description: String {
        return yy_modelDescription()
    }
    
    override init() {
        super.init()
        
        // 加载沙盒文件数据
        guard let path = accountFile.sr_appendDocumentDir(),
            let data = NSData(contentsOfFile: path),
        let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: AnyObject] else {
                return
        }
        
        // 使用字典设置属性
        yy_modelSet(with: dict ?? [:])
        
        // 判断 token 是否过期
        // expiresDate = Date(timeIntervalSinceNow: -3600 * 24) // 测试过期
        // print(expiresDate)
        if expiresDate?.compare(Date()) != .orderedDescending {
            print("账户过期了!")
            access_token = nil
            uid = nil
            _ = try? FileManager.default.removeItem(atPath: path)
        }
    }
    
    func saveAccount() {
        // 模型转字典
        var dict = (self.yy_modelToJSONObject() as? [String: AnyObject]) ?? [:]
        // 删除 expires_in 属性值
        dict.removeValue(forKey: "expires_in")
        // 字典序列化成 data
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
            let filePath = accountFile.sr_appendDocumentDir() else {
                return
        }
        // 写入沙盒
        (data as NSData).write(toFile: filePath, atomically: true)
        print("用户账户保存成功: \(filePath)")
    }
}

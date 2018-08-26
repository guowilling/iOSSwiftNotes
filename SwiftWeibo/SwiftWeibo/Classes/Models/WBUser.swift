
import UIKit

/// 用户模型
class WBUser: NSObject {
    // 基本数据类型 和 private 修饰的属性不能使用 KVC
    
    /// 用户 id
    var id: Int64 = 0
    
    /// 用户昵称
    var screen_name: String?
    
    /// 用户头像地址, 50×50 像素
    var profile_image_url: String?
    
    /// 认证类型(-1: 没有认证; 0: 认证用户; 2 3 5: 企业认证; 220: 达人;)
    var verified_type: Int = 0
    
    /// 会员等级(0 - 6)
    var mbrank: Int = 0
    
    override var description: String {
        return yy_modelDescription()
    }
}


import UIKit
import YYModel

/// 微博模型
class WBStatus: NSObject {
    // Int 类型, 在 64 位的机器是 64 位, 在 32 位机器是 32 位
    // 如果不用 Int64 在 iPad 2/iPhone 5/5c/4s/4 无法正常运行
    var id: Int64 = 0
    
    /// 微博正文内容
    var text: String?
    
    /// 微博创建日期字符串
    var created_at: String? {
        didSet {
            createdDate = Date.wb_sinaDate(string: created_at ?? "")
        }
    }
    
    /// 微博创建日期
    var createdDate: Date?
    
    /// 微博来源, 发布微博使用的客户端
    var source: String? {
        didSet {
            // didSet 方法中, 给 source 再次设置值, 不会调用 didSet 方法
            source = "来自" + (source?.wb_href()?.text ?? "")
        }
    }
    
    var reposts_count: Int = 0
    var comments_count: Int = 0
    var attitudes_count: Int = 0
    
    /// 微博的用户
    var user: WBUser?
    
    /// 转发微博
    var retweeted_status: WBStatus?
    
    /// 微博配图
    var pic_urls: [WBStatusPicture]?
    
    /// 重写 description 的计算型属性
    override var description: String {
        return yy_modelDescription()
    }
    
    /// 类函数告诉 YYModel 数组中存放的元素是什么类型
    class func modelContainerPropertyGenericClass() -> [String: AnyClass] {
        return ["pic_urls": WBStatusPicture.self]
    }
}

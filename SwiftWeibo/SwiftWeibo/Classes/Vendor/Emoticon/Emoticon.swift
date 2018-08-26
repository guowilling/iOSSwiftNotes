
import UIKit
import YYModel

/// 表情模型
class Emoticon: NSObject {
    /// 表情类型 false: 图片表情 / true: emoji
    var type = false
    
    /// 表情字符串(发送给新浪微博的服务器, 节约流量)
    var chs: String?
    
    /// 表情图片名称(本地图文混排)
    var png: String?
    
    /// emoji 的十六进制编码
    var code: String? {
        didSet {
            guard let code = code else {
                return
            }
            let scanner = Scanner(string: code)
            var result: UInt32 = 0
            scanner.scanHexInt32(&result)
            emoji = String(Character(UnicodeScalar(result)!))
        }
    }
    
    /// 表情使用次数
    var times: Int = 0
    
    /// emoji 的字符串
    var emoji: String?
    
    /// 表情所在的目录
    var directory: String?
    
    /// 图片表情对应的图片
    var image: UIImage? {
        if type {
            return nil
        }
        guard let directory = directory,
            let png = png,
            let path = Bundle.main.path(forResource: "Emoticon.bundle", ofType: nil),
            let bundle = Bundle(path: path) else {
                return nil
        }
        return UIImage(named: "\(directory)/\(png)", in: bundle, compatibleWith: nil)
    }
    
    /// 图片表情转属性文本
    func imageText(font: UIFont) -> NSAttributedString {
        guard let image = image else {
            return NSAttributedString(string: "")
        }
        let attachment = EmoticonAttachment()
        attachment.chs = chs
        attachment.image = image
        let height = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
        let attrStringM = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        attrStringM.addAttributes([NSFontAttributeName: font], range: NSRange(location: 0, length: 1))
        return attrStringM
    }
    
    override var description: String {
        return yy_modelDescription()
    }
}

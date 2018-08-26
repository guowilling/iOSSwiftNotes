
import Foundation

extension String {
    /// 提取链接和文本(Swift 提供了元组, 可以同时返回多个值; OC 可以返回字典 / 自定义对象 / 指针的指针代替)
    func wb_href() -> (link: String, text: String)? {
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
            let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count)) else {
                return nil
        }
        let link = (self as NSString).substring(with: result.rangeAt(1))
        let text = (self as NSString).substring(with: result.rangeAt(2))
        return (link, text)
    }
}

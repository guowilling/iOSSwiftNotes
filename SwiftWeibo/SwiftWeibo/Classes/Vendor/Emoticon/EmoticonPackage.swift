
import UIKit
import YYModel

/// 表情包模型
class EmoticonPackage: NSObject {
    /// 表情包分组名
    var groupName: String?
    
    /// 背景图片名称
    var bgImageName: String?
    
    /// 表情包目录
    var directory: String? {
        didSet {
            guard let directory = directory,
                let path = Bundle.main.path(forResource: "Emoticon.bundle", ofType: nil),
                let bundle = Bundle(path: path),
                let infoPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
                let array = NSArray(contentsOfFile: infoPath) as? [[String: String]],
                let models = NSArray.yy_modelArray(with: Emoticon.self, json: array) as? [Emoticon] else {
                return
            }
            for model in models {
                model.directory = directory
            }
            emoticons += models
        }
    }
    
    /// 懒加载的表情模型的空数组(使用懒加载可以避免后续的解包)
    lazy var emoticons = [Emoticon]()
    
    /// 表情页面数量
    var numberOfPages: Int {
        return (emoticons.count - 1) / 20 + 1
    }
    
    func emoticon(page: Int) -> [Emoticon] {
        let count = 20
        let location = page * count
        var length = count
        if location + length > emoticons.count {
            length = emoticons.count - location
        }
        let range = NSRange(location: location, length: length)
        let subArray = (emoticons as NSArray).subarray(with: range)
        return subArray as! [Emoticon]
    }
    
    override var description: String {
        return yy_modelDescription()
    }
}

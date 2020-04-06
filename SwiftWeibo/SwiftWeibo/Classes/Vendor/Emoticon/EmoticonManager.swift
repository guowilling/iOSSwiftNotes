
import UIKit

/// 表情管理器
class EmoticonManager {
    /// 使用单例模式, 只加载一次表情数据, 复用表情数据
    static let shared = EmoticonManager()
    
    /// 表情包的懒加载数组 - 第一个数组是最近表情，加载之后，表情数组为空
    lazy var packages = [EmoticonPackage]()
    
    lazy var bundle: Bundle = {
        let path = Bundle.main.path(forResource: "Emoticon.bundle", ofType: nil)
        return Bundle(path: path!)!
    }()
    
    /// 构造函数, 增加 private 修饰符, 调用者只能通过 shared 得到对象(OC 要重写 allocWithZone 方法)
    private init() {
        // 读取 emoticons.plist(只要按照 Bundle 默认的目录结构, 就可以直接读取 Resources 目录下的文件)
        guard let path = Bundle.main.path(forResource: "Emoticon.bundle", ofType: nil),
            let bundle = Bundle(path: path),
            let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
            let array = NSArray(contentsOfFile: plistPath) as? [[String: String]],
            let models = NSArray.yy_modelArray(with: EmoticonPackage.self, json: array) as? [EmoticonPackage] else {
                return
        }
        packages += models // 使用 '+=' 不需要再次给 packages 分配空间, 直接追加数据
    }
    
    /// 添加最近使用的表情
    ///
    /// - parameter em: 选中的表情
    func recentEmoticon(em: Emoticon) {
        // 增加该表情的使用次数
        em.times += 1
        
        if !packages[0].emoticons.contains(em) {
            packages[0].emoticons.append(em)
        }
        
        // 根据表情使用次数排序, 次数高的排前
//        packages[0].emoticons.sort { (em1, em2) -> Bool in
//            return em1.times > em2.times
//        }
        // Swift 中, 如果闭包只有一个 return, 参数可以省略, 参数名 用 $0... 替代
        packages[0].emoticons.sort { $0.times > $1.times }
        
        // 判断表情数组是否超出 20
        if packages[0].emoticons.count > 20 {
            // 如果超出删除末尾的表情
            packages[0].emoticons.removeSubrange(20..<packages[0].emoticons.count)
        }
    }
}

// MARK: - 表情字符串的处理
extension EmoticonManager {
    
    func emoticonString(string: String, font: UIFont) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: string)
        
        // 正则表达式过滤所有的表情文字, '[]' '()' 都是正则表达式的关键字, 如果要参与匹配需要转义
        let pattern = "\\[.*?\\]"
        
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return attrString
        }
        
        let matches = regx.matches(in: string, options: [], range: NSRange(location: 0, length: attrString.length))
        
        for matche in matches.reversed() { // 匹配结果需要倒序!
            let range = matche.range(at: 0)
            let subStr = (attrString.string as NSString).substring(with: range)
            if let em = EmoticonManager.shared.findEmoticon(string: subStr) {
                attrString.replaceCharacters(in: range, with: em.imageText(font: font))
            }
        }
        
        // 统一设置一遍字符串的属性, 除了需要设置字体, 还需要设置颜色!
        attrString.addAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.darkGray],
                                 range: NSRange(location: 0, length: attrString.length))
        return attrString
    }
    
    /// 根据 string '[爱你]' 在所有的表情中查找对应的表情模型
    func findEmoticon(string: String) -> Emoticon? {
        // 遍历表情包(OC 中过滤数组使用 [谓词])
        for p in packages {
            // 表情数组中过滤 string
            
            // 方法1
//            let result = p.emoticons.filter({ (em) -> Bool in
//                return em.chs == string
//            })
            
            // 方法2: 尾随闭包
//            let result = p.emoticons.filter() { (em) -> Bool in
//                return em.chs == string
//            }
            
            // 方法3: 如果闭包中只有一句代码并且是返回语句, 闭包格式定义可以省略; 参数省略之后使用 $0, $1... 依次替代原有的参数
//            let result = p.emoticons.filter() {
//                return $0.chs == string
//            }
            
            // 方法4: 如果闭包中只有一句代码并且是返回语句, 闭包格式定义可以省略; 参数省略之后使用 $0, $1... 依次替代原有的参数; return 关键字也可以省略
            let result = p.emoticons.filter() { $0.chs == string }
            
            if result.count == 1 {
                return result[0]
            }
        }
        return nil
    }
}

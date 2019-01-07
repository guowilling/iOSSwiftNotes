
import Foundation

class EmotionHelper: NSObject {
    
    static let EmotionFont = BigFont
    
    /// 表情图片文件名作为 key, 表情对应的文本作为值的字典
    static let emotionDic: [String: String] = {
        return String.readJSON2DicWithFileName(fileName: "emotion")["dict"]
        }() as! [String: String]
    
    /// 每一页的表情图片文件名的二维数组
    static let emotionPageData: [[String]] = {
        return String.readJSON2DicWithFileName(fileName: "emotion")["array"]
        }() as! [[String]]
    
    /// 通过正则表达式匹配文本, 表情文本转换为 NSTextAttachment 图片文本: [飞吻] -> 😘
    static func stringToEmotion(attrStr: NSAttributedString) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: attrStr)
        let pattern = "\\[.*?\\]"
        var regex: NSRegularExpression?
        do {
            regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options(rawValue: 0))
        } catch {
            print("stringToEmotion error: " + error.localizedDescription)
        }
        let matches: [NSTextCheckingResult] = regex?.matches(in: attrStr.string,
                                                             options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                                             range: NSRange(location: 0, length: attrStr.length)) ?? [NSTextCheckingResult]()
        var lengthOffset = 0
        for match in matches {
            let range = match.range
            let emotionValue = attrStr.string.subString(range: range)
            let emotinoKey = EmotionHelper.emotionKeyOfValue(value: emotionValue)
            let attachment:NSTextAttachment = NSTextAttachment()
            let emotionPath = EmotionHelper.emotionPathOfKey(emotionKey: emotinoKey)
            
            attachment.image = UIImage(contentsOfFile: emotionPath)
            attachment.bounds = CGRect(x: 0, y: EmotionFont.descender, width: EmotionFont.lineHeight, height: EmotionFont.lineHeight/((attachment.image?.size.width)!/(attachment.image?.size.height)!))
            let matchStr = NSAttributedString(attachment: attachment)
            let emotionStr = NSMutableAttributedString(attributedString: matchStr)
            emotionStr.addAttribute(NSAttributedString.Key.font, value: EmotionFont, range: NSRange(location: 0, length: 1))
            attributedString.replaceCharacters(in: NSRange(location: range.location - lengthOffset, length: range.length), with: emotionStr)
            lengthOffset += (range.length - 1)
        }
        return attributedString
    }
    
    /// NSTextAttachment 图片文本转换为表情文本: 😘 -> [飞吻]
    static func emotionToString(attrStr: NSMutableAttributedString) -> NSAttributedString {
        attrStr.enumerateAttribute(.attachment, in: NSRange.init(location: 0, length: attrStr.length), options: .longestEffectiveRangeNotRequired) { (value, range, stop) in
            if let attachment = value as? NSTextAttachment {
                if let emotionKey = attachment.emotionKey {
                    let emotionValue = EmotionHelper.emotionValueOfKey(key: emotionKey)
                    attrStr.replaceCharacters(in: range, with: emotionValue)
                }
            }
        }
        return attrStr
    }
    
    static func insertEmotionWithString(attrStr: NSAttributedString, index: Int, key: String) -> NSAttributedString {
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.emotionKey = key
        let emotionPath = EmotionHelper.emotionPathOfKey(emotionKey:key)
        attachment.image = UIImage.init(contentsOfFile: emotionPath)
        attachment.bounds = CGRect.init(x: 0, y: EmotionFont.descender, width: EmotionFont.lineHeight, height: EmotionFont.lineHeight/((attachment.image?.size.width)!/(attachment.image?.size.height)!))
        let matchStr = NSAttributedString.init(attachment: attachment)
        let emotionStr = NSMutableAttributedString.init(attributedString: matchStr)
        emotionStr.addAttribute(NSAttributedString.Key.font, value: EmotionFont, range: NSRange.init(location: 0, length: emotionStr.length))
        let attrStr = NSMutableAttributedString.init(attributedString:  attrStr)
        attrStr.replaceCharacters(in: NSRange.init(location: index, length: 0), with: emotionStr)
        return attrStr
    }
    
    static func emotionKeyOfValue(value: String) -> String {
        let emotionDic: [String: String] = EmotionHelper.emotionDic
        for key in emotionDic.keys {
            if emotionDic[key] == value {
                return key
            }
        }
        return ""
    }
    
    static func emotionValueOfKey(key: String) -> String {
        let emotionDic: [String: String] = EmotionHelper.emotionDic
        return emotionDic[key] ?? ""
    }
    
    static func emotionPathOfKey(emotionKey: String) -> String {
        let emotionsPath = Bundle.main.path(forResource: "Emoticons", ofType: "bundle") ?? ""
        let emotionPath = emotionsPath + "/" + emotionKey
        return emotionPath
    }
}

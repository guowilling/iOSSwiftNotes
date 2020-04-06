
import UIKit

class WBComposeTextView: UITextView {

    fileprivate lazy var placeholderLabel = UILabel()

    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textChanged),
                                               name: UITextView.textDidChangeNotification,
                                               object: self)
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func textChanged() {
        placeholderLabel.isHidden = self.hasText
    }
}

private extension WBComposeTextView {
    
    func setupUI() {
        placeholderLabel.text = "分享新鲜事..."
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 8)
        placeholderLabel.sizeToFit()
        addSubview(placeholderLabel)
    }
}

extension WBComposeTextView {
    /// 向文本视图插入表情符号[图文混排]
    ///
    /// - parameter em: 选中的表情符号，nil 表示删除
    func insertEmoticon(em: Emoticon?) {
        // em == nil 删除按钮
        guard let em = em else {
            deleteBackward()
            return
        }
        
        // emoji 字符串
        if let emoji = em.emoji,
            let textRange = selectedTextRange {
            // textRange 仅用在此处.
            replace(textRange, withText: emoji)
            
            return
        }
        
        // 图片表情
        let imageText = em.imageText(font: font!) // 图片表情属性文本
        let attrStrM = NSMutableAttributedString(attributedString: attributedText)
        attrStrM.replaceCharacters(in: selectedRange, with: imageText) // 插入到当前的光标位置
        let range = selectedRange // 记录光标位置
        attributedText = attrStrM // 重新设置属性文本
        selectedRange = NSRange(location: range.location + 1, length: 0) // 设置光标位置, length 是选中字符的长度, 插入文本之后应该恢复为 0
        delegate?.textViewDidChange?(self) // 让代理执行文本变化方法, 如果需要
        textChanged() // 执行当前对象的文本变化方法
    }
    
    /// 返回 textView 对应的纯文本的字符串(图片表情转成对应的文字)
    var emoticonText: String {
        
        guard let attrString = attributedText else {
            return ""
        }
        var result = String()
        attrString.enumerateAttributes(in: NSRange(location: 0, length: attrString.length), options: [], using: { (dict, range, _) in
            // 如果字典中包含 NSAttachment 'Key' 说明是图片否则是文本
//            if let attachment = dict["NSAttachment"] as? EmoticonAttachment {
//                //print("图片表情: \(attachment)")
//                result += attachment.chs ?? "" // 得到 attachment 中的 chs
//            } else {
//                let subString = (attrString.string as NSString).substring(with: range)
//                result += subString
//            }
        })
        return result
    }
}

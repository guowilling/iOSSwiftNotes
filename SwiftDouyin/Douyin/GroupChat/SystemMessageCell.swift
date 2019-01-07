
import Foundation

let SYSTEM_MESSAGE_CELL_ID: String = "SYSTEM_MESSAGE_CELL_ID"

let SYSTEM_MSG_CORNER_RADIUS: CGFloat = 10
let SYSTEM_MSG_MAX_WIDTH: CGFloat = ScreenWidth - 110

class SystemMessageCell:UITableViewCell {
    
    var textView: UITextView = UITextView.init()
    
    var chat: GroupChat? {
        didSet {
            guard let chat = chat else { return }
            var attributedString: NSMutableAttributedString = NSMutableAttributedString(string: chat.msg_content ?? "")
            attributedString.addAttributes(SystemMessageCell.attributes(), range: NSRange(location: 0, length: attributedString.length))
            attributedString = EmotionHelper.stringToEmotion(attrStr: attributedString)
            textView.attributedText = attributedString
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = ColorClear
        
        setupSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubView() {
        textView.textColor = SystemMessageCell.attributes()[.foregroundColor] as? UIColor
        textView.backgroundColor = ColorGrayDark
        textView.font = SystemMessageCell.attributes()[.font] as? UIFont
        textView.textContainerInset = UIEdgeInsets.init(top: SYSTEM_MSG_CORNER_RADIUS, left: SYSTEM_MSG_CORNER_RADIUS, bottom: SYSTEM_MSG_CORNER_RADIUS, right: SYSTEM_MSG_CORNER_RADIUS)
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.layer.cornerRadius = SYSTEM_MSG_CORNER_RADIUS
        self.addSubview(textView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let attributedString = NSMutableAttributedString.init(attributedString: textView.attributedText)
        let size = attributedString.multiLineSize(width: SYSTEM_MSG_MAX_WIDTH)
        textView.frame = CGRect.init(x: ScreenWidth/2 - size.width/2 - SYSTEM_MSG_CORNER_RADIUS, y: COMMON_MSG_PADDING*2, width: size.width + SYSTEM_MSG_CORNER_RADIUS * 2, height: size.height + SYSTEM_MSG_CORNER_RADIUS * 2)
    }
}

extension SystemMessageCell {
    static func attributes() -> [NSAttributedString.Key: Any] {
        return [.font: MediumFont, .foregroundColor: ColorGray]
    }
    
    static func cellHeight(chat:GroupChat) -> CGFloat {
        var attributedString = NSMutableAttributedString.init(string: chat.msg_content ?? "")
        attributedString.addAttributes(SystemMessageCell.attributes(), range: NSRange(location: 0, length: attributedString.length))
        attributedString = EmotionHelper.stringToEmotion(attrStr: attributedString)
        let size = attributedString.multiLineSize(width: SYSTEM_MSG_MAX_WIDTH)
        return size.height + COMMON_MSG_PADDING * 2 + SYSTEM_MSG_CORNER_RADIUS * 2
    }
}

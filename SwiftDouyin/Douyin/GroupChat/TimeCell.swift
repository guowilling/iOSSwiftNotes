
import Foundation

let TIME_CELL_ID: String = "TIME_CELL_ID"

let TIME_MSG_CORNER_RADIUS: CGFloat = 10
let TIME_MSG_MAX_WIDTH: CGFloat = ScreenWidth - 110

class TimeCell: UITableViewCell {
    
    var textView: UITextView = UITextView.init()
    
    var chat: GroupChat? {
        didSet {
            guard let chat = chat else { return }
            var attributedString: NSMutableAttributedString = NSMutableAttributedString.init(string: chat.msg_content ?? "")
            attributedString.addAttributes(TimeCell.attributes(), range: NSRange(location: 0, length: attributedString.length))
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
        textView.textColor = TimeCell.attributes()[.foregroundColor] as? UIColor
        textView.backgroundColor = ColorClear
        textView.font = TimeCell.attributes()[.font] as? UIFont
        textView.textContainerInset = UIEdgeInsets.init(top: TIME_MSG_CORNER_RADIUS * 2, left: TIME_MSG_CORNER_RADIUS, bottom: 0, right: TIME_MSG_CORNER_RADIUS)
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.isEditable = false
        self.addSubview(textView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textView.snp.makeConstraints { make in
            make.centerX.bottom.equalTo(self)
        }
    }
}

extension TimeCell {
    static func attributes() -> [NSAttributedString.Key: Any] {
        return [.font: SmallFont, .foregroundColor:ColorGray]
    }
    
    static func cellHeight(chat: GroupChat) -> CGFloat {
        var attributedString = NSMutableAttributedString(string: chat.msg_content ?? "")
        attributedString.addAttributes(TimeCell.attributes(), range: NSRange.init(location: 0, length: attributedString.length))
        attributedString = EmotionHelper.stringToEmotion(attrStr: attributedString)
        let size = attributedString.multiLineSize(width: TIME_MSG_MAX_WIDTH)
        return size.height + COMMON_MSG_PADDING * 2
    }
}

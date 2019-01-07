
let TEXT_MESSAGE_CELL_ID: String = "TEXT_MESSAGE_CELL_ID"

let TEXT_MSG_CORNER_RADIUS: CGFloat = 10
let TEXT_MSG_MAX_WIDTH: CGFloat = ScreenWidth - 160

import Foundation

class TextMessageCell: UITableViewCell {
    
    var avatar = UIImageView(image: UIImage(named: "img_find_default"))
    var textView: UITextView = UITextView()
    var backgroundLayer = CAShapeLayer()
    var indicator = UIImageView(image: UIImage(named: "icon30WhiteSmall"))
    var tipIcon = UIImageView(image: UIImage(named: "icWarning"))
    
    var chat: GroupChat? {
        didSet {
            guard let chat = chat else { return }
            var attributedString = NSMutableAttributedString(string: chat.msg_content ?? "")
            attributedString.addAttributes(TextMessageCell.attributes(), range: NSRange(location: 0, length: attributedString.length))
            attributedString = EmotionHelper.stringToEmotion(attrStr: attributedString)
            textView.attributedText = attributedString
            if chat.isTemp {
                startIndicatorAnim()
                if chat.isFailed {
                    tipIcon.isHidden = false
                }
                if chat.isCompleted {
                    stopIndicatorAnim()
                }
            } else {
                stopIndicatorAnim()
            }
            avatar.setImageWithURL(imageURL: URL(string: chat.visitor?.avatar_thumbnail?.url ?? "")!) { [weak self] (image, error) in
                if let image = image {
                    self?.avatar.image = image.drawCircleImage()
                }
            }
        }
    }
    
    var onMenuAction: OnChatCellMenuAction?
    
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
        avatar.contentMode = .scaleAspectFill
        self.addSubview(avatar)
        
        textView.textColor = TextMessageCell.attributes()[.foregroundColor] as? UIColor
        textView.backgroundColor = ColorClear
        textView.font = TextMessageCell.attributes()[.font] as? UIFont
        textView.textContainerInset = UIEdgeInsets(top: TEXT_MSG_CORNER_RADIUS, left: TEXT_MSG_CORNER_RADIUS, bottom: TEXT_MSG_CORNER_RADIUS, right: TEXT_MSG_CORNER_RADIUS)
        textView.textContainer.lineFragmentPadding = 0
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showMenu)))
        self.addSubview(textView)
        
        backgroundLayer = CAShapeLayer()
        backgroundLayer.zPosition = -1
        textView.layer.addSublayer(backgroundLayer)
        
        indicator.isHidden = true
        self.addSubview(indicator)
        
        tipIcon.isHidden = true
        self.addSubview(tipIcon)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        indicator.isHidden = true
        tipIcon.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        attributedString.addAttributes(TextMessageCell.attributes(), range: NSRange(location: 0, length: attributedString.length))
        attributedString = EmotionHelper.stringToEmotion(attrStr: attributedString)
        let size = attributedString.multiLineSize(width: TEXT_MSG_MAX_WIDTH)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        backgroundLayer.path = TextMessageCell.createBackgroundBezierPath(cornerRadius: TEXT_MSG_CORNER_RADIUS, width: size.width, height: size.height).cgPath
        backgroundLayer.frame = CGRect(origin: .zero, size: CGSize(width: size.width + TEXT_MSG_CORNER_RADIUS * 2, height: size.height + TEXT_MSG_CORNER_RADIUS * 2))
        backgroundLayer.transform = CATransform3DIdentity
        if UDID_MD5 == chat?.visitor?.udid {
            avatar.frame = CGRect(x: ScreenWidth - COMMON_MSG_PADDING - 30, y: COMMON_MSG_PADDING, width: 30, height: 30)
            textView.frame = CGRect(x: self.avatar.frame.minX - COMMON_MSG_PADDING - (size.width + TEXT_MSG_CORNER_RADIUS * 2), y: COMMON_MSG_PADDING, width: size.width + TEXT_MSG_CORNER_RADIUS * 2, height: size.height + TEXT_MSG_CORNER_RADIUS * 2)
            backgroundLayer.transform = CATransform3DMakeRotation(.pi, 0.0, 1.0, 0.0)
            backgroundLayer.fillColor = ColorThemeYellow.cgColor
        } else {
            avatar.frame = CGRect(x: COMMON_MSG_PADDING, y: COMMON_MSG_PADDING, width: 30, height: 30)
            textView.frame = CGRect(x: self.avatar.frame.maxX + COMMON_MSG_PADDING, y: COMMON_MSG_PADDING, width: size.width + TEXT_MSG_CORNER_RADIUS * 2, height: size.height + TEXT_MSG_CORNER_RADIUS * 2)
            backgroundLayer.fillColor = ColorWhite.cgColor
        }
        CATransaction.commit()
        
        indicator.snp.makeConstraints { make in
            make.centerY.equalTo(self.textView)
            make.right.equalTo(self.textView.snp.left).inset(-10)
            make.width.height.equalTo(15);
        }
        tipIcon.snp.makeConstraints { make in
            make.centerY.equalTo(self.textView)
            make.right.equalTo(self.textView.snp.left).inset(10);
            make.width.height.equalTo(15);
        }
    }
}

extension TextMessageCell {
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(onMenuCopy) || action == #selector(onMenuDelete) {
            return true
        }
        return false
    }
    
    @objc func showMenu() {
        self.becomeFirstResponder()
        if !UIMenuController.shared.isMenuVisible {
            UIMenuController.shared.setTargetRect(CGRect(x: textView.bounds.midX - 60, y: 10, width: 120, height: 50), in: textView)
            let copyItem = UIMenuItem(title: "复制", action: #selector(onMenuCopy))
            if UDID_MD5 == chat?.visitor?.udid {
                let deleteItem = UIMenuItem.init(title: "删除", action: #selector(onMenuDelete))
                UIMenuController.shared.menuItems = [copyItem, deleteItem]
            } else {
                UIMenuController.shared.menuItems = [copyItem]
            }
            UIMenuController.shared.setMenuVisible(true, animated: true)
        }
    }
    
    @objc func onMenuCopy() {
        onMenuAction?(.Copy)
    }
    
    @objc func onMenuDelete() {
        onMenuAction?(.Delete)
    }
}

extension TextMessageCell {
    
    func startIndicatorAnim() {
        indicator.isHidden = false
        let rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = Float(CGFloat.pi * 2)
        rotationAnimation.duration = 1.5
        rotationAnimation.repeatCount = Float(MAXFLOAT)
        rotationAnimation.isCumulative = true
        indicator.layer.add(rotationAnimation, forKey: nil)
    }
    
    func stopIndicatorAnim() {
        indicator.isHidden = true
        indicator.layer.removeAllAnimations()
    }
}

extension TextMessageCell {
    
    static func attributes() -> [NSAttributedString.Key:Any] {
        return [.font: BigFont, .foregroundColor:ColorBlack]
    }
    
    static func cellHeight(chat:GroupChat) -> CGFloat {
        var attributedString = NSMutableAttributedString.init(string: chat.msg_content ?? "")
        attributedString.addAttributes(TextMessageCell.attributes(), range: NSRange.init(location: 0, length: attributedString.length))
        attributedString = EmotionHelper.stringToEmotion(attrStr: attributedString)
        let size = attributedString.multiLineSize(width: TEXT_MSG_MAX_WIDTH)
        return size.height + TEXT_MSG_CORNER_RADIUS * 2 + COMMON_MSG_PADDING * 2
    }
    
    static func createBackgroundBezierPath(cornerRadius: CGFloat, width: CGFloat, height: CGFloat) -> UIBezierPath {
        let bezierPath = UIBezierPath.init()
        bezierPath.move(to: CGPoint.init(x: 0, y: cornerRadius))
        bezierPath.addArc(withCenter: CGPoint.init(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: .pi, endAngle: -.pi / 2, clockwise: true)
        bezierPath.addLine(to: CGPoint.init(x: cornerRadius + width, y: 0))
        bezierPath.addArc(withCenter: CGPoint.init(x: cornerRadius + width, y: cornerRadius), radius: cornerRadius, startAngle: -.pi/2, endAngle: 0, clockwise: true)
        bezierPath.addLine(to: CGPoint.init(x: cornerRadius + width + cornerRadius, y: cornerRadius + height))
        bezierPath.addArc(withCenter: CGPoint.init(x: cornerRadius + width, y: cornerRadius + height), radius: cornerRadius, startAngle: 0, endAngle: .pi/2, clockwise: true)
        bezierPath.addLine(to: CGPoint.init(x: cornerRadius + cornerRadius/4, y: cornerRadius + height + cornerRadius))
        bezierPath.addArc(withCenter: CGPoint.init(x: cornerRadius + cornerRadius/4, y: cornerRadius + height), radius: cornerRadius, startAngle: .pi/2, endAngle: .pi, clockwise: true)
        bezierPath.addLine(to: CGPoint.init(x: cornerRadius/4, y: cornerRadius + cornerRadius/4))
        bezierPath.addArc(withCenter: CGPoint.init(x: 0, y: cornerRadius + cornerRadius/4), radius: cornerRadius/4, startAngle: 0, endAngle: -.pi/2, clockwise: false)
        return bezierPath
    }
}

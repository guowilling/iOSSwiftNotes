
import Foundation

protocol HoverTextViewDelegate {
    
    func hoverTextView(_ textView: HoverTextView, stateDidChange isHover: Bool)
    func hoverTextView(_ textView: HoverTextView, sendText text: String)
}

class HoverTextView: UIView {
    
    var delegate: HoverTextViewDelegate?
    
    let LEFT_INSET: CGFloat = 40
    let RIGHT_INSET: CGFloat = 100
    let TOP_BOTTOM_INSET: CGFloat = 15
    
    var textHeight: CGFloat = 0
    var keyboardHeight: CGFloat = 0
    
    var textView: UITextView = UITextView.init()
    var placeHolderLabel: UILabel = UILabel.init()
    var editImageView: UIImageView = UIImageView.init(image: UIImage.init(named: "ic30Pen1"))
    var atImageView: UIImageView = UIImageView.init(image: UIImage.init(named: "ic30WhiteAt"))
    var sendImageView: UIImageView = UIImageView.init(image: UIImage.init(named: "ic30WhiteSend"))
    var topLine: UIView = UIView.init()
    
    init() {
        super.init(frame: ScreenFrame)
        
        setupSubView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubView() {
        self.backgroundColor = ColorClear
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGuesture(sender:))))
        
        textView.delegate = self
        textView.backgroundColor = ColorClear
        textView.clipsToBounds = false
        textView.textColor = ColorWhite
        textView.font = BigFont
        textView.returnKeyType = .send
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets.init(top: TOP_BOTTOM_INSET, left: LEFT_INSET, bottom: TOP_BOTTOM_INSET, right: RIGHT_INSET)
        self.addSubview(textView)
        
        placeHolderLabel.frame = CGRect.init(x: LEFT_INSET, y: 0, width: ScreenWidth - LEFT_INSET - RIGHT_INSET, height: 50)
        placeHolderLabel.text = "有爱评论，说点儿好听的~"
        placeHolderLabel.textColor = ColorWhiteAlpha40
        placeHolderLabel.font = BigFont
        textView.addSubview(placeHolderLabel)
        
        editImageView.frame = CGRect.init(x: 0, y: 0, width: 40, height: 50)
        editImageView.contentMode = .center
        textView.addSubview(editImageView)
        
        atImageView.frame = CGRect.init(x: ScreenWidth - 50, y: 0, width: 50, height: 50)
        atImageView.contentMode = .center
        textView.addSubview(atImageView)
        
        sendImageView.frame = CGRect.init(x: ScreenWidth, y: 0, width: 50, height: 50)
        sendImageView.contentMode = .center
        sendImageView.isUserInteractionEnabled = true
        sendImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onSendAction)))
        textView.addSubview(sendImageView)
        
        topLine = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 0.5))
        topLine.backgroundColor = ColorWhiteAlpha40
        textView.addSubview(topLine)

        textHeight = textView.font?.lineHeight ?? 0
        keyboardHeight = SafeAreaBottomHeight
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.frame = self.superview?.bounds ?? .zero
        updateSubViews()
    }
    
    func updateSubViews() {
        editImageView.image = keyboardHeight > SafeAreaBottomHeight ? UIImage(named: "ic90Pen1") : (textView.text.count > 0 ? UIImage(named: "ic90Pen1") : UIImage(named: "ic30Pen1"))
        atImageView.image = keyboardHeight > SafeAreaBottomHeight ? UIImage(named: "ic90WhiteAt") : (textView.text.count > 0 ? UIImage(named: "ic90WhiteAt") : UIImage(named: "ic30WhiteAt"))
        sendImageView.image = textView.text.count > 0 ? UIImage(named: "ic30RedSend") : UIImage(named: "ic30WhiteSend")
        
        let textViewHeight = keyboardHeight > SafeAreaBottomHeight ? textHeight + 2 * TOP_BOTTOM_INSET : (textView.font?.lineHeight ?? 0) + 2 * TOP_BOTTOM_INSET
        self.textView.frame = CGRect(x: 0, y: ScreenHeight - keyboardHeight - textViewHeight, width: ScreenWidth, height: textViewHeight)
        
        var originX = ScreenWidth
        originX -= keyboardHeight > SafeAreaBottomHeight ? 50 : (textView.text.count > 0 ? 50 : 0)
        UIView.animate(withDuration: 0.25) {
            self.sendImageView.frame = CGRect(x: originX, y: 0, width: 50, height: 50)
            self.atImageView.frame = CGRect(x: self.sendImageView.frame.minX - 50, y: 0, width: 50, height: 50)
        }
    }
}

extension HoverTextView {
    
    @objc func keyboardWillShow(notification:Notification) {
        self.backgroundColor = ColorBlackAlpha40
        keyboardHeight = notification.keyBoardHeight()
        updateSubViews()
        delegate?.hoverTextView(self, stateDidChange: true)
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        self.backgroundColor = ColorClear
        keyboardHeight = SafeAreaBottomHeight
        updateSubViews()
        delegate?.hoverTextView(self, stateDidChange: false)
    }
}

extension HoverTextView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        textView.attributedText = attributedText
        if !textView.hasText {
            placeHolderLabel.isHidden = false
            textHeight = textView.font?.lineHeight ?? 0
        } else {
            placeHolderLabel.isHidden = true
            textHeight = attributedText.multiLineSize(width: ScreenWidth - LEFT_INSET - RIGHT_INSET).height
        }
        updateSubViews()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            onSendAction()
            return false
        } else {
            return true
        }
    }
}

extension HoverTextView {
    
    @objc func onSendAction() {
        delegate?.hoverTextView(self, sendText: textView.text)
        textView.text = ""
        textHeight = textView.font?.lineHeight ?? 0
        textView.resignFirstResponder()
    }
    
    @objc func handleTapGuesture(sender: UITapGestureRecognizer) {
        let point = sender.location(in: self)
        if !textView.frame.contains(point) {
            textView.resignFirstResponder()
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self && hitView?.backgroundColor == ColorClear {
            return nil
        } else {
            return hitView
        }
    }
}

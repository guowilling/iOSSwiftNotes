
import Foundation
import Photos

protocol ChatTextViewDelegate: NSObjectProtocol {
    
    func chatTextView(_ textView: ChatTextView, editBoardHeightDidChange height: CGFloat)
    
    func chatTextView(_ textView: ChatTextView, sendText text: String)
    
    func chatTextView(_ textView: ChatTextView, sendImages images: [UIImage])
}

enum ChatEditMessageType: Int {
    case Text
    case Photo
    case Emotion
    case None
}

class ChatTextView:UIView {
    
    let LEFT_INSET: CGFloat = 15
    let RIGHT_INSET: CGFloat = 85
    let TOP_BOTTOM_INSET: CGFloat = 15
    
    let EMOTION_BTN_TAG: Int = 1000
    let PHOTO_BTN_TAG: Int = 2000
    
    var editMessageType: ChatEditMessageType = .None
    
    var delegate: ChatTextViewDelegate?
    
    var textHeight: CGFloat = 0
    
    @objc dynamic var containerBoardHeight: CGFloat = 0
    
    var container = UIView.init()
    var textView = UITextView.init()
    var placeHolderLabel = UILabel.init()
    var emotionBtn = UIButton.init()
    var photoBtn = UIButton.init()
    var visualEffectView = UIVisualEffectView.init()
    
    lazy var emotionSelector: EmotionSelector = {
        let es = EmotionSelector.init()
        es.delegate = self
        es.addTextViewObserver(textView: textView)
        es.isHidden = true
        container.addSubview(es)
        return es
    }()
    
    lazy var photoSelector:PhotoSelector = {
        let ps = PhotoSelector.init()
        ps.delegate = self
        ps.isHidden = true
        container.addSubview(ps)
        return ps
    }()
    
    init() {
        super.init(frame: ScreenFrame)
        
        setupSubView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        emotionSelector.removeTextViewObserver(textView:textView)
        self.removeObserver(self, forKeyPath: "containerBoardHeight")
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupSubView() {
        self.backgroundColor = ColorClear
        
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleTapGuesture(sender:)))
        tapGestureRecognizer.delegate = self
        self.addGestureRecognizer(tapGestureRecognizer)
        
        container.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: 0)
        container.backgroundColor = ColorThemeGrayDark
        self.addSubview(container)
        
        containerBoardHeight = SafeAreaBottomHeight
        
        textView.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: 0)
        textView.backgroundColor = ColorClear
        textView.font = BigFont
        textView.textColor = ColorWhite
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.textContainerInset = UIEdgeInsets(top: TOP_BOTTOM_INSET, left: LEFT_INSET, bottom: TOP_BOTTOM_INSET, right: RIGHT_INSET)
        textView.textContainer.lineFragmentPadding = 0
        textView.returnKeyType = .send
        textView.clipsToBounds = true
        textView.isScrollEnabled = false
        textView.delegate = self
        textHeight = textView.font?.lineHeight ?? 0
        container.addSubview(textView)
        
        placeHolderLabel.frame = CGRect(x: LEFT_INSET, y: 0, width: ScreenWidth - LEFT_INSET - RIGHT_INSET, height: 50)
        placeHolderLabel.text = "发送消息..."
        placeHolderLabel.textColor = ColorGray
        placeHolderLabel.font = BigFont
        textView.addSubview(placeHolderLabel)
        
        emotionBtn.tag = EMOTION_BTN_TAG
        emotionBtn.setImage(UIImage(named: "baseline_emotion_white"), for: .normal)
        emotionBtn.setImage(UIImage(named: "outline_keyboard_grey"), for: .selected)
        emotionBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGuesture(sender:))))
        textView.addSubview(emotionBtn)
        
        photoBtn.tag = PHOTO_BTN_TAG;
        photoBtn.setImage(UIImage(named: "outline_photo_white"), for: .normal)
        photoBtn.setImage(UIImage(named: "outline_photo_red"), for: .selected)
        photoBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGuesture(sender:))))
        textView.addSubview(photoBtn)
        
        self.addObserver(self, forKeyPath: "containerBoardHeight", options: [.initial, .new], context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateContainerFrame()
        
        photoBtn.frame = CGRect(x: ScreenWidth - 50, y: 0, width: 50, height: 50)
        emotionBtn.frame = CGRect(x: ScreenWidth - 85, y: 0, width: 50, height: 50)
        
        let roundedPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10.0, height: 10.0))
        let maskLayer = CAShapeLayer.init()
        maskLayer.path = roundedPath.cgPath
        container.layer.mask = maskLayer
    }
    
    func updateContainerFrame() {
        let textViewHeight = containerBoardHeight > SafeAreaBottomHeight ? textHeight + 2 * TOP_BOTTOM_INSET : BigFont.lineHeight + 2 * TOP_BOTTOM_INSET
        textView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: textViewHeight)
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.container.frame = CGRect(x: 0, y: ScreenHeight - self.containerBoardHeight - textViewHeight, width: ScreenWidth, height: self.containerBoardHeight + textViewHeight)
            self.delegate?.chatTextView(self, editBoardHeightDidChange: self.container.frame.height)
        })
    }
    
    func updateSelectorFrame(animated: Bool) {
        let textViewHeight = containerBoardHeight > 0 ? textHeight + 2 * TOP_BOTTOM_INSET : BigFont.lineHeight + 2 * TOP_BOTTOM_INSET
        
        if animated {
            switch (self.editMessageType) {
            case .Emotion:
                self.emotionSelector.isHidden = false
                self.emotionSelector.frame = CGRect(x: 0, y: textViewHeight + self.containerBoardHeight, width: ScreenWidth, height: self.containerBoardHeight)
            case .Photo:
                self.photoSelector.isHidden = false
                self.photoSelector.frame = CGRect.init(x: 0, y: textViewHeight + self.containerBoardHeight, width: ScreenWidth, height: self.containerBoardHeight)
            default:
                break
            }
        }
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            switch (self.editMessageType) {
            case .Emotion:
                self.emotionSelector.frame = CGRect(x: 0, y: textViewHeight, width: ScreenWidth, height: self.containerBoardHeight)
                self.photoSelector.frame = CGRect(x: 0, y: textViewHeight + self.containerBoardHeight, width: ScreenWidth, height: self.containerBoardHeight)
            case .Photo:
                self.photoSelector.frame = CGRect(x: 0, y: textViewHeight, width: ScreenWidth, height: self.containerBoardHeight);
                self.emotionSelector.frame = CGRect(x: 0, y: textViewHeight + self.containerBoardHeight, width: ScreenWidth, height: self.containerBoardHeight)
            default:
                self.photoSelector.frame = CGRect(x: 0, y: textViewHeight + self.containerBoardHeight, width: ScreenWidth,  height: self.containerBoardHeight)
                self.emotionSelector.frame = CGRect(x: 0, y: textViewHeight + self.containerBoardHeight, width: ScreenWidth,  height: self.containerBoardHeight)
            }
        }) { finished in
            switch (self.editMessageType) {
            case .Emotion:
                self.photoSelector.isHidden = true
            case .Photo:
                self.emotionSelector.isHidden = true
            default:
                self.photoSelector.isHidden = true
                self.emotionSelector.isHidden = true
            }
        }
    }
    
    func hideContainerBoard() {
        editMessageType = .None;
        containerBoardHeight = SafeAreaBottomHeight
        updateContainerFrame()
        updateSelectorFrame(animated: true)
        textView.resignFirstResponder()
        emotionBtn.isSelected = false
        photoBtn.isSelected = false
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        editMessageType = .Text
        emotionBtn.isSelected = false
        photoBtn.isSelected = false
        containerBoardHeight = notification.keyBoardHeight()
        updateContainerFrame()
        updateSelectorFrame(animated: true)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
//        self.hideContainerBoard()
    }
}

extension ChatTextView {
    func show() {
        if let window = UIApplication.shared.delegate?.window as? UIWindow {
            window.addSubview(self)
        }
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
}

extension ChatTextView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self && editMessageType == .None {
            return nil
        } else {
            return hitView
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "containerBoardHeight" {
            if containerBoardHeight == SafeAreaBottomHeight {
                container.backgroundColor = ColorThemeGrayDark
                textView.textColor = ColorWhite
                emotionBtn.setImage(UIImage(named: "baseline_emotion_white"), for: .normal)
                photoBtn.setImage(UIImage(named: "outline_photo_white"), for: .normal)
            } else {
                container.backgroundColor = ColorWhite
                textView.textColor = ColorBlack
                emotionBtn.setImage(UIImage(named: "baseline_emotion_grey"), for: .normal)
                photoBtn.setImage(UIImage(named: "outline_photo_grey"), for: .normal)
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

extension ChatTextView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            emotionSelectorOnSend(self.emotionSelector)
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        if !textView.hasText {
            placeHolderLabel.isHidden = false
            textHeight = textView.font?.lineHeight ?? 0
        } else {
            placeHolderLabel.isHidden = true
            textHeight = attributedString.multiLineSize(width: ScreenWidth - LEFT_INSET - RIGHT_INSET).height
        }
        updateContainerFrame()
        updateSelectorFrame(animated: false)
    }
}

extension ChatTextView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if NSStringFromClass((touch.view?.superview?.classForCoder)!).contains("EmotionCell") || NSStringFromClass((touch.view?.superview?.classForCoder)!).contains("PhotoCell") {
            return false
        } else {
            return true
        }
    }
    
    @objc func handleTapGuesture(sender: UITapGestureRecognizer) {
        let point = sender.location(in: container)
        if !container.layer.contains(point) {
            hideContainerBoard()
        } else {
            switch sender.view?.tag {
            case EMOTION_BTN_TAG:
                emotionBtn.isSelected = !emotionBtn.isSelected
                photoBtn.isSelected = false
                if emotionBtn.isSelected {
                    editMessageType = .Emotion
                    containerBoardHeight = EMOTION_SELECTOR_HEIGHT
                    updateContainerFrame()
                    updateSelectorFrame(animated: true)
                    textView.resignFirstResponder()
                } else {
                    editMessageType = .Text
                    textView.becomeFirstResponder()
                }
            case PHOTO_BTN_TAG:
                let status = PHPhotoLibrary.authorizationStatus()
                if status == .authorized {
                    DispatchQueue.main.async { [weak self] in
                        self?.photoBtn.isSelected = !(self?.photoBtn.isSelected)!
                        self?.emotionBtn.isSelected = false
                        if (self?.photoBtn.isSelected)! {
                            self?.editMessageType = .Photo
                            self?.containerBoardHeight = PHOTO_SELECTOR_HEIGHT
                            self?.updateContainerFrame()
                            self?.updateSelectorFrame(animated: true)
                            self?.textView.resignFirstResponder()
                        } else {
                            self?.hideContainerBoard()
                        }
                    }
                } else {
                    UIWindow.showTips(text: "请在设置中开启相册读取权限")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
                        UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                    })
                }
            default:
                break
            }
        }
    }
}

extension ChatTextView: EmotionSelectorDelegate {
    
    func emotionSelector(_ selector: EmotionSelector, select emotionKey: String) {
        placeHolderLabel.isHidden = true
        let location = textView.selectedRange.location
        textView.attributedText = EmotionHelper.insertEmotionWithString( attrStr: textView.attributedText, index: location, key: emotionKey)
        textView.selectedRange = NSRange.init(location: location + 1, length: 0)
        textHeight = textView.attributedText.multiLineSize(width: ScreenWidth - LEFT_INSET - RIGHT_INSET).height
        updateContainerFrame()
        updateSelectorFrame(animated: false)
    }
    
    func emotionSelectorOnSend(_ selector: EmotionSelector) {
        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        let text = EmotionHelper.emotionToString(attrStr: attributedString)
        if delegate != nil {
            if textView.hasText {
                delegate?.chatTextView(self, sendText: text.string)
                textView.text = ""
                textHeight = textView.font?.lineHeight ?? 0
                updateContainerFrame()
                updateSelectorFrame(animated: false)
            } else {
                hideContainerBoard()
                UIWindow.showTips(text: "请输入文字")
            }
        }
    }
    
    func emotionSelectorOnDelete(_ selector: EmotionSelector) {
        textView.deleteBackward()
    }
}

extension ChatTextView: PhotoSelectorDelegate {
    func photoSelector(_ selector: PhotoSelector, sendImages images: [UIImage]) {
        delegate?.chatTextView(self, sendImages: images)
    }
}

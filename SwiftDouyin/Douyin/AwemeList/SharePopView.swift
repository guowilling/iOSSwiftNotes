
import Foundation

class SharePopView:UIView {
    
    let topIconsName = ["icon_profile_share_wxTimeline",
                        "icon_profile_share_wechat",
                        "icon_profile_share_qqZone",
                        "icon_profile_share_qq",
                        "icon_profile_share_weibo",
                        "iconHomeAllshareXitong"]
    
    let topTexts = ["朋友圈",
                    "微信好友",
                    "QQ空间",
                    "QQ好友",
                    "微博",
                    "更多分享"]
    
    let bottomIconsName = ["icon_home_allshare_report",
                           "icon_home_allshare_download",
                           "icon_home_allshare_copylink",
                           "icon_home_all_share_dislike"]
    
    let bottomTexts = ["举报",
                       "保存至相册",
                       "复制链接",
                       "不感兴趣"]
    
    var container = UIView.init()
    var cancelBtn = UIButton.init()
    
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
    
    func setupSubView() {
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleTapGuesture(sender:))))
        
        container.frame = CGRect.init(x: 0, y: ScreenHeight, width: ScreenWidth, height: 280 + SafeAreaBottomHeight)
        container.backgroundColor = ColorBlackAlpha60
        self.addSubview(container)
        
        let roundedPath = UIBezierPath(roundedRect: container.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10.0, height: 10.0))
        let maskLayer = CAShapeLayer.init()
        maskLayer.path = roundedPath.cgPath
        container.layer.mask = maskLayer
        
        let visualEffectView = UIVisualEffectView.init(effect: UIBlurEffect(style: .dark))
        visualEffectView.frame = self.bounds
        visualEffectView.alpha = 1.0
        container.addSubview(visualEffectView)
        
        let titleLabel = UILabel.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: ScreenWidth, height: 35)))
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = "分享"
        titleLabel.textColor = ColorGray
        titleLabel.font = MediumFont
        container.addSubview(titleLabel)
        
        let itemWidth = 68
        let firstScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 35, width: ScreenWidth, height: 90))
        firstScrollView.contentSize = CGSize(width: itemWidth * topIconsName.count, height: 80)
        firstScrollView.showsHorizontalScrollIndicator = false
        firstScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        container.addSubview(firstScrollView)
        
        for index in 0..<topIconsName.count {
            let item = ShareItem.init(frame: CGRect.init(x: 20 + itemWidth * index, y: 0, width: 48, height: 90))
            item.icon.image = UIImage(named: topIconsName[index])
            item.label.text = topTexts[index]
            item.tag = index
            item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onFirstItemTap(sender:))))
            item.startAnimation(delayTime: TimeInterval(Double(index) * 0.03))
            firstScrollView.addSubview(item)
        }
        
        let secondScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 135, width: ScreenWidth, height: 90))
        secondScrollView.contentSize = CGSize(width: itemWidth * bottomIconsName.count, height: 80)
        secondScrollView.showsHorizontalScrollIndicator = false
        secondScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        container.addSubview(secondScrollView)
        
        for index in 0..<bottomIconsName.count {
            let item = ShareItem.init(frame: CGRect(x: 20 + itemWidth * index, y: 0, width: 48, height: 90))
            item.icon.image = UIImage.init(named: bottomIconsName[index])
            item.label.text = bottomTexts[index]
            item.tag = index
            item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSecondItemTap(sender:))))
            item.startAnimation(delayTime: TimeInterval(Double(index) * 0.03))
            secondScrollView.addSubview(item)
        }
        
        cancelBtn.frame = CGRect.init(x: 0, y: 230, width: ScreenWidth, height: 50 + SafeAreaBottomHeight)
        cancelBtn.backgroundColor = ColorGrayLight
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(ColorWhite, for: .normal)
        cancelBtn.titleLabel?.font = BigFont
        cancelBtn.titleEdgeInsets = UIEdgeInsets(top: -SafeAreaBottomHeight, left: 0, bottom: 0, right: 0)
        cancelBtn.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onCancelBtnTap(sender:))))
        let cancelBtnRoundedPath = UIBezierPath(roundedRect: cancelBtn.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10.0, height: 10.0))
        let cancelBtnMaskLayer = CAShapeLayer.init()
        cancelBtnMaskLayer.path = cancelBtnRoundedPath.cgPath
        cancelBtn.layer.mask = cancelBtnMaskLayer
        container.addSubview(cancelBtn)
    }
}

extension SharePopView {
    
    @objc func onFirstItemTap(sender: UITapGestureRecognizer) {
        switch sender.view?.tag {
        case 0:
            break
        default:
            break
        }
        dismiss()
    }
    
    @objc func onSecondItemTap(sender: UITapGestureRecognizer) {
        switch sender.view?.tag {
        case 0:
            break
        default:
            break
        }
        dismiss()
    }
    
    @objc func handleTapGuesture(sender: UITapGestureRecognizer) {
        let point = sender.location(in: container)
        if !container.layer.contains(point) {
            dismiss()
        }
    }
    
    @objc func onCancelBtnTap(sender: UIButton) {
        dismiss()
    }
}
    
extension SharePopView {
    
    func show() {
        if let window = UIApplication.shared.delegate?.window as? UIWindow {
            window.addSubview(self)
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                self.container.frame.origin.y = self.container.frame.origin.y - self.container.frame.size.height
            })
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
            self.container.frame.origin.y = self.container.frame.origin.y + self.container.frame.size.height
        }) { finshed in
            self.removeFromSuperview()
        }
    }
}

// MARK: -

class ShareItem: UIView {
    
    var icon = UIImageView.init()
    var label = UILabel.init()
    
    init() {
        super.init(frame: .zero)
        
        setupSubView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubView() {
        icon.contentMode = .scaleToFill
        icon.isUserInteractionEnabled = true
        self.addSubview(icon)
        
        label.text = "TEXT"
        label.textColor = ColorWhiteAlpha60
        label.font = MediumFont
        label.textAlignment = .center
        self.addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(10)
        }
        label.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self.icon.snp.bottom).offset(10)
        }
    }
    
    func startAnimation(delayTime:TimeInterval) {
        let originalFrame = self.frame
        self.frame = CGRect(origin: CGPoint(x: originalFrame.minX, y: 35), size: originalFrame.size)
        UIView.animate(withDuration: 0.9, delay: delayTime, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            self.frame = originalFrame
        })
    }
}


import Foundation

enum RefreshHeaderState: Int {
    case RefreshHeaderStateIdle
    case RefreshHeaderStatePulling
    case RefreshHeaderStateRefreshing
    case RefreshHeaderStateNoMore
}

class RefreshControl: UIControl {
    
    var indicator: UIImageView = UIImageView(image: UIImage(named: "icon60LoadingMiddle"))
    
    var superView: UIScrollView?
    
    var refreshingType: RefreshHeaderState = .RefreshHeaderStateIdle
    
    var onRefresh: (() -> Void)?
    
    init() {
        super.init(frame: CGRect(x: 0, y: -50, width: ScreenWidth, height: 50))
        
        self.addSubview(indicator)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(indicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        superView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        indicator.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.equalTo(25)
        }
        if superView == nil {
            superView = self.superview as? UIScrollView
            superView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            if let superView = self.superview as? UIScrollView {
                if superView.isDragging && refreshingType == .RefreshHeaderStateIdle && superView.contentOffset.y < -80 {
                    refreshingType = .RefreshHeaderStatePulling
                }
                if !superView.isDragging && refreshingType == .RefreshHeaderStatePulling && superView.contentOffset.y >= -50 {
                    beginRefresh()
                    onRefresh?()
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func beginRefresh() {
        if refreshingType != .RefreshHeaderStateRefreshing {
            refreshingType = .RefreshHeaderStateRefreshing
            var edgeInsets = superView?.contentInset
            edgeInsets?.top += 50
            superView?.contentInset = edgeInsets ?? .zero
            startRefreshAnim()
        }
    }
    
    func endRefresh() {
        if refreshingType != .RefreshHeaderStateIdle {
            refreshingType = .RefreshHeaderStateIdle
            var edgeInsets = superView?.contentInset
            edgeInsets?.top -= 50
            superView?.contentInset = edgeInsets ?? .zero
            stopRefreshAnim()
        }
    }
    
    func noMoreData() {
        refreshingType = .RefreshHeaderStateNoMore
        self.isHidden = true
    }
    
    func startRefreshAnim() {
        let rotationAnim = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotationAnim.toValue = NSNumber.init(value: .pi * 2.0)
        rotationAnim.duration = 1.5
        rotationAnim.isCumulative = true
        rotationAnim.repeatCount = MAXFLOAT
        indicator.layer.add(rotationAnim, forKey: "rotationAnimation")
    }
    
    func stopRefreshAnim() {
        indicator.layer.removeAllAnimations()
    }
}

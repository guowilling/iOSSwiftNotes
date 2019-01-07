
import Foundation

class CircleProgress: UIControl {
    
    var _progress: Float = 0
    var progress: Float {
        get {
            return _progress
        }
        set {
            _progress = newValue
            progressLayer.path = bezierPath(progress: newValue).cgPath
        }
    }
    
    var _isTipHidden: Bool = true
    var isTipHidden: Bool {
        get {
            return _isTipHidden
        }
        set {
            _isTipHidden = newValue
            tipIcon.isHidden = _isTipHidden
        }
    }
    
    var progressLayer = CAShapeLayer()
    var tipIcon = UIImageView(image: UIImage(named: "icon_warn_white"))
    
    init() {
        super.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        
        self.setupSubView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubView() {
        self.layer.backgroundColor = ColorBlackAlpha40.cgColor
        self.layer.borderColor = ColorWhiteAlpha80.cgColor
        self.layer.borderWidth = 1.0
        
        progressLayer.fillColor = ColorWhiteAlpha80.cgColor
        self.layer.addSublayer(progressLayer)
        
        tipIcon.contentMode = .center
        self.addSubview(tipIcon)
        _isTipHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.size.width / 2
        
        self.tipIcon.frame = self.bounds
    }
    
    func bezierPath(progress: Float) -> UIBezierPath {
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let bezierPath = UIBezierPath(arcCenter: center, radius: self.frame.width/2 - 2, startAngle: -(.pi / 2) , endAngle: CGFloat(progress) * (.pi * 2) - (.pi / 2), clockwise: true)
        bezierPath.addLine(to: center)
        bezierPath.close()
        return bezierPath
    }
    
    func reset() {
        isTipHidden = true
        progress = 0
    }
}

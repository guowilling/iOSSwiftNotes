
import Foundation

class FavoriteView: UIView {
    
    let LIKE_BEFORE_TAP_ACTION = 1000
    let LIKE_AFTER_TAP_ACTION = 2000
    
    var favoriteBeforeIcon = UIImageView.init(image: UIImage(named: "icon_home_like_before"))
    var favoriteAfterIcon = UIImageView.init(image: UIImage(named: "icon_home_like_after"))
    
    init() {
        super.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 50, height: 45)))
        
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
        favoriteBeforeIcon.frame = self.frame
        favoriteBeforeIcon.contentMode = .center
        favoriteBeforeIcon.isUserInteractionEnabled = true
        favoriteBeforeIcon.tag = LIKE_BEFORE_TAP_ACTION
        favoriteBeforeIcon.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGesture(sender:))))
        self.addSubview(favoriteBeforeIcon)
        
        favoriteAfterIcon.frame = self.frame
        favoriteAfterIcon.contentMode = .center
        favoriteAfterIcon.isUserInteractionEnabled = true
        favoriteAfterIcon.tag = LIKE_AFTER_TAP_ACTION
        favoriteAfterIcon.isHidden = true
        favoriteAfterIcon.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGesture(sender:))))
        self.addSubview(favoriteAfterIcon)
    }
    
    @objc func handleGesture(sender:UITapGestureRecognizer) {
        switch sender.view?.tag {
        case LIKE_BEFORE_TAP_ACTION:
            doAnimation(isLike: true)
        case LIKE_AFTER_TAP_ACTION:
            doAnimation(isLike: false)
        default:
            break
        }
    }
    
    func doAnimation(isLike: Bool) {
        favoriteBeforeIcon.isUserInteractionEnabled = false
        favoriteAfterIcon.isUserInteractionEnabled = false
        if isLike {
            let length: CGFloat = 30
            let duration: CGFloat = 0.5
            for index in 0..<6 {
                let layer = CAShapeLayer.init()
                layer.position = favoriteBeforeIcon.center
                layer.fillColor = ColorThemeRed.cgColor
                
                let startPath = UIBezierPath.init()
                startPath.move(to: CGPoint.init(x: -2, y: -length))
                startPath.addLine(to: CGPoint.init(x: 2, y: -length))
                startPath.addLine(to: .zero)
                
                let endPath = UIBezierPath.init()
                endPath.move(to: CGPoint.init(x: -2, y: -length))
                endPath.addLine(to: CGPoint.init(x: 2, y: -length))
                endPath.addLine(to: CGPoint.init(x: 0, y: -length))
                
                layer.path = startPath.cgPath
                layer.transform = CATransform3DMakeRotation(.pi / 3.0 * CGFloat(index), 0.0, 0.0, 1.0)
                self.layer.addSublayer(layer)
                
                let animGroup = CAAnimationGroup.init()
                animGroup.isRemovedOnCompletion = false
                animGroup.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
                animGroup.fillMode = CAMediaTimingFillMode.forwards
                animGroup.duration = CFTimeInterval(duration)
                
                let scaleAnim = CABasicAnimation.init(keyPath: "transform.scale")
                scaleAnim.fromValue = 0.0
                scaleAnim.toValue = 1.0
                scaleAnim.duration = CFTimeInterval(duration * 0.2)
                
                let pathAnim = CABasicAnimation.init(keyPath: "path")
                pathAnim.fromValue = layer.path
                pathAnim.toValue = endPath.cgPath
                pathAnim.beginTime = CFTimeInterval(duration * 0.2)
                pathAnim.duration = CFTimeInterval(duration * 0.8)
                
                animGroup.animations = [scaleAnim, pathAnim]
                layer.add(animGroup, forKey: nil)
            }
            favoriteAfterIcon.isHidden = false
            favoriteAfterIcon.alpha = 0.0
            favoriteAfterIcon.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5).concatenating(CGAffineTransform.init(rotationAngle: .pi / 3 * 2))
            UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
                self.favoriteAfterIcon.alpha = 1.0
                self.favoriteAfterIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(rotationAngle: 0))
                self.favoriteBeforeIcon.alpha = 0.0
            }) { finished in
                self.favoriteAfterIcon.isUserInteractionEnabled = true
                self.favoriteBeforeIcon.isUserInteractionEnabled = true
                self.favoriteBeforeIcon.alpha = 1.0
            }
        } else {
            favoriteAfterIcon.alpha = 1.0
            favoriteAfterIcon.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform.init(rotationAngle: 0))
            UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseIn, animations: {
                self.favoriteAfterIcon.transform = CGAffineTransform(scaleX: 0.1, y: 0.1).concatenating(CGAffineTransform(rotationAngle: .pi / 4))
            }) { finished in
                self.favoriteAfterIcon.isHidden = true
                self.favoriteBeforeIcon.isUserInteractionEnabled = true
                self.favoriteAfterIcon.isUserInteractionEnabled = true
            }
        }
    }
    
    func reset() {
        favoriteBeforeIcon.isHidden = false
        favoriteAfterIcon.isHidden = true
        self.layer.removeAllAnimations()
    }
}

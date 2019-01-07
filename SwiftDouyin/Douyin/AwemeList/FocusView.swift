
import Foundation

class FocusIcon: UIImageView {
    
    init() {
        super.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 24, height: 24)))
        
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
        self.layer.cornerRadius = frame.size.width / 2
        self.layer.backgroundColor = ColorThemeRed.cgColor
        
        self.image = UIImage(named: "icon_personal_add_little")
        self.contentMode = .center
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(beginAnimation)))
    }
    
    @objc func beginAnimation() {
        let animationGroup = CAAnimationGroup.init()
        animationGroup.delegate = self
        animationGroup.duration = 1.25
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = CAMediaTimingFillMode.forwards
        animationGroup.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let scaleAnim = CAKeyframeAnimation.init(keyPath: "transform.scale")
        scaleAnim.values = [1.0, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 0.0]
        
        let rotationAnim = CAKeyframeAnimation.init(keyPath: "transform.rotation")
        rotationAnim.values = [-1.5 * .pi, 0.0, 0.0, 0.0]
        
        let opacityAnim = CAKeyframeAnimation.init(keyPath: "opacity")
        opacityAnim.values = [0.8, 1.0, 1.0]
        
        animationGroup.animations = [scaleAnim, rotationAnim, opacityAnim]
        self.layer.add(animationGroup, forKey: nil)
    }
    
    func reset() {
        self.image = UIImage.init(named: "icon_personal_add_little")
        self.layer.removeAllAnimations()
        self.layer.backgroundColor = ColorThemeRed.cgColor
        self.isHidden = false
    }
}

extension FocusIcon: CAAnimationDelegate {
    
    func animationDidStart(_ anim: CAAnimation) {
        self.image = UIImage.init(named: "iconSignDone")
        self.contentMode = .scaleToFill
        self.layer.backgroundColor = ColorThemeRed.cgColor
        self.isUserInteractionEnabled = false
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.isUserInteractionEnabled = true
        self.contentMode = .center
        self.isHidden = true
    }
}


import Foundation

class MusicAlbumView: UIView {
    
    var albumContainer = UIView.init()
    
    var album: UIImageView = UIImageView.init()
    
    var noteLayers = [CALayer]()
    
    init() {
        super.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 50, height: 50)))
        
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
        albumContainer.frame = self.bounds
        self.addSubview(albumContainer)
        
        let backgroundLayer = CALayer.init()
        backgroundLayer.frame = self.bounds
        backgroundLayer.contents = UIImage.init(named: "music_cover")?.cgImage
        albumContainer.layer.addSublayer(backgroundLayer)
        
        album.frame = CGRect.init(x: 15, y: 15, width: 20, height: 20)
        album.contentMode = .scaleAspectFill
        albumContainer.addSubview(album)
    }
    
    func startAnimation(rate: CGFloat) {
        guard rate > 0 else { return }
        
        reset()

        musicNoteAnimation(imageName: "icon_home_musicnote1", delayTime: 0.0, rate: rate)
        musicNoteAnimation(imageName: "icon_home_musicnote2", delayTime: 1.0, rate: rate)
        musicNoteAnimation(imageName: "icon_home_musicnote1", delayTime: 2.0, rate: rate)
        
        let rotationAnim = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotationAnim.toValue = .pi * 2.0
        rotationAnim.duration = 3.0
        rotationAnim.isCumulative = true
        rotationAnim.repeatCount = MAXFLOAT
        albumContainer.layer.add(rotationAnim, forKey: "rotationAnimation")
    }
    
    func musicNoteAnimation(imageName:String, delayTime:TimeInterval, rate:CGFloat) {
        let animationGroup = CAAnimationGroup.init()
        animationGroup.duration = CFTimeInterval(rate/4.0)
        animationGroup.beginTime = CACurrentMediaTime() + delayTime
        animationGroup.repeatCount = .infinity
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = CAMediaTimingFillMode.forwards
        animationGroup.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)
        
        let pathAnim = CAKeyframeAnimation.init(keyPath: "position")
        let sideXLength: CGFloat = 40.0
        let sideYLength: CGFloat = 100.0
        let beginPoint = CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
        let endPoint = CGPoint(x: beginPoint.x - sideXLength, y: beginPoint.y - sideYLength)
        let controlLength: CGFloat = 60
        let controlPoint = CGPoint(x: beginPoint.x - sideXLength/2 - controlLength, y: beginPoint.y - sideYLength/2 + controlLength)
        let customPath = UIBezierPath.init()
        customPath.move(to: beginPoint)
        customPath.addQuadCurve(to: endPoint, controlPoint: controlPoint)
        pathAnim.path = customPath.cgPath
        
        let rotationAnim = CAKeyframeAnimation.init(keyPath: "transform.rotation")
        rotationAnim.values = [0.0, .pi * 0.1, .pi * -0.1]
        
        let opacityAnim = CAKeyframeAnimation.init(keyPath: "opacity")
        opacityAnim.values = [0.0, 0.2, 0.7, 0.2, 0.0]
        
        let scaleAnim = CABasicAnimation.init()
        scaleAnim.keyPath = "transform.scale"
        scaleAnim.fromValue = 1.0
        scaleAnim.toValue = 2.0
        
        animationGroup.animations = [pathAnim, rotationAnim, opacityAnim, scaleAnim]
        
        let layer = CAShapeLayer.init()
        layer.opacity = 0.0
        layer.contents = UIImage(named: imageName)?.cgImage
        layer.frame = CGRect(origin: beginPoint, size: CGSize.init(width: 10, height: 10))
        layer.add(animationGroup, forKey: nil)
        self.layer.addSublayer(layer)
        
        noteLayers.append(layer)
    }
    
    func reset() {
        for subLayer in noteLayers {
            subLayer.removeFromSuperlayer()
        }
        self.layer.removeAllAnimations()
    }
}

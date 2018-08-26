
import UIKit
import pop

class EmoticonTipView: UIImageView {

    private var preEmoticon: Emoticon?
    
    var emoticon: Emoticon? {
        didSet {
            if emoticon == preEmoticon {
                return
            }
            preEmoticon = emoticon
            
            tipButton.setTitle(emoticon?.emoji, for: [])
            tipButton.setImage(emoticon?.image, for: [])
            
            // 弹力动画的结束时间是根据速度自动计算的, 不需要也不能指定 duration.
            let anim: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            anim.fromValue = 30
            anim.toValue = 8
            anim.springBounciness = 20
            anim.springSpeed = 20
            tipButton.layer.pop_add(anim, forKey: nil)
        }
    }
    
    // MARK: - 私有控件
    private lazy var tipButton = UIButton()
    
    // MARK: - 构造函数
    init() {
        let bundle = EmoticonManager.shared.bundle
        let image = UIImage(named: "emoticon_keyboard_magnifier", in: bundle, compatibleWith: nil)
        
        // 此方法会根据图片大小自动设置视图的大小
        //[[UIImageView alloc] initWithImage: image]
        super.init(image: image)
        
        // 设置锚点
        layer.anchorPoint = CGPoint(x: 0.5, y: 1.2)
        
        // 添加按钮
        tipButton.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        tipButton.frame = CGRect(x: 0, y: 8, width: 36, height: 36)
        tipButton.center.x = bounds.width * 0.5
        tipButton.setTitle("😄", for: [])
        tipButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        addSubview(tipButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

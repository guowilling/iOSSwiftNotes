
import UIKit
import SDWebImage

class WBWelcomeView: UIView {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    @IBOutlet weak var iconWidthCons: NSLayoutConstraint!
    
    class func welcomeView() -> WBWelcomeView {
        let welcomeNib = UINib(nibName: "WBWelcomeView", bundle: nil)
        let welcomeView = welcomeNib.instantiate(withOwner: nil, options: nil)[0] as! WBWelcomeView
        welcomeView.frame = UIScreen.main.bounds
        return welcomeView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        guard let urlString = WBNetworkManager.shared.userAccount.avatar_large,
            let url = URL(string: urlString) else {
            return
        }
        iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"))
        iconView.layer.cornerRadius = iconWidthCons.constant * 0.5
        iconView.layer.masksToBounds = true
    }
    
    // 自动布局完成后会调用此方法, 通常在此方法对子视图进行布局
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // 视图被添加到 window, 此时视图已经显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        // 视图使用自动布局设置了约束, 当视图被添加到窗口上时, 会根据父视图的大小计算约束, 更新视图位置
        
        self.layoutIfNeeded() // layoutIfNeeded 直接根据当前的约束更新视图位置
        
        bottomCons.constant = bounds.size.height - 200
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 1.0, animations: {
                self.tipLabel.alpha = 1
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        }
    }
}

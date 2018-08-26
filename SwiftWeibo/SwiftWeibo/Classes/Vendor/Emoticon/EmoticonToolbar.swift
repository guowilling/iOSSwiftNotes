
import UIKit

@objc protocol EmoticonToolbarDelegate: NSObjectProtocol {
    
    func emoticonToolbarDidSelectedItemIndex(toolbar: EmoticonToolbar, index: Int)
}

/// 表情键盘底部工具栏
class EmoticonToolbar: UIView {

    weak var delegate: EmoticonToolbarDelegate?
    
    var selectedIndex: Int = 0 {
        didSet {
            for btn in subviews as! [UIButton] {
                btn.isSelected = false
            }
            (subviews[selectedIndex] as! UIButton).isSelected = true
        }
    }
    
    override func awakeFromNib() {
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let count = subviews.count
        let width = bounds.width / CGFloat(count)
        let rect = CGRect(x: 0, y: 0, width: width, height: bounds.height)
        for (i, btn) in subviews.enumerated() {
            btn.frame = rect.offsetBy(dx: CGFloat(i) * width, dy: 0)
        }
    }
}

private extension EmoticonToolbar {
    
    func setupUI() {
        let manager = EmoticonManager.shared
        
        // 通过表情包的分组名称创建按钮
        for (i, package) in manager.packages.enumerated() {
            let btn = UIButton()
            btn.setTitle(package.groupName, for: [])
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.setTitleColor(UIColor.white, for: [])
            btn.setTitleColor(UIColor.darkGray, for: .highlighted)
            btn.setTitleColor(UIColor.darkGray, for: .selected)

            // 背景图片
            let imageName = "compose_emotion_table_\(package.bgImageName ?? "")_normal"
            let imageNameHL = "compose_emotion_table_\(package.bgImageName ?? "")_selected"
            var image = UIImage(named: imageName, in: manager.bundle, compatibleWith: nil)
            var imageHL = UIImage(named: imageNameHL, in: manager.bundle, compatibleWith: nil)
            
            // 图片拉伸
            let size = image?.size ?? CGSize()
            let inset = UIEdgeInsets(top: size.height * 0.5, left: size.width * 0.5, bottom: size.height * 0.5, right: size.width * 0.5)
            image = image?.resizableImage(withCapInsets: inset)
            imageHL = imageHL?.resizableImage(withCapInsets: inset)
            btn.setBackgroundImage(image, for: [])
            btn.setBackgroundImage(imageHL, for: .highlighted)
            btn.setBackgroundImage(imageHL, for: .selected)
            btn.sizeToFit()
            btn.tag = i
            btn.addTarget(self, action: #selector(clickItem), for: .touchUpInside)
            addSubview(btn)
        }
        
        (subviews[0] as! UIButton).isSelected = true // 默认选中第 0 个按钮
    }
    
    @objc func clickItem(button: UIButton) {
        delegate?.emoticonToolbarDidSelectedItemIndex(toolbar: self, index: button.tag)
    }
}

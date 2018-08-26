
import UIKit

@objc protocol EmoticonCellDelegate: NSObjectProtocol {
    /// - parameter em: 表情模型 / nil 表示删除
    func emoticonCellDidSelectedEmoticon(cell: EmoticonCell, em: Emoticon?)
}

class EmoticonCell: UICollectionViewCell {
    
    weak var delegate: EmoticonCellDelegate?
    
    /// 当前页面的表情模型数组最多 20 个
    var emoticons: [Emoticon]? {
        didSet {
            for subBtn in contentView.subviews {
                subBtn.isHidden = true
            }
            contentView.subviews.last?.isHidden = false
            
            // 遍历表情模型数组, 设置按钮图像
            for (i, em) in (emoticons ?? []).enumerated() {
                if let btn = contentView.subviews[i] as? UIButton {
                    btn.setImage(em.image, for: []) // 设置图像, 如果图像为 nil 会清空图像, 避免复用
                    btn.setTitle(em.emoji, for: []) // 设置 emoji 的字符串, 如果 emoji 为 nil 会清空 title, 避免复用
                    btn.isHidden = false
                }
            }
        }
    }
    
    private lazy var tipView = EmoticonTipView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 视图从界面上删除同样会调用此方法, 此时newWindow == nil
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        guard let window = newWindow else {
            return
        }
        // 提示视图添加到窗口上, 很多程序员都喜欢把控件往窗口添加, 尽量少用窗口!
        window.addSubview(tipView)
        tipView.isHidden = true
    }
    
    // MARK: - 设置界面
    // 1. xib 加载, bounds 是 xib 中设置的大小, 不是布局属性 itemSize
    // 2. 纯代码创建, bounds 是布局属性 itemSize
    func setupUI() {
        let rowCount = 3
        let colCount = 7
        
        // 左右间距
        let leftMargin: CGFloat = 8
        
        // 底部间距为分页控件预留空间
        let bottomMargin: CGFloat = 16
        
        let w = (bounds.width - 2 * leftMargin) / CGFloat(colCount)
        let h = (bounds.height - bottomMargin) / CGFloat(rowCount)
        
        // 创建 21 个按钮
        for i in 0..<21 {
            let row = i / colCount
            let col = i % colCount
            let btn = UIButton()
            let x = leftMargin + CGFloat(col) * w
            let y = CGFloat(row) * h
            btn.frame = CGRect(x: x, y: y, width: w, height: h)
            contentView.addSubview(btn)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            btn.tag = i
            btn.addTarget(self, action: #selector(selectedEmoticonButton), for: .touchUpInside)
        }
        
        // 删除按钮
        let removeButton = contentView.subviews.last as! UIButton
        let image = UIImage(named: "compose_emotion_delete_highlighted", in: EmoticonManager.shared.bundle, compatibleWith: nil)
        removeButton.setImage(image, for: [])
        
        // 长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longGesture))
        longPress.minimumPressDuration = 0.1
        addGestureRecognizer(longPress)
    }
    
    // MARK: - 监听方法
    @objc fileprivate func selectedEmoticonButton(button: UIButton) {
        var em: Emoticon?
        if button.tag < (emoticons?.count)! { // tag == 20 是删除按钮
            em = emoticons?[button.tag]
        }
        delegate?.emoticonCellDidSelectedEmoticon(cell: self, em: em)
    }
    
    /// 长按手势识别: 非常非常重要的手势, 可以保证一个对象监听两种点击手势, 不需要考虑解决手势冲突!
    @objc fileprivate func longGesture(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: self)
        guard let button = buttonWithLocation(location: location) else {
            tipView.isHidden = true
            return
        }
        switch gesture.state {
        case .began, .changed:
            tipView.isHidden = false
            // 坐标系的转换: 按钮参照 cell 的坐标系转换到 window 的坐标系.
            let center = self.convert(button.center, to: window)
            tipView.center = center
            if button.tag < (emoticons?.count)! {
                tipView.emoticon = emoticons?[button.tag]
            }
        case .ended:
            tipView.isHidden = true
            selectedEmoticonButton(button: button)
        case .cancelled, .failed:
            tipView.isHidden = true
        default: break
        }
    }
    
    private func buttonWithLocation(location: CGPoint) -> UIButton? {
        for btn in contentView.subviews as! [UIButton] {
            if btn.frame.contains(location) && !btn.isHidden && btn != contentView.subviews.last {
                return btn
            }
        }
        return nil
    }
}

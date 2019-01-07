
import Foundation

class MenuPopView: UIView {
    
    var container = UIView.init()
    var cancelBtn = UIButton.init()
    
    var onAction: ((_ index: Int) -> Void)?
    
    private var _titles = [String]()
    var titles: [String] {
        get {
            return _titles
        }
        set {
            _titles = newValue.reversed()
            setupSubView()
        }
    }
    
    init(titles: [String]) {
        super.init(frame: ScreenFrame)
        
        self.titles = titles
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubView() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCancel(sender:))))
        container.frame = CGRect.init(x: 0, y: ScreenHeight, width: ScreenWidth, height: CGFloat(titles.count + 1) * 70)
        container.backgroundColor = ColorClear
        self.addSubview(container)
        
        cancelBtn.frame = CGRect.init(x: 8, y: container.frame.size.height - 63, width: ScreenWidth - 16, height: 55)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(ColorBlue, for: .normal)
        cancelBtn.titleLabel?.font = LargeBoldFont
        cancelBtn.layer.cornerRadius = 10
        cancelBtn.backgroundColor = ColorWhite
        container.addSubview(cancelBtn)
        cancelBtn.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onCancel(sender:))))
        
        for index in 0..<titles.count {
            let button = UIButton.init(frame: CGRect.init(x: 8, y: container.frame.size.height - CGFloat(63 * (index + 2)), width: ScreenWidth - 16, height: 55))
            button.setTitle(titles[index], for: .normal)
            button.setTitleColor(ColorBlue, for: .normal)
            button.titleLabel?.font = LargeFont
            button.layer.cornerRadius = 10
            button.backgroundColor = ColorWhiteAlpha80
            button.tag = index
            button.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(action(sender:))))
            container.addSubview(button)
        }
    }
    
    @objc func action(sender:UITapGestureRecognizer) {
        onAction?(sender.view?.tag ?? 0)
        dismiss()
    }
    
    @objc func onCancel(sender:UITapGestureRecognizer) {
        var point = sender.location(in: container)
        if !container.layer.contains(point) {
            dismiss()
            return
        }
        point = sender.location(in: cancelBtn)
        if cancelBtn.layer.contains(point) {
            dismiss()
        }
    }
    
    func show() {
        let window = UIApplication.shared.delegate?.window as? UIWindow
        window?.addSubview(self)
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
            var frame = self.container.frame
            frame.origin.y -= frame.size.height
            self.container.frame = frame
        })
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
            var frame = self.container.frame
            frame.origin.y += frame.size.height
            self.container.frame = frame
        }) { finished in
            self.removeFromSuperview()
        }
    }
}

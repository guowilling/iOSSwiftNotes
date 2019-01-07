
import Foundation

class PhotoBroswer: UIView {
    
    var circleProgress: CircleProgress = CircleProgress.init()
    var container:UIView = UIView.init()
    var imageView:UIImageView = UIImageView.init()
    
    var _urlString: String?
    var urlString: String? {
        get {
            return _urlString
        }
        set {
            if newValue == nil || newValue == "" {
                return
            }
            _urlString = newValue
            if let url = URL(string: _urlString ?? "") {
                imageView.setImageWithURL(imageURL: url, progress: { percent in
                    self.circleProgress.progress = percent
                }, completed: { [weak self] (image, error) in
                    if image != nil {
                        self?.imageView.image = image
                        self?.circleProgress.isHidden = true
                    } else {
                        self?.circleProgress.isTipHidden = false
                    }
                }) 
            }
        }
    }
    
    var _image: UIImage?
    var image: UIImage? {
        get {
            return _image
        }
        set {
            if newValue == nil {
                return
            }
            _image = newValue
            imageView.image = image
        }
    }
    
    init(_ urlString: String? = "", _ image: UIImage? = UIImage()) {
        super.init(frame: ScreenFrame)
        
        self.urlString = urlString
        self.image = image
        
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
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleTapGuesture(sender:))))
        
        container.frame = self.bounds
        container.backgroundColor = ColorBlack
        container.alpha = 0.0
        self.addSubview(container)
        
        imageView.frame = self.bounds
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        
        circleProgress.center = self.center
        circleProgress.isTipHidden = true
        imageView.addSubview(circleProgress)
    }
    
    @objc func handleTapGuesture(sender:UITapGestureRecognizer) {
        dismiss()
    }
    
    func show() {
        guard let window = UIApplication.shared.delegate?.window as? UIWindow else { return }
        window.windowLevel = UIWindow.Level.statusBar
        window.addSubview(self)
        UIView.animate(withDuration: 0.25) {
            self.imageView.alpha = 1.0
            self.container.alpha = 1.0
        }
    }
    
    func dismiss() {
        guard let window = UIApplication.shared.delegate?.window as? UIWindow else { return }
        window.windowLevel = UIWindow.Level.normal
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
            self.imageView.alpha = 0.0
            self.container.alpha = 0.0
        }) { finished in
            self.removeFromSuperview()
        }
    }
}

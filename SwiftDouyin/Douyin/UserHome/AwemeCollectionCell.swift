
import Foundation

class AwemeCollectionCell: UICollectionViewCell {
    
//    var imageView: WebPImageView = WebPImageView.init()
    var imageView: UIImageView = UIImageView.init()
    
    var favoriteNum: UIButton = UIButton.init()
    
    var _isHighlighted: Bool = false
    
    override var isHighlighted: Bool {
        get {
            return false
        }
        set {
            _isHighlighted = newValue
        }
    }
    
    var aweme: Aweme? {
        didSet {
            guard let aweme = aweme else { return }
//            imageView.setWebPImageWithURL(imageURL: URL.init(string: (aweme.video?.dynamic_cover?.url_list.first) ?? "")!, completed: { [weak self] (image, error) in
//                if let img = image as? WebPImage {
//                    self?.imageView.image = img
//                }
//            })
            guard let urlString = aweme.video?.cover?.url_list.last else { return }
            imageView.setImageWithURL(imageURL: URL(string: urlString)!) { (image, error) in
                if let img = image {
                    self.imageView.image = img
                }
            }
            favoriteNum.setTitle(String.formatCount(count: aweme.statistics?.digg_count ?? 0), for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.backgroundColor = ColorThemeGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [ColorClear.cgColor, ColorBlackAlpha20.cgColor, ColorBlackAlpha60.cgColor]
        gradientLayer.locations = [0.3, 0.6, 1.0]
        gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint.init(x: 0.0, y: 1.0)
        gradientLayer.frame = CGRect.init(x: 0, y: self.frame.size.height - 100, width: self.frame.size.width, height: 100)
        imageView.layer.addSublayer(gradientLayer)
        
        favoriteNum.contentHorizontalAlignment = .left
        favoriteNum.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 2, bottom: 0, right: 0)
        favoriteNum.setTitle("0", for: .normal)
        favoriteNum.setTitleColor(ColorWhite, for: .normal)
        favoriteNum.titleLabel?.font = SmallFont
        favoriteNum.setImage(UIImage.init(named: "icon_home_likenum"), for: .normal)
        favoriteNum.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -2, bottom: 0, right: 0)
        self.addSubview(favoriteNum)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = self.bounds
        favoriteNum.frame = CGRect.init(x: 10, y: self.bounds.size.height - 20, width: self.bounds.size.width - 20, height: 12)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
}

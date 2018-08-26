
import UIKit

class WBStatusPictureView: UIView {
    
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        setupUI()
    }
    
    var viewModel: WBStatusViewModel? {
        didSet {
            calcViewSize()
            urls = viewModel?.picURLs
        }
    }
    
    /// 根据视图模型的配图视图大小调整
    private func calcViewSize() {
        if viewModel?.picURLs?.count == 1 { // 单图
            let viewSize = viewModel?.pictureViewSize ?? CGSize()
            let subView = subviews[0]
            subView.frame = CGRect(x: 0,
                                   y: WBStatusPictureViewOutterMargin,
                                   width: viewSize.width,
                                   height: viewSize.height - WBStatusPictureViewOutterMargin)
        } else { // 多图或无图, 恢复 subview[0] 的宽高保证九宫格布局的完整
            let subView = subviews[0]
            subView.frame = CGRect(x: 0,
                             y: WBStatusPictureViewOutterMargin,
                             width: WBStatusPictureItemWidth,
                             height: WBStatusPictureItemWidth)
        }
        
        heightCons.constant = viewModel?.pictureViewSize.height ?? 0 // 更新高度约束
    }
    
    /// 配图数组
    private var urls: [WBStatusPicture]? {
        didSet {
            // 隐藏所有 imageView
            for imageView in subviews {
                imageView.isHidden = true
            }
            
            // 遍历 urls 设置 imageView
            var index = 0
            for url in urls ?? [] {
                let imageView = subviews[index] as! UIImageView
                if index == 1 && urls?.count == 4 { // 4 张图片特殊处理
                    index += 1
                }
                //imageView.wb_setImage(urlString: url.thumbnail_pic, placeholderImage: nil)
                imageView.wb_setImage(urlString: url.largePic, placeholderImage: nil)
                imageView.subviews[0].isHidden = (((url.thumbnail_pic ?? "") as NSString).pathExtension.lowercased() != "gif")
                imageView.isHidden = false
                index += 1
            }
        }
    }
}

// MARK: - Setup UI
extension WBStatusPictureView {
    
    fileprivate func setupUI() {
        backgroundColor = superview?.backgroundColor
        clipsToBounds = true
        
        let count = 3
        let rect = CGRect(x: 0,
                          y: WBStatusPictureViewOutterMargin,
                          width: WBStatusPictureItemWidth,
                          height: WBStatusPictureItemWidth)
        
        for i in 0..<count * count {
            let imageView = UIImageView()
            imageView.tag = i
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            let row = CGFloat(i / count)
            let col = CGFloat(i % count)
            let xOffset = col * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            let yOffset = row * (WBStatusPictureItemWidth + WBStatusPictureViewInnerMargin)
            imageView.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            imageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapImageView))
            imageView.addGestureRecognizer(tap)
            addSubview(imageView)
            addGifView(imageView: imageView)
        }
    }
    
    private func addGifView(imageView: UIImageView) {
        let gifImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
        imageView.addSubview(gifImageView)
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addConstraint(NSLayoutConstraint(
            item: gifImageView,
            attribute: .right,
            relatedBy: .equal,
            toItem: imageView,
            attribute: .right,
            multiplier: 1.0,
            constant: 0))
        imageView.addConstraint(NSLayoutConstraint(
            item: gifImageView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: imageView,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0))
    }
    
    @objc fileprivate func tapImageView(tap: UITapGestureRecognizer) {
        guard let tapedImageView = tap.view,
            let picURLs = viewModel?.picURLs else {
                return
        }
        var selectedIndex = tapedImageView.tag
        if picURLs.count == 4 && selectedIndex > 1 {
            selectedIndex -= 1
        }
        var imageViews = [UIImageView]()
        for imageView in subviews as! [UIImageView] {
            if !imageView.isHidden {
                imageViews.append(imageView)
            }
        }
        _ = (picURLs as NSArray).value(forKey: "largePic") as! [String]
    }
}

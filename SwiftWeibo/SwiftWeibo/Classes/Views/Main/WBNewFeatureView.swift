
import UIKit

class WBNewFeatureView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBAction func enterStatus() {
        removeFromSuperview()
    }
    
    class func newFeatureView() -> WBNewFeatureView {
        let newFeatureNib = UINib(nibName: "WBNewFeatureView", bundle: nil)
        let newFeatureView = newFeatureNib.instantiate(withOwner: nil, options: nil)[0] as! WBNewFeatureView
        newFeatureView.frame = UIScreen.main.bounds
        return newFeatureView
    }
    
    override func awakeFromNib() {
        enterButton.isHidden = true
        let count = 4
        let rect = UIScreen.main.bounds
        for i in 0..<count {
            let imageName = "new_feature_\(i + 1)"
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: rect.height)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
    }
}

extension WBNewFeatureView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        enterButton.isHidden = true
        
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        pageControl.currentPage = page
        pageControl.isHidden = (page == scrollView.subviews.count)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        enterButton.isHidden = (page != scrollView.subviews.count - 1)
        if page == scrollView.subviews.count {
            removeFromSuperview()
        }
    }
}

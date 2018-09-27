
import UIKit

typealias GridBtnClick = (_ tag: Int) -> Void

class RecommendBannerGrid: UIView {
    
    var gridBtnClick: GridBtnClick?
    
    open var titleArray: Array<String> = []
    
    open var btnImageArray: Array<String> = [] {
        didSet {
            setupUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI() {
        let nums: CGFloat = CGFloat(titleArray.count * 2 + 1)
        let margin: CGFloat = self.frame.width/nums
        for index in 0..<titleArray.count {
            let button = UIButton.init(frame: CGRect(x: margin*CGFloat(index)*2+margin,
                                                     y: 10,
                                                     width: margin,
                                                     height: margin))
            button.layer.masksToBounds = true
            button.layer.cornerRadius = button.frame.width/2
            button.kf.setImage(with: URL(string:btnImageArray[index]), for: UIControlState.normal)
            button.tag = index
            button.addTarget(self, action: #selector(gridBtnClick(button:)), for: UIControlEvents.touchUpInside)
            self.addSubview(button)
            
            let label = UILabel()
            label.textAlignment = .center
            label.text = titleArray[index]
            label.font = UIFont.systemFont(ofSize: 15)
            self.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.centerX.equalTo(button)
                make.width.equalTo(margin+20)
                make.top.equalTo(margin+10+5)
            })
        }
    }
    
    @objc func gridBtnClick(button: UIButton) {
        guard let gridBtnClick = gridBtnClick else {
            return
        }
        gridBtnClick(button.tag)
    }
}

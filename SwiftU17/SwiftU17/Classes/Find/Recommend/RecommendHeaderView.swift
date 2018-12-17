
import UIKit

typealias HeaderMoreBtnClick = () -> Void

class RecommendHeaderView: UICollectionReusableView {
    
    var headerMoreBtnClick: HeaderMoreBtnClick?
    
    lazy var imageView = UIImageView()
    
    lazy var titleL = UILabel()
    
    lazy var moreBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
            btn.setImage(UIImage(named:"small_change"), for: UIControl.State.normal)
            btn.addTarget(self,
                          action: #selector(btnChange(button:)),
                          for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    func setupUI() {
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.left.equalTo(10)
            make.top.equalTo(5)
        }
        
        self.addSubview(self.titleL)
        self.titleL.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.left.equalTo(40)
            make.height.equalTo(30)
            make.top.equalTo(5)
        }
        
        self.addSubview(self.moreBtn)
        self.moreBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalTo(0)
            make.right.equalTo(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func btnChange(button:UIButton) {
        guard let headerMoreBtnClick = headerMoreBtnClick else {
            return
        }
        headerMoreBtnClick()
    }
}

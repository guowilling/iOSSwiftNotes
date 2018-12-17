
import UIKit

class U17RankCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect(x: 10, y: 10, width: self.frame.width/2-15, height:self.frame.height-20))
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var bigLable: UILabel = {
        let label = UILabel.init(frame: CGRect(x: self.imageView.frame.width+15, y: self.frame.height/4-10, width: self.frame.width/2-10, height: 20 ))
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var smallLabel: UILabel = {
        let label = UILabel.init(frame: CGRect(x:self.imageView.frame.width+15, y: self.frame.height/2, width: self.frame.width/2-10, height: self.frame.height/2-10))
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI(){
        self.addSubview(self.imageView)
        self.addSubview(self.bigLable)
        self.addSubview(self.smallLabel)
    }

    var model: RankingModel? {
        didSet {
            guard let model = model else {
                return
            }
            let url = URL(string:model.cover!)
            self.imageView.kf.setImage(with: url)
            self.bigLable.text = "\(model.title ?? "")榜"
            self.smallLabel.text = model.subTitle
        }
    }
}

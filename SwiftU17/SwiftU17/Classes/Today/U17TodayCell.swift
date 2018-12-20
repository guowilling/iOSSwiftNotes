
import UIKit

class U17TodayCell: UITableViewCell {
    
    lazy var picImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.layer.cornerRadius = 20.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var button: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.backgroundColor = U17ThemeColor
        button.setTitle("阅读漫画", for: UIControl.State.normal)
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupUI(){
        self.addSubview(self.picImageView)
        self.picImageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(15)
            make.right.bottom.equalToSuperview().offset(-15)
        }
        
        self.picImageView.addSubview(self.button)
        self.button.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.right.bottom.equalToSuperview().offset(-25)
            make.height.equalTo(30)
        }
    }
    
    var model: DayItemModel? {
        didSet {
            guard let model = model else {
                return
            }
            self.picImageView.kf.setImage(with: URL(string:model.cover!))
        }
    }
}

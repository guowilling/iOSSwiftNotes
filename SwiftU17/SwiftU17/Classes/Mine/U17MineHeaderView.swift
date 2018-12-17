
import UIKit

class U17MineHeaderView: UITableViewHeaderFooterView {
    
    lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "")
        imageView.backgroundColor = U17ThemeColor
        return imageView
    }()
    
  private lazy var tagView: TagView = {
        let view = TagView()
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    lazy var nickImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    
    lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "点击头像登录"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    lazy var subloginLabel: UILabel = {
        let label = UILabel()
        label.text = "登录后可以使用更多精彩功能呦"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    func setupUI() {
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(205)
        }
        
        self.addSubview(self.tagView)
        self.tagView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalTo(-15)
            make.height.equalTo(120)
        }
        
        self.addSubview(self.nickImageView)
        self.nickImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(70)
            make.left.equalTo(15)
            make.bottom.equalTo(self.tagView.snp.top).offset(-20)
        }

        self.addSubview(self.loginLabel)
        self.loginLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.nickImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-50)
            make.height.equalTo(30)
            make.top.equalTo(self.nickImageView.snp.top).offset(15)
        }

        self.addSubview(self.subloginLabel)
        self.subloginLabel.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(self.loginLabel)
            make.top.equalTo(self.loginLabel.snp.bottom).offset(5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

private class TagView: UIView {
    
    private let titleArray = ["妖气币", "阅读劵", "月票"]
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1)
        return view
    }()
    
    lazy var vipLabel: UILabel = {
        let label = UILabel()
        label.text = "VIP 状态: 未开通"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var signBtn: UIButton = {
       let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setTitle("退出", for: UIControl.State.normal)
        button.backgroundColor = U17ThemeColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(logoutBtnClick(button:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    @objc func logoutBtnClick(button:UIButton) { }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.lineView)
        self.lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.center.equalToSuperview()
        }
        
        self.addSubview(self.vipLabel)
        self.vipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.height.equalTo(30)
            make.top.equalTo(15)
            make.width.equalTo(200)
        }
        
        self.addSubview(self.signBtn)
        self.signBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-40)
            make.height.equalTo(30)
            make.width.equalTo(60)
            make.top.equalTo(15)
        }
        
        createBtn()
    }
    
    func createBtn(){
        let margin:CGFloat = (ScreenWidth - 30) / 3
        
        for index in 0..<titleArray.count {
            let button = UIButton.init(frame: CGRect(x: margin*CGFloat(index), y: 60, width: margin, height: 40))
            button.setTitle("0", for: UIControl.State.normal)
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            button.tag = index
            button.addTarget(self, action: #selector(tagBtnClick(button:)), for: UIControl.Event.touchUpInside)
            self.addSubview(button)
            
            let label = UILabel()
            label.textAlignment = .center
            label.text = titleArray[index]
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = UIColor.gray
            self.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.centerX.equalTo(button)
                make.width.equalTo(margin+20)
                make.top.equalTo(button.snp.bottom)
            })
        }
        
        let lineWidth: CGFloat = (ScreenWidth - 30) / 3
        for index in 0..<titleArray.count - 1 {
            let lineView = UIView.init(frame: CGRect(x: lineWidth+CGFloat(index)*lineWidth, y: 70, width: 0.5, height: 40))
            lineView.backgroundColor = UIColor.init(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1)
            self.addSubview(lineView)
        }
    }
    
    @objc func tagBtnClick(button: UIButton) { }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

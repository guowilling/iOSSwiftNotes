
import Foundation
import SnapKit

let VIEW_AVATAE_TAG       = 1000
let VIEW_SEND_MESSAGE_TAG = 2000
let VIEW_FOCUS_TAG        = 3000
let VIEW_SETTING_TAG      = 5000

protocol UserHomeHeaderDelegate : NSObjectProtocol {
    func userHomeHeader(_ header: UserHomeHeader, onTapItemTag tag: Int)
}

class UserHomeHeader: UICollectionReusableView {
    
    var delegate: UserHomeHeaderDelegate?
    
    var containerView: UIView = UIView.init()
    var constellations = ["射手座", "摩羯座", "双鱼座", "白羊座", "水瓶座", "金牛座", "双子座", "巨蟹座", "狮子座", "处女座", "天秤座", "天蝎座"]
    
    var avatar: UIImageView = UIImageView.init(image: UIImage.init(named: "img_find_default"))
    var avatarBackground: UIImageView = UIImageView.init()
    
    var sendMessage: UILabel = UILabel.init()
    var focusIcon: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_titlebar_addfriend"))
    var settingIcon: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_titlebar_whitemore"))
    
    var nickName: UILabel = UILabel()
    var douyinNum: UILabel = UILabel()
    var brief: UILabel = UILabel()
    var genderIcon: UIImageView = UIImageView.init(image: UIImage.init(named: "iconUserProfileGirl"))
    var constellation: UITextView = UITextView()
    var likeNum: UILabel = UILabel()
    var followNum: UILabel = UILabel()
    var followedNum: UILabel = UILabel()
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            avatar.setImageWithURL(imageURL: URL(string: user.avatar_medium?.url_list.first ?? "")!, completed: { [weak self] (image, error) in
                self?.avatarBackground.image = image
                self?.avatar.image = image?.drawCircleImage()
            })
            nickName.text = user.nickname
            douyinNum.text = "抖音号:" + (user.short_id ?? "")
            if user.signature != "" {
                brief.text = user.signature
            }
            genderIcon.image = UIImage.init(named: user.gender == 0 ? "iconUserProfileBoy" : "iconUserProfileGirl")
            constellation.text = constellations[user.constellation ?? 0]
            likeNum.text = String.init(user.total_favorited ?? 0) + "获赞"
            followNum.text = String.init(user.following_count ?? 0) + "关注"
            followedNum.text = String.init(user.follower_count ?? 0) + "粉丝"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAvatarBackground()
        
        containerView.frame = self.bounds
        self.addSubview(containerView)
        
        setupAvatar()
        setupActions()
        setupInfo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAvatarBackground() {
        avatarBackground.frame = self.bounds
        avatarBackground.clipsToBounds = true
        avatarBackground.image = UIImage.init(named: "img_find_default")
        avatarBackground.backgroundColor = ColorThemeGray
        avatarBackground.contentMode = .scaleAspectFill
        self.addSubview(avatarBackground)
        
        let blurEffect = UIBlurEffect.init(style: UIBlurEffect.Style.dark)
        let visualEffectView = UIVisualEffectView.init(effect: blurEffect)
        visualEffectView.frame = self.bounds
        visualEffectView.alpha = 1
        avatarBackground.addSubview(visualEffectView)
    }
    
    func setupAvatar() {
        let avatarRadius: CGFloat = 45
        avatar.isUserInteractionEnabled = true
        avatar.tag = VIEW_AVATAE_TAG
        avatar.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onTapAction(sender:))))
        containerView.addSubview(avatar)
        
        let paddingLayer = CALayer.init()
        paddingLayer.frame = CGRect.init(x: 0, y: 0, width: avatarRadius * 2, height: avatarRadius * 2)
        paddingLayer.borderColor = ColorWhiteAlpha20.cgColor
        paddingLayer.borderWidth = 2
        paddingLayer.cornerRadius = avatarRadius
        avatar.layer.addSublayer(paddingLayer)
        
        avatar.snp.makeConstraints { make in
            make.top.equalTo(self).offset(25 + 44 + StatusBarHeight)
            make.left.equalTo(self).offset(15)
            make.width.height.equalTo(avatarRadius * 2)
        }
    }
    
    func setupActions() {
        settingIcon.contentMode = .center
        settingIcon.layer.backgroundColor = ColorWhiteAlpha20.cgColor
        settingIcon.layer.cornerRadius = 2
        settingIcon.tag = VIEW_SETTING_TAG
        settingIcon.isUserInteractionEnabled = true
        settingIcon.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onTapAction(sender:))))
        containerView.addSubview(settingIcon)
        settingIcon.snp.makeConstraints { make in
            make.centerY.equalTo(self.avatar)
            make.right.equalTo(self).inset(15)
            make.width.height.equalTo(40)
        }
        
        focusIcon.contentMode = .center
        focusIcon.isUserInteractionEnabled = true
        focusIcon.clipsToBounds = true
        focusIcon.layer.backgroundColor = ColorWhiteAlpha20.cgColor
        focusIcon.layer.cornerRadius = 2
        focusIcon.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onTapAction(sender:))))
        containerView.addSubview(focusIcon)
        focusIcon.snp.makeConstraints { make in
            make.centerY.equalTo(self.settingIcon)
            make.right.equalTo(self.settingIcon.snp.left).inset(-5)
            make.width.height.equalTo(40)
        }
        
        sendMessage.text = "发消息"
        sendMessage.textColor = ColorWhiteAlpha60
        sendMessage.textAlignment = .center
        sendMessage.font = MediumFont
        sendMessage.layer.backgroundColor = ColorWhiteAlpha20.cgColor
        sendMessage.layer.cornerRadius = 2
        sendMessage.tag = VIEW_SEND_MESSAGE_TAG
        sendMessage.isUserInteractionEnabled = true
        sendMessage.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(onTapAction(sender:))))
        containerView.addSubview(sendMessage)
        sendMessage.snp.makeConstraints { make in
            make.centerY.equalTo(self.focusIcon)
            make.right.equalTo(self.focusIcon.snp.left).inset(-5)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
    }
    
    func setupInfo() {
        nickName.text = "name"
        nickName.textColor = ColorWhite
        nickName.font = SuperBigBoldFont
        containerView.addSubview(nickName)
        nickName.snp.makeConstraints { make in
            make.top.equalTo(self.avatar.snp.bottom).offset(20)
            make.left.equalTo(self.avatar)
            make.right.equalTo(self.settingIcon)
        }
        
        douyinNum.text = "抖音号："
        douyinNum.textColor = ColorWhite
        douyinNum.font = SmallFont
        containerView.addSubview(douyinNum)
        douyinNum.snp.makeConstraints { make in
            make.top.equalTo(self.nickName.snp.bottom).offset(3)
            make.left.right.equalTo(self.nickName)
        }
        
        let sepLine = UIView.init()
        sepLine.backgroundColor = ColorWhiteAlpha20
        containerView.addSubview(sepLine)
        sepLine.snp.makeConstraints { make in
            make.top.equalTo(self.douyinNum.snp.bottom).offset(10)
            make.left.right.equalTo(self.nickName)
            make.height.equalTo(0.5)
        }
        
        brief.text = "暂时还没想到个性的签名"
        brief.textColor = ColorWhiteAlpha60
        brief.font = SmallFont
        brief.numberOfLines = 0
        containerView .addSubview(brief)
        brief.snp.makeConstraints { make in
            make.top.equalTo(sepLine.snp.bottom).offset(10)
            make.left.right.equalTo(self.nickName)
        }
        
        genderIcon.layer.backgroundColor = ColorWhiteAlpha20.cgColor
        genderIcon.layer.cornerRadius = 9
        genderIcon.contentMode = .center
        containerView.addSubview(genderIcon)
        genderIcon.snp.makeConstraints { make in
            make.left.equalTo(self.nickName)
            make.top.equalTo(self.brief.snp.bottom).offset(8)
            make.height.equalTo(18)
            make.width.equalTo(22)
        }
        
        constellation.textColor = ColorWhite
        constellation.text = "座"
        constellation.font = SuperSmallFont
        constellation.isScrollEnabled = false
        constellation.isEditable = false
        constellation.textContainerInset = UIEdgeInsets.init(top: 3, left: 6, bottom: 3, right: 6)
        constellation.textContainer.lineFragmentPadding = 0
        constellation.layer.backgroundColor = ColorWhiteAlpha20.cgColor
        constellation.layer.cornerRadius = 9
        constellation.sizeToFit()
        containerView.addSubview(constellation)
        constellation.snp.makeConstraints { make in
            make.left.equalTo(self.genderIcon.snp.right).offset(5)
            make.top.height.equalTo(self.genderIcon)
        }
        
        likeNum.text = "0获赞"
        likeNum.textColor = ColorWhite
        likeNum.font = BigBoldFont
        containerView.addSubview(likeNum)
        likeNum.snp.makeConstraints { make in
            make.top.equalTo(self.genderIcon.snp.bottom).offset(15)
            make.left.equalTo(self.avatar)
        }
        
        followNum.text = "0关注"
        followNum.textColor = ColorWhite
        followNum.font = BigBoldFont
        containerView.addSubview(followNum)
        followNum.snp.makeConstraints { make in
            make.top.equalTo(self.likeNum)
            make.left.equalTo(self.likeNum.snp.right).offset(30)
        }
        
        followedNum.text = "0粉丝"
        followedNum.textColor = ColorWhite
        followedNum.font = BigBoldFont
        containerView.addSubview(followedNum)
        followedNum.snp.makeConstraints { make in
            make.top.equalTo(self.likeNum)
            make.left.equalTo(self.followNum.snp.right).offset(30)
        }
    }
    
    @objc func onTapAction(sender: UITapGestureRecognizer) {
        self.delegate?.userHomeHeader(self, onTapItemTag: sender.view!.tag)
    }
}

extension UserHomeHeader {
    func overScrollAction(offsetY: CGFloat)  {
        let scaleRatio: CGFloat = abs(offsetY) / 370.0
        let overScaleHeight: CGFloat = (370.0 * scaleRatio) / 2.0
        avatarBackground.transform = CGAffineTransform.init(scaleX: scaleRatio + 1.0, y: scaleRatio + 1.0).concatenating(CGAffineTransform.init(translationX: 0, y: -overScaleHeight))
    }
    
    func scrollToTopAction(offsetY: CGFloat) {
        let alphaRatio = offsetY / (370.0 - 44.0 - StatusBarHeight)
        containerView.alpha = 1.0 - alphaRatio
    }
}

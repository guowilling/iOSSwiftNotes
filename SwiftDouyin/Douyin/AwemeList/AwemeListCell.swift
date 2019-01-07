
import Foundation
import AVFoundation

class AwemeListCell: UITableViewCell {
    
    let COMMENT_TAP_ACTION: Int = 1000
    let SHARE_TAP_ACTION: Int = 2000
    
    var container: UIView = UIView.init()
    var gradientLayer: CAGradientLayer = CAGradientLayer.init()
    var pauseIcon: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_play_pause"))
    var musicIcon: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_home_musicnote3"))
    var playerStatusBar: UIView = UIView.init()
    
    var singleTapGesture: UITapGestureRecognizer?
    
    var lastTapTime: TimeInterval = 0
    var lastTapPoint: CGPoint = .zero
    
    var playerView: AVPlayerView = AVPlayerView.init()
    var hoverTextView: HoverTextView = HoverTextView.init()
    
    var nicknameLabel: UILabel = UILabel.init()
    var descLabel: UILabel = UILabel.init()
    var circleTextView = CircleTextView.init()
    
    var avatarIcon: UIImageView = UIImageView.init(image: UIImage.init(named: "img_find_default"))
    var focusView = FocusIcon.init()
    var musicAlbumView = MusicAlbumView.init()
    var commentIcon: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_home_comment"))
    var shareIcon: UIImageView = UIImageView.init(image: UIImage.init(named: "icon_home_share"))
    var favoriteNumLabel: UILabel = UILabel.init()
    var commentNumLabel: UILabel = UILabel.init()
    var shareNumLabel: UILabel = UILabel.init()
    
    var favoriteView = FavoriteView.init()

    var readyToPlayClosure: (() -> Void)?
    
    var isPlayerReady: Bool = false
    
    var aweme: Aweme? {
        didSet {
            guard let aweme = aweme else { return }
            playerView.setPlayerSource(urlString: aweme.video?.play_addr?.url_list.first ?? "")
            
            nicknameLabel.text = aweme.author?.nickname
            descLabel.text = aweme.desc
            circleTextView.text = (aweme.music?.title ?? "") + "-" + (aweme.music?.author ?? "")
            favoriteNumLabel.text = String.formatCount(count: aweme.statistics?.digg_count ?? 0)
            commentNumLabel.text = String.formatCount(count: aweme.statistics?.comment_count ?? 0)
            shareNumLabel.text = String.formatCount(count: aweme.statistics?.share_count ?? 0)
            
            musicAlbumView.album.setImageWithURL(imageURL: URL(string: aweme.music?.cover_thumb?.url_list.first ?? "")!) { (image, error) in
                if let image = image {
                    self.musicAlbumView.album.image = image.drawCircleImage()
                }
            }
            avatarIcon.setImageWithURL(imageURL: URL(string: aweme.author?.avatar_thumb?.url_list.first ?? "")!) { (image, error) in
                if let image = image {
                    self.avatarIcon.image = image.drawCircleImage()
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = ColorClear
        self.selectionStyle = .none
        
        lastTapTime = 0
        lastTapPoint = .zero
        
        setupSubView()
    }
    
    func setupSubView() {
        playerView.delegate = self
        self.contentView.addSubview(playerView)

        singleTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(handleGesture(sender:)))
        container.addGestureRecognizer(singleTapGesture!)
        self.contentView.addSubview(container)

        gradientLayer.colors = [ColorClear.cgColor, ColorBlackAlpha20.cgColor, ColorBlackAlpha40.cgColor]
        gradientLayer.locations = [0.3, 0.6, 1.0]
        gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint.init(x: 0.0, y: 1.0)
        container.layer.addSublayer(gradientLayer)

        pauseIcon.contentMode = .center
        pauseIcon.layer.zPosition = 3
        pauseIcon.isHidden = true
        container.addSubview(pauseIcon)
        
        hoverTextView.delegate = self
        self.contentView.addSubview(hoverTextView)
        
        playerStatusBar.backgroundColor = ColorWhite
        playerStatusBar.isHidden = true
        container.addSubview(playerStatusBar)
        
        musicIcon.contentMode = .center
        container.addSubview(musicIcon)
        
        circleTextView.textColor = ColorWhite
        circleTextView.font = MediumFont
        container.addSubview(circleTextView)
        
        descLabel.numberOfLines = 0
        descLabel.textColor = ColorWhiteAlpha80
        descLabel.font = MediumFont
        container.addSubview(descLabel)
        
        nicknameLabel.textColor = ColorWhite
        nicknameLabel.font = BigBoldFont
        container.addSubview(nicknameLabel)
        
        container.addSubview(musicAlbumView)
        
        shareIcon.contentMode = .center
        shareIcon.isUserInteractionEnabled = true
        shareIcon.tag = SHARE_TAP_ACTION
        shareIcon.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGesture(sender:))))
        container.addSubview(shareIcon)
        
        shareNumLabel.text = "0"
        shareNumLabel.textColor = ColorWhite
        shareNumLabel.font = SmallFont
        container.addSubview(shareNumLabel)
        
        commentIcon.contentMode = .center
        commentIcon.isUserInteractionEnabled = true
        commentIcon.tag = COMMENT_TAP_ACTION
        commentIcon.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGesture(sender:))))
        container.addSubview(commentIcon)
        
        commentNumLabel.text = "0"
        commentNumLabel.textColor = ColorWhite
        commentNumLabel.font = SmallFont
        container.addSubview(commentNumLabel)
        
        container.addSubview(favoriteView)
        
        favoriteNumLabel.text = "0"
        favoriteNumLabel.textColor = ColorWhite
        favoriteNumLabel.font = SmallFont
        container.addSubview(favoriteNumLabel)
        
        avatarIcon.layer.cornerRadius = 25
        avatarIcon.layer.borderColor = ColorWhiteAlpha80.cgColor
        avatarIcon.layer.borderWidth = 1
        container.addSubview(avatarIcon)
        
        container.addSubview(focusView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isPlayerReady = false
        
        playerView.cancelLoading()
        
        pauseIcon.isHidden = true
        
        avatarIcon.image = UIImage.init(named: "img_find_default")
        
        hoverTextView.textView.text = ""
        
        musicAlbumView.reset()
        favoriteView.reset()
        focusView.reset()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        container.frame = self.bounds
        
        pauseIcon.frame = CGRect(x: self.bounds.midX - 50, y: self.bounds.midY - 50, width: 100, height: 100)

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = CGRect(x: 0, y: self.bounds.height - 500, width: self.bounds.width, height: 500)
        CATransaction.commit()

        playerStatusBar.frame = CGRect(x: self.bounds.midX - 0.5, y: self.bounds.maxY - 49.5 - SafeAreaBottomHeight, width: 1.0, height: 1.0)
        
        musicIcon.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.bottom.equalTo(self).inset(60 + SafeAreaBottomHeight)
            make.width.equalTo(30)
            make.height.equalTo(25)
        }
        circleTextView.snp.makeConstraints { make in
            make.left.equalTo(self.musicIcon.snp.right)
            make.centerY.equalTo(self.musicIcon)
            make.width.equalTo(ScreenWidth/2)
            make.height.equalTo(20)
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(10)
            make.bottom.equalTo(self.musicIcon.snp.top).inset(-5)
            make.width.lessThanOrEqualTo(ScreenWidth / 5 * 3)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(10)
            make.bottom.equalTo(self.descLabel.snp.top).inset(-5)
            make.width.lessThanOrEqualTo(ScreenWidth / 4 * 3 + 30)
        }
        
        musicAlbumView.snp.makeConstraints { make in
            make.bottom.equalTo(self.circleTextView)
            make.right.equalTo(self).inset(10)
            make.width.height.equalTo(50)
        }
        
        shareIcon.snp.makeConstraints { make in
            make.bottom.equalTo(self.musicAlbumView.snp.top).inset(-50)
            make.right.equalTo(self).inset(10)
            make.width.equalTo(50)
            make.height.equalTo(45)
        }
        shareNumLabel.snp.makeConstraints { make in
            make.top.equalTo(self.shareIcon.snp.bottom);
            make.centerX.equalTo(self.shareIcon);
        }
        commentIcon.snp.makeConstraints { make in
            make.bottom.equalTo(self.shareIcon.snp.top).inset(-25);
            make.right.equalTo(self).inset(10);
            make.width.equalTo(50);
            make.height.equalTo(45);
        }
        commentNumLabel.snp.makeConstraints { make in
            make.top.equalTo(self.commentIcon.snp.bottom);
            make.centerX.equalTo(self.commentIcon);
        }
        favoriteView.snp.makeConstraints { make in
            make.bottom.equalTo(self.commentIcon.snp.top).inset(-25);
            make.right.equalTo(self).inset(10);
            make.width.equalTo(50);
            make.height.equalTo(45);
        }
        favoriteNumLabel.snp.makeConstraints { make in
            make.top.equalTo(self.favoriteView.snp.bottom);
            make.centerX.equalTo(self.favoriteView);
        }
        
        avatarIcon.snp.makeConstraints { make in
            make.bottom.equalTo(self.favoriteView.snp.top).inset(-35);
            make.right.equalTo(self).inset(10);
            make.width.height.equalTo(25 * 2);
        }
        focusView.snp.makeConstraints { make in
            make.centerX.equalTo(self.avatarIcon);
            make.centerY.equalTo(self.avatarIcon.snp.bottom);
            make.width.height.equalTo(24);
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Play Action
extension AwemeListCell {
    
    func play() {
        playerView.play()
    }
    
    func pause() {
        playerView.pause()
    }
    
    func replay() {
        playerView.replay()
    }
}

// MARK: - Gesture
extension AwemeListCell {
    
    @objc func handleGesture(sender: UITapGestureRecognizer) {
        switch sender.view?.tag {
        case COMMENT_TAP_ACTION:
            CommentsPopView.init(awemeId: aweme?.aweme_id ?? "").show()
        case SHARE_TAP_ACTION:
            SharePopView.init().show()
        default:
            let tapPoint = sender.location(in: container)
            let time = CACurrentMediaTime()
            if (time - lastTapTime) > 0.25 {
                self.perform(#selector(singleTapAction), with: nil, afterDelay: 0.25)
            } else {
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(singleTapAction), object: nil)
                showLikeAnimation(newPoint: tapPoint, oldPoint: lastTapPoint)
            }
            lastTapPoint = tapPoint
            lastTapTime = time
        }
    }
    
    @objc func singleTapAction() {
        if hoverTextView.isFirstResponder {
            hoverTextView.resignFirstResponder()
        } else {
            pauseIconAnimation(rate: playerView.rate())
            if playerView.rate() == 0 {
                play()
            } else {
                pause()
            }
        }
    }
}

// MARK: - Animation
extension AwemeListCell {
    
    func pauseIconAnimation(rate: CGFloat) {
        if rate == 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.pauseIcon.alpha = 0.0
            }) { finished in
                self.pauseIcon.isHidden = true
            }
        } else {
            pauseIcon.isHidden = false
            pauseIcon.transform = CGAffineTransform(scaleX: 1.75, y: 1.75)
            pauseIcon.alpha = 1.0
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
                self.pauseIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }
    }
    
    func showLikeAnimation(newPoint: CGPoint, oldPoint: CGPoint) {
        let likeIcon = UIImageView.init(image: UIImage(named: "icon_home_like_after"))
        var k = (oldPoint.y - newPoint.y) / (oldPoint.x - newPoint.x)
        k = abs(k) < 0.5 ? k : (k > 0 ? 0.5 : -0.5)
        let angle = .pi / 4 * -k
        likeIcon.frame = CGRect(origin: newPoint, size: CGSize(width: 80, height: 80))
        likeIcon.transform = CGAffineTransform(scaleX: 0.8, y: 1.8).concatenating(CGAffineTransform(rotationAngle: angle))
        self.container.addSubview(likeIcon)
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            likeIcon.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(rotationAngle: angle))
        }) { finished in
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                likeIcon.transform = CGAffineTransform(scaleX: 3.0, y: 3.0).concatenating(CGAffineTransform(rotationAngle: angle))
                likeIcon.alpha = 0.0
            }, completion: { finished in
                likeIcon.removeFromSuperview()
            })
        }
    }
    
    func loadingPlayerAnimation(_ isStart: Bool = true) {
        if isStart {
            playerStatusBar.backgroundColor = ColorWhite
            playerStatusBar.isHidden = false
            playerStatusBar.layer.removeAllAnimations()
            
            let animationGroup = CAAnimationGroup.init()
            animationGroup.duration = 0.5
            animationGroup.beginTime = CACurrentMediaTime()
            animationGroup.repeatCount = .infinity
            animationGroup.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
            
            let scaleAnim = CABasicAnimation.init()
            scaleAnim.keyPath = "transform.scale.x"
            scaleAnim.fromValue = 1.0
            scaleAnim.toValue = 1.0 * ScreenWidth
            
            let alphaAnim = CABasicAnimation.init()
            alphaAnim.keyPath = "opacity"
            alphaAnim.fromValue = 1.0
            alphaAnim.toValue = 0.2
            
            animationGroup.animations = [scaleAnim, alphaAnim]
            playerStatusBar.layer.add(animationGroup, forKey: nil)
        } else {
            playerStatusBar.layer.removeAllAnimations()
            playerStatusBar.isHidden = true
        }
    }
}

extension AwemeListCell: HoverTextViewDelegate {
    
    func hoverTextView(_ textView: HoverTextView, stateDidChange isHover: Bool) {
        container.alpha = isHover ? 0.0 : 1.0
    }
    
    func hoverTextView(_ textView: HoverTextView, sendText text: String) {
        if let aweme_id = aweme?.aweme_id {
            PostCommentRequest.postCommentText(aweme_id: aweme_id, text: text, success: { data in
                UIWindow.showTips(text: "评论成功")
            }, failure: { error in
                UIWindow.showTips(text: "评论失败")
            })
        }
    }
}

extension AwemeListCell: AVPlayerViewDelegate {
    
    func playerView(_ playerView: AVPlayerView, playerItemStatusChanged status: AVPlayerItem.Status) {
        switch status {
        case .unknown:
            loadingPlayerAnimation()
        case .readyToPlay:
            loadingPlayerAnimation(false)
            
            isPlayerReady = true
            musicAlbumView.startAnimation(rate: CGFloat(aweme?.rate ?? 0))
            readyToPlayClosure?()
        case .failed:
            loadingPlayerAnimation(false)
        }
    }
    
    func playerView(_ playerView: AVPlayerView, playProgressUpdateCurrent current: CGFloat, duration: CGFloat) {
        
    }
}

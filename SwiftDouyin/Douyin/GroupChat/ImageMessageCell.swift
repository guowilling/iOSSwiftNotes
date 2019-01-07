
import Foundation

let IMAGE_MESSAGE_CELL_ID: String = "IMAGE_MESSAGE_CELL_ID"

let IMAGE_MSG_CORNOR_RADIUS: CGFloat = 10
let IMAGE_MSG_MAX_WIDTH: CGFloat = 200
let IMAGE_MSG_MAX_HEIGHT: CGFloat = 200

class ImageMessageCell: UITableViewCell {
    
    var avatar = UIImageView(image: UIImage(named: "img_find_default"))
    
    var imageMsg: UIImageView = UIImageView()
    var imageMsgWidth: CGFloat = 0
    var imageMsgHeight: CGFloat = 0
    
    var circleProgress = CircleProgress.init()
    
    var onMenuAction: OnChatCellMenuAction?
    
    var rectImage: UIImage?
    
    var chat: GroupChat? {
        didSet {
            guard let chat = chat else { return }
            imageMsgWidth = ImageMessageCell.imageMsgWidth(chat: chat)
            imageMsgHeight = ImageMessageCell.imageMsgHeight(chat: chat)
            
            rectImage = nil
            circleProgress.isTipHidden = true
            if chat.picImage != nil {
                circleProgress.isHidden = true
                rectImage = chat.picImage
                if let image = chat.picImage?.drawRoundedImage(cornerRadius: IMAGE_MSG_CORNOR_RADIUS, width: imageMsgWidth, height: imageMsgHeight) {
                    imageMsg.image = image
                    updateImageFrame()
                }
            } else {
                circleProgress.isHidden = false
                imageMsg.setImageWithURL(imageURL: URL(string: chat.pic_medium?.url ?? "")!, progress: { [weak self] percent in
                    self?.circleProgress.progress = percent
                    }, completed: { [weak self] (image, error) in
                        if image != nil {
                            self?.chat?.picImage = image
                            self?.rectImage = image
                            self?.imageMsg.image = image?.drawRoundedImage(cornerRadius: IMAGE_MSG_CORNOR_RADIUS, width: self?.imageMsgWidth ?? 0, height: self?.imageMsgHeight ?? 0)
                            self?.updateImageFrame()
                            self?.circleProgress.isHidden = true
                        } else {
                            self?.circleProgress.isTipHidden = false
                        }
                })
            }
            
            avatar.setImageWithURL(imageURL: URL.init(string: chat.visitor?.avatar_thumbnail?.url ?? "")!) { [weak self] (image, error) in
                if let image = image {
                    self?.avatar.image = image.drawCircleImage()
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = ColorClear
        
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews() {
        avatar.contentMode = .scaleAspectFill
        self.addSubview(avatar)
        
        imageMsg.backgroundColor = ColorGray;
        imageMsg.contentMode = .scaleAspectFit;
        imageMsg.layer.cornerRadius = IMAGE_MSG_CORNOR_RADIUS;
        imageMsg.isUserInteractionEnabled = true;
        imageMsg.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showMenu)))
        imageMsg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPhotoBroswer)))
        self.addSubview(imageMsg)
        
        self.addSubview(circleProgress)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageMsg.image = nil
        circleProgress.progress = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if UDID_MD5 == chat?.visitor?.udid {
            avatar.frame = CGRect(x: ScreenWidth - COMMON_MSG_PADDING - 30, y: COMMON_MSG_PADDING, width: 30, height: 30)
        } else {
            avatar.frame = CGRect(x: COMMON_MSG_PADDING, y: COMMON_MSG_PADDING, width: 30, height: 30)
        }
        updateImageFrame()
        circleProgress.snp.makeConstraints { make in
            make.center.equalTo(self.imageMsg)
            make.width.height.equalTo(50)
        }
    }
    
    func updateImageFrame() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if UDID_MD5 == chat?.visitor?.udid {
            imageMsg.frame = CGRect(x: self.avatar.frame.minX - COMMON_MSG_PADDING - imageMsgWidth, y: COMMON_MSG_PADDING, width: imageMsgWidth, height: imageMsgHeight)
        } else {
            imageMsg.frame = CGRect(x: self.avatar.frame.maxX + COMMON_MSG_PADDING, y: COMMON_MSG_PADDING, width: imageMsgWidth, height: imageMsgHeight)
        }
        CATransaction.commit()
    }
    
    func updateUploadStatus(chat: GroupChat) {
        circleProgress.isHidden = false
        circleProgress.isTipHidden = true
        if chat.isTemp {
            circleProgress.progress = chat.percent ?? 0
            if chat.isFailed {
                circleProgress.isTipHidden = false
                return
            }
            if chat.isCompleted {
                circleProgress.isHidden = true
                return
            }
        }
    }
}

extension ImageMessageCell {
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(onMenuDelete) {
            return true
        } else {
            return false
        }
    }
    
    @objc func showMenu() {
        self.becomeFirstResponder()
        if UDID_MD5 == chat?.visitor?.udid {
            if !UIMenuController.shared.isMenuVisible {
                UIMenuController.shared.setTargetRect(CGRect(x: self.imageMsgWidth/2 - 60, y: 10, width: 120, height: 50), in: imageMsg)
                let deleteItem = UIMenuItem(title: "删除", action: #selector(onMenuDelete))
                UIMenuController.shared.menuItems = [deleteItem]
                UIMenuController.shared.setMenuVisible(true, animated: true)
            }
        }
    }
    
    @objc func onMenuDelete() {
        onMenuAction?(.Delete)
    }
    
    @objc func showPhotoBroswer() {
        PhotoBroswer(chat?.pic_original?.url, rectImage).show()
    }
}

extension ImageMessageCell {
    
    static func cellHeight(chat: GroupChat) -> CGFloat {
        return self.imageMsgHeight(chat: chat) + COMMON_MSG_PADDING * 2
    }
    
    static func imageMsgWidth(chat:GroupChat) -> CGFloat {
        var width: CGFloat = CGFloat(chat.pic_large?.width ?? 0)
        let height: CGFloat = CGFloat(chat.pic_large?.height ?? 0)
        let ratio: CGFloat = width/height
        if width > height {
            if width > IMAGE_MSG_MAX_WIDTH {
                width = IMAGE_MSG_MAX_WIDTH
            }
        } else {
            if height > IMAGE_MSG_MAX_HEIGHT {
                width = IMAGE_MSG_MAX_WIDTH*ratio
            }
        }
        return width
    }
    
    static func imageMsgHeight(chat: GroupChat) -> CGFloat {
        let width: CGFloat = CGFloat(chat.pic_large?.width ?? 0)
        var height: CGFloat = CGFloat(chat.pic_large?.height ?? 0)
        let ratio: CGFloat = width/height
        if width > height {
            if width > IMAGE_MSG_MAX_WIDTH {
                height = IMAGE_MSG_MAX_WIDTH / ratio
            }
        } else {
            if height > IMAGE_MSG_MAX_HEIGHT {
                height = IMAGE_MSG_MAX_HEIGHT
            }
        }
        return height
    }
}

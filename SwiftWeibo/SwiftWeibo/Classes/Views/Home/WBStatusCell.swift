
import UIKit

/// 设置可选协议方法需要:
/// 1. 遵守 NSObjectProtocol 协议
/// 2. 协议需要 @objc 修饰
/// 3. 方法需要 @objc optional 修饰
@objc protocol WBStatusCellDelegate: NSObjectProtocol {
    
    @objc optional func statusCellDidSelectedURLString(cell: WBStatusCell, urlString: String)
}

class WBStatusCell: UITableViewCell {

    weak var delegate: WBStatusCellDelegate?
    
    /// 微博视图模型
    var viewModel: WBStatusViewModel? {
        didSet {
            iconView.wb_setImage(urlString: viewModel?.status.user?.profile_image_url,
                                 placeholderImage: UIImage(named: "avatar_default_big"),
                                 isAvatar: true)
            
            vipIconView.image = viewModel?.vipIcon
            
            nameLabel.text = viewModel?.status.user?.screen_name
            
            sourceLabel.text = viewModel?.status.source
            
            timeLabel.text = viewModel?.status.createdDate?.cz_dateDescription
            
            memberIconView.image = viewModel?.memberIcon
            
            statusLabel.attributedText = viewModel?.statusAttrText
            
            retweetedLabel?.attributedText = viewModel?.retweetedAttrText
            
            pictureView.viewModel = viewModel
            
            toolBar.viewModel = viewModel
        }
    }
    
    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    
    /// 姓名
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 会员图标
    @IBOutlet weak var memberIconView: UIImageView!
    
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    
    /// 认证图标
    @IBOutlet weak var vipIconView: UIImageView!
    
    /// 微博正文
    @IBOutlet weak var statusLabel: FFLabel!
    
    /// 底部工具栏
    @IBOutlet weak var toolBar: WBStatusToolBar!
    
    /// 配图视图
    @IBOutlet weak var pictureView: WBStatusPictureView!
    
    /// 转发微博正文, 原创微博没有此控件, 一定要用 '?'
    @IBOutlet weak var retweetedLabel: FFLabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        // 异步绘制
        self.layer.drawsAsynchronously = true
        
        // 栅格化, 异步绘制会生成一张图片, cell在屏幕上滚动的时候本质上滚动的是这张图片.
        self.layer.shouldRasterize = true
        
        // 使用栅格化注设置分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
        
        statusLabel.delegate = self
        retweetedLabel?.delegate = self
    }
}

extension WBStatusCell: FFLabelDelegate {
    
    func labelDidSelectedLinkText(label: FFLabel, text: String) {
        if !text.hasPrefix("http://") {
            return
        }
        // ? 代理没有实现协议方法, 就什么都不做.
        // ! 代理没有实现协议方法, 仍然强行执行会导致崩溃.
        delegate?.statusCellDidSelectedURLString?(cell: self, urlString: text)
    }
}

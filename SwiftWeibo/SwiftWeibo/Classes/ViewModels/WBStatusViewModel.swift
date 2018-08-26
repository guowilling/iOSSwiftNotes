
import Foundation

// 如果没有任何父类, 希望在开发时调试输出信息需要:
// 1. 遵守 CustomStringConvertible
// 2. 实现 description 计算型属性

/// 微博视图模型
class WBStatusViewModel: CustomStringConvertible {
    /// 微博模型
    var status: WBStatus
    
    /// 会员等级图标
    var memberIcon: UIImage?
    
    /// 认证类型图标
    var vipIcon: UIImage?
    
    /// 转发文字
    var retweetedStr: String?
    
    /// 评论文字
    var commentStr: String?
    
    /// 点赞文字
    var likeStr: String?
    
    /// 配图视图 Size
    var pictureViewSize = CGSize()
    
    /// 如果是转发的微博, 原创微博一定没有配图
    var picURLs: [WBStatusPicture]? {
        // 1. 如果有被转发的微博, 返回被转发微博的配图
        // 2. 如果没有被转发的微博, 返回原创微博的配图
        // 3. 如果都没有返回 nil
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    /// 微博正文属性文本
    var statusAttrText: NSAttributedString?
    
    /// 转发微博的正文属性文本
    var retweetedAttrText: NSAttributedString?
    
    /// 行高
    var rowHeight: CGFloat = 0
    
    init(model: WBStatus) {
        self.status = model
        
        if (model.user?.mbrank)! > 0 && (model.user?.mbrank)! < 7 {
            let imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            memberIcon = UIImage(named: imageName)
        }
        
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage(named: "avatar_grassroot")
        default:
            break
        }
        
        //model.reposts_count = Int(arc4random_uniform(100000))
        retweetedStr = countString(count: model.reposts_count, defaultString: "转发")
        commentStr = countString(count: model.comments_count, defaultString: "评论")
        likeStr = countString(count: model.attitudes_count, defaultString: "赞")
        
        pictureViewSize = calcPictureViewSize(count: picURLs?.count)
        
        statusAttrText = EmoticonManager.shared.emoticonString(string: model.text ?? "", font: UIFont.systemFont(ofSize: 15))
        
        var rText = "@" + (status.retweeted_status?.user?.screen_name ?? "") + ":"
        rText = rText + (status.retweeted_status?.text ?? "")
        retweetedAttrText = EmoticonManager.shared.emoticonString(string: rText, font: UIFont.systemFont(ofSize: 14))
        
        calculateRowHeight()
    }
    
    var description: String {
        return status.description
    }
    
    func calculateRowHeight() {
        // 原创微博：顶部分隔视图(12) + 间距(12) + 图像的高度(34) + 间距(12) + 正文高度(需要计算) + 配图视图高度(计算) + 间距(12) ＋ 底部视图高度(35)
        // 转发微博：顶部分隔视图(12) + 间距(12) + 图像的高度(34) + 间距(12) + 正文高度(需要计算) + 间距(12)+间距(12)+转发文本高度(需要计算) + 配图视图高度(计算) + 间距(12) ＋ 底部视图高度(35)
        var height: CGFloat = 0
        let margin: CGFloat = 12
        let iconHeight: CGFloat = 34
        let toolbarHeight: CGFloat = 35
        let viewSize = CGSize(width: UIScreen.sr_screenWidth() - 2 * margin, height: CGFloat(MAXFLOAT))
        // 1. 顶部内容
        height = 2 * margin + iconHeight + margin
        // 2. 微博正文
        if let text = statusAttrText {
            height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
        }
        // 3. 转发微博
        if status.retweeted_status != nil {
            height += 2 * margin
            if let text = retweetedAttrText {
                height += text.boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], context: nil).height
            }
        }
        // 4. 配图视图
        height += pictureViewSize.height
        height += margin
        // 5. 底部工具栏
        height += toolbarHeight
        // 保存高度
        rowHeight = height
    }
    
    /// 新浪微博针对单张图片都是缩略图, 但是偶尔会有一张特别大的图比如 7000 * 9000
    /// 新浪微博为了鼓励原创, 支持`长微博`, 但是有的时候有特别长的微博.
    func updateSingleImageSize(image: UIImage) {
        var size = image.size
        let maxWidth: CGFloat = 200
        let minWidth: CGFloat = 40
        // 过宽处理
        if size.width > maxWidth {
            size.width = 200
            size.height = size.width * image.size.height / image.size.width
        }
        // 过窄处理
        if size.width < minWidth {
            size.width = minWidth
            size.height = size.width * image.size.height / image.size.width / 4
        }
        // 过高处理
        if size.height > 200 {
            size.height = 200 // 图片填充模式是 scaleToFill, 减小高度会自动调整
        }
        // 过矮处理
        if size.height < 20 {
            size.height = 50
        }
        size.height += WBStatusPictureViewOutterMargin // 增加顶部的 12 个点以便于布局
        // 重新设置配图视图 Size
        pictureViewSize = size
        // 重新计算行高
        calculateRowHeight()
    }
    
    private func calcPictureViewSize(count: Int?) -> CGSize {
        if count == 0 || count == nil {
            return CGSize()
        }
        // 1 2 3 = 0 1 2 / 3 = 0 + 1 = 1
        // 4 5 6 = 3 4 5 / 3 = 1 + 1 = 2
        // 7 8 9 = 6 7 8 / 3 = 2 + 1 = 3
        let row = (count! - 1) / 3 + 1
        var height = WBStatusPictureViewOutterMargin
        height += CGFloat(row) * WBStatusPictureItemWidth
        height += CGFloat(row - 1) * WBStatusPictureViewInnerMargin
        return CGSize(width: WBStatusPictureViewWidth, height: height)
    }
    
    private func countString(count: Int, defaultString: String) -> String {
        if count == 0 {
            return defaultString
        }
        if count < 10000 {
            return count.description
        }
        return String(format: "%.02f 万", Double(count) / 10000)
    }
}

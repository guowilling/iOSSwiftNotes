
import SDWebImage

extension UIImageView {
    /// 解耦 SDWebImage
    ///
    /// - parameter urlString:        urlString
    /// - parameter placeholderImage: 占位图像
    /// - parameter isAvatar:         是否是头像
    func wb_setImage(urlString: String?, placeholderImage: UIImage?, isAvatar: Bool = false) {
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
            image = placeholderImage
            return
        }
        // Swift 使用 '_', OC 有时用 '!', 也可以传入 nil.
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) { [weak self] (image, _, _, _) in
            if isAvatar {
                self?.image = image?.wb_avatarImage(size: self?.bounds.size)
            }
        }
    }
}

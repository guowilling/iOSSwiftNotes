
import UIKit

/// 微博配图模型
class WBStatusPicture: NSObject {
    
    var largePic: String?
    
    var thumbnail_pic: String? {
        didSet {
            largePic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/large/")
            thumbnail_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/")
        }
    }
    
    override var description: String {
        return yy_modelDescription()
    }
}

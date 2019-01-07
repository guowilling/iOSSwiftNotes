
import Foundation

extension NSTextAttachment {
    
    static var _emotionKey = "emotionKey"
    var emotionKey: String? {
        get {
            return objc_getAssociatedObject(self, &NSTextAttachment._emotionKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &NSTextAttachment._emotionKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}


import Foundation

typealias WebImageProgressClosure = (_ percent: Float) -> Void
typealias WebImageCompletedClosure = (_ image: UIImage?, _ error: Error?) -> Void
typealias WebImageCanceledClosure = () -> Void

extension UIImageView {
    
    static var WebCombineOperationKey = "WebCombineOperationKey"
    
    var combineOperation: WebCombineOperation? {
        get {
            return objc_getAssociatedObject(self, &UIImageView.WebCombineOperationKey) as? WebCombineOperation
        }
        set {
            objc_setAssociatedObject(self, &UIImageView.WebCombineOperationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func setImageWithURL(imageURL: URL, completed: WebImageCompletedClosure?) {
        self.setImageWithURL(imageURL: imageURL, progress: nil, completed: completed, cancel: nil)
    }
    
    func setImageWithURL(imageURL: URL, progress: WebImageProgressClosure?, completed: WebImageCompletedClosure?) {
        self.setImageWithURL(imageURL: imageURL, progress: progress, completed: completed, cancel: nil)
    }
    
    func setImageWithURL(imageURL: URL, progress: WebImageProgressClosure?, completed: WebImageCompletedClosure?, cancel: WebImageCanceledClosure?) {
        combineOperation?.cancel()
        combineOperation = WebDownloader.shared().dowload(url: imageURL, progress: { (receivedSize, expectedSize) in
            DispatchQueue.main.async {
                progress?(Float(receivedSize)/Float(expectedSize))
            }
        }, completed: { (data, error, finished) in
            var image:UIImage?
            if finished && data != nil {
                image = UIImage.init(data: data!)
            }
            DispatchQueue.main.async {
                completed?(image, error)
            }
        }) {
            cancel?()
        }
    }
    
    func setWebPImageWithURL(imageURL: URL, completed: WebImageCompletedClosure?) {
        self.setWebPImageWithURL(imageURL: imageURL, progress: nil, completed: completed, cancel: nil)
    }
    
    func setWebPImageWithURL(imageURL: URL, progress: WebImageProgressClosure?, completed: WebImageCompletedClosure?) {
        self.setWebPImageWithURL(imageURL: imageURL, progress: progress, completed: completed, cancel: nil)
    }
    
    func setWebPImageWithURL(imageURL: URL, progress: WebImageProgressClosure?, completed: WebImageCompletedClosure?, cancel: WebImageCanceledClosure?) {
//        combineOperation?.cancel()
//        combineOperation = WebDownloader.shared().dowload(url: imageURL, progress: { (receivedSize, expectedSize) in
//            DispatchQueue.main.async {
//                progress?(Float(receivedSize/expectedSize))
//            }
//        }, completed: { (data, error, finished) in
//            var image:WebPImage?
//            if finished && data != nil {
//                image = WebPImage.init(data: data!)
//            }
//            DispatchQueue.main.async {
//                completed?(image, error)
//            }
//        }) {
//            cancel?()
//        }
    }
}

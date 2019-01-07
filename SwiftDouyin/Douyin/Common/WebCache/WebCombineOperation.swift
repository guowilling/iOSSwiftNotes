
import Foundation

class WebCombineOperation:NSObject {
    
    /// 查询缓存的操作
    var cacheOperation: Operation?
    
    // 下载网络资源操作
    var downloadOperation: WebDownloadOperation?
    
    // 下载网络资源操作取消回调
    var downloadCancelBlock: WebDownloaderCancelClosure?
    
    func cancel() {
        cacheOperation?.cancel()
        cacheOperation = nil
        
        downloadOperation?.cancel()
        downloadOperation = nil
        
        downloadCancelBlock?()
        downloadCancelBlock = nil
    }
}

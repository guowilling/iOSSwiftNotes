
import Foundation

/// 网络资源下载进度的回调闭包
typealias WebDownloaderProgressClosure = (_ receivedSize: Int64, _ expectedSize: Int64) -> Void

/// 网络资源下载完成后的回调闭包
typealias WebDownloaderCompletedClosure = (_ data: Data?, _ error: Error?, _ finished: Bool) -> Void

/// 网络资源下载取消后的回调闭包
typealias WebDownloaderCancelClosure = () -> Void

class WebDownloader:NSObject {
    
    var downloadQueue: OperationQueue?
    
    private static let instance = { () -> WebDownloader in
        return WebDownloader.init()
    }()
    
    private override init() {
        super.init()
        
        downloadQueue = OperationQueue()
        downloadQueue?.name = "com.downloader.queue"
        downloadQueue?.maxConcurrentOperationCount = 5
    }
    
    class func shared() -> WebDownloader {
        return instance
    }
    
    func dowload(url: URL, progress: @escaping WebDownloaderProgressClosure, completed: @escaping WebDownloaderCompletedClosure, cancel: @escaping WebDownloaderCancelClosure) -> WebCombineOperation {
        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 15)
        request.httpShouldUsePipelining = true
        let key = url.absoluteString
        let combineOperation = WebCombineOperation()
        combineOperation.cacheOperation = WebCacheManager.shared().queryDataFromMemory(key: key, completed: { [weak self] (data, hasCache) in
            if hasCache {
                completed(data as? Data, nil, true)
            } else {
                let downloadOperation = WebDownloadOperation(request: request, progress: progress, completed: { (data, error, finished) in
                    if finished && error == nil {
                        WebCacheManager.shared().storeDataToCache(data: data, key: key)
                        completed(data, nil, true)
                    } else {
                        completed(data, error, false)
                    }
                }, cancel: {
                    cancel()
                })
                combineOperation.downloadOperation = downloadOperation
                self?.downloadQueue?.addOperation(downloadOperation)
            }
        })
        return combineOperation
    }
}

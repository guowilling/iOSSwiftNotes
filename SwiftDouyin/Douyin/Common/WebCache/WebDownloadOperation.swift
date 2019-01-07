
import Foundation

class WebDownloadOperation: Operation {
    
    var progressClosure: WebDownloaderProgressClosure?
    var completedClosure: WebDownloaderCompletedClosure?
    var cancelClosure: WebDownloaderCancelClosure?
    
    var session: URLSession?
    var dataTask: URLSessionTask?
    var request: URLRequest?
    
    var resourceData: Data?
    var expectedSize: Int64?
    
    var _executing: Bool = false
    var _finished: Bool = false
    
    init(request: URLRequest, progress: @escaping WebDownloaderProgressClosure, completed: @escaping WebDownloaderCompletedClosure, cancel: @escaping WebDownloaderCancelClosure) {
        super.init()
        
        self.request = request
        self.progressClosure = progress
        self.completedClosure = completed
        self.cancelClosure = cancel
    }
    
    override func start() {
        willChangeValue(forKey: "isExecuting")
        _executing = true
        didChangeValue(forKey: "isExecuting")
        
        // 任务执行前是否取消了任务
        if self.isCancelled {
            done()
            return
        }
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 15
        session = URLSession.init(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        dataTask = session?.dataTask(with: request!)
        dataTask?.resume()
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func cancel() {
        objc_sync_enter(self)
        done()
        objc_sync_exit(self)
    }
    
    func done() {
        super.cancel()
        if _executing {
            willChangeValue(forKey: "isFinished")
            willChangeValue(forKey: "isExecuting")
            _finished = true
            _executing = false
            didChangeValue(forKey: "isFinished")
            didChangeValue(forKey: "isExecuting")
            reset()
        }
    }
    
    func reset() {
        if dataTask != nil {
            dataTask?.cancel()
        }
        if session != nil {
            session?.invalidateAndCancel()
            session = nil
        }
    }
}

extension WebDownloadOperation: URLSessionDataDelegate, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        let httpResponse = dataTask.response as! HTTPURLResponse
        let code = httpResponse.statusCode
        if code == 200 {
            completionHandler(URLSession.ResponseDisposition.allow)
            resourceData = Data()
            expectedSize = httpResponse.expectedContentLength
        } else {
            completionHandler(URLSession.ResponseDisposition.cancel)
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        resourceData?.append(data)
        progressClosure?(Int64(resourceData?.count ?? 0), expectedSize ?? 0)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if completedClosure != nil {
            if error != nil {
                let nsError = error! as NSError
                if nsError.code == NSURLErrorCancelled {
                    cancelClosure?()
                } else {
                    completedClosure?(nil, error, false)
                }
            } else {
                completedClosure?(resourceData!, nil, true)
            }
        }
        done()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        if request?.cachePolicy == NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData {
            completionHandler(nil)
        } else {
            completionHandler(proposedResponse)
        }
    }
}


import Foundation
import AVFoundation
import MobileCoreServices

protocol AVPlayerViewDelegate: NSObjectProtocol {
    
    func playerView(_ playerView: AVPlayerView, playerItemStatusChanged status: AVPlayerItem.Status)
    
    func playerView(_ playerView: AVPlayerView, playProgressUpdateCurrent current: CGFloat, duration: CGFloat)
}

class AVPlayerView: UIView {
    
    var delegate: AVPlayerViewDelegate?
    
    var sourceURL: URL?
    var sourceScheme: String?
    var urlAsset: AVURLAsset?
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer = AVPlayerLayer.init()
    var playerTimeObserver: Any?
    
    var session: URLSession?                 // 视频下载 session
    var task: URLSessionDataTask?            // 视频下载 NSURLSessionDataTask
    var response: HTTPURLResponse?           // 视频下载请求响应
    var resourceData: Data?                  // 视频缓冲数据
    var pendingRequests = [AVAssetResourceLoadingRequest]()
    
    var cacheFileKey: String?
    var queryCacheOperation: Operation?
    
    var cancelLoadingQueue: DispatchQueue?
    
    init() {
        super.init(frame: ScreenFrame)
        
        setupSubView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubView() {
        session = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        
        playerLayer = AVPlayerLayer.init(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        self.layer.addSublayer(self.playerLayer)
        
        addProgressObserver()
        
        cancelLoadingQueue = DispatchQueue(label: "com.cancel.loadingqueue")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        playerLayer.frame = self.layer.bounds
        CATransaction.commit()
    }
    
    func setPlayerSource(urlString: String) {
        sourceURL = URL(string: urlString)
        guard let sourceURL = sourceURL else { return }
        var components = URLComponents(url: sourceURL, resolvingAgainstBaseURL: false)
        sourceScheme = components?.scheme
        cacheFileKey = sourceURL.absoluteString
        queryCacheOperation = WebCacheManager.shared().queryURLFromDiskMemory(key: cacheFileKey ?? "", completed: { [weak self] (data, hasCache) in
            DispatchQueue.main.async { [weak self] in
                if !hasCache {
                    self?.sourceURL = self?.sourceURL?.absoluteString.urlScheme(scheme: "streaming")
                } else {
                    self?.sourceURL = URL(fileURLWithPath: data as? String ?? "")
                }
                if let sourceURL = self?.sourceURL {
                    self?.urlAsset = AVURLAsset(url: sourceURL, options: nil)
                    self?.urlAsset?.resourceLoader.setDelegate(self, queue: DispatchQueue.main)
                    if let asset = self?.urlAsset {
                        self?.playerItem = AVPlayerItem(asset: asset)
                        self?.playerItem?.addObserver(self!, forKeyPath: "status", options: [.initial, .new], context: nil)
                        self?.player = AVPlayer(playerItem: self?.playerItem)
                        self?.playerLayer.player = self?.player
                        self?.addProgressObserver()
                    }
                }
            }
        }, exten: "mp4")
    }
    
    func cancelLoading() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        playerLayer.isHidden = true
        CATransaction.commit()
        
        queryCacheOperation?.cancel()
        removeObserver()
        pause()
        
        player = nil
        playerItem = nil
        playerLayer.player = nil
        
        cancelLoadingQueue?.async { [weak self] in
            self?.urlAsset?.cancelLoading()
            
            self?.task?.cancel()
            self?.task = nil
            self?.resourceData = nil
            self?.response = nil
            
            for loadingRequest in self?.pendingRequests ?? [] {
                if !loadingRequest.isFinished {
                    loadingRequest.finishLoading()
                }
            }
            self?.pendingRequests.removeAll()
        }
    }
    
    func play() {
        AVPlayerManager.shared().play(player: player!)
    }
    
    func pause() {
        AVPlayerManager.shared().pause(player: player!)
    }
    
    func replay() {
        AVPlayerManager.shared().replay(player: player!)
    }
    
    func rate() -> CGFloat {
        return CGFloat(player?.rate ?? 0)
    }
    
    deinit {
        removeObserver()
    }
}

extension AVPlayerView {
    
    private func addProgressObserver() {
        playerTimeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: DispatchQueue.main, using: { [weak self] time in
            let current = CMTimeGetSeconds(time)
            let duration = CMTimeGetSeconds(self?.playerItem?.duration ?? CMTime())
            if current == duration {
                self?.replay()
            }
            self?.delegate?.playerView(self!, playProgressUpdateCurrent: CGFloat(current), duration: CGFloat(duration))
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if playerItem?.status == .readyToPlay {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                playerLayer.isHidden = false
                CATransaction.commit()
            }
            delegate?.playerView(self, playerItemStatusChanged: playerItem?.status ?? .unknown)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func removeObserver() {
        playerItem?.removeObserver(self, forKeyPath: "status")
        if let observer = playerTimeObserver {
            player?.removeTimeObserver(observer)
        }
    }
}

extension AVPlayerView: AVAssetResourceLoaderDelegate {
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        if task == nil {
            if let url = loadingRequest.request.url?.absoluteString.urlScheme(scheme: sourceScheme ?? "http") {
                let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60)
                task = session?.dataTask(with: request)
                task?.resume()
            }
        }
        pendingRequests.append(loadingRequest)
        return true
    }
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        if let index = pendingRequests.index(of: loadingRequest) {
            pendingRequests.remove(at: index)
        }
    }
}

extension AVPlayerView: URLSessionTaskDelegate, URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        let httpResponse = dataTask.response as! HTTPURLResponse
        let code = httpResponse.statusCode
        if (code == 200) {
            completionHandler(URLSession.ResponseDisposition.allow)
            self.resourceData = Data()
            self.response = httpResponse
            self.processPendingRequests()
        } else {
            completionHandler(URLSession.ResponseDisposition.cancel)
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.resourceData?.append(data)
        self.processPendingRequests()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error == nil {
            WebCacheManager.shared().storeDataToDiskCache(data: self.resourceData, key: self.cacheFileKey ?? "", exten: "mp4")
        } else {
            print("AVPlayer resouce download error:" + error.debugDescription)
        }
    }
    
    // Asks the delegate whether the data (or upload) task should store the response in the cache.
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        let cachedResponse = proposedResponse
        if dataTask.currentRequest?.cachePolicy == NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData || dataTask.currentRequest?.url?.absoluteString == self.task?.currentRequest?.url?.absoluteString {
            completionHandler(nil)
        } else {
            completionHandler(cachedResponse)
        }
    }
    
    func processPendingRequests() {
        var completedRequests = [AVAssetResourceLoadingRequest]()
        for request in self.pendingRequests {
            let isCompleted = isRespondCompletedForRequest(assetResourceLoadingRequest: request)
            if isCompleted {
                completedRequests.append(request)
                request.finishLoading()
            }
        }
        for request in completedRequests {
            if let index = pendingRequests.index(of: request) {
                pendingRequests.remove(at: index)
            }
        }
    }
    
    func isRespondCompletedForRequest(assetResourceLoadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        let mimeType = self.response?.mimeType ?? ""
        let contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)
        assetResourceLoadingRequest.contentInformationRequest?.isByteRangeAccessSupported = true
        assetResourceLoadingRequest.contentInformationRequest?.contentType = contentType?.takeRetainedValue() as String?
        assetResourceLoadingRequest.contentInformationRequest?.contentLength = (self.response?.expectedContentLength)!
        
        var startOffset: Int64 = assetResourceLoadingRequest.dataRequest?.requestedOffset ?? 0
        if assetResourceLoadingRequest.dataRequest?.currentOffset != 0 {
            startOffset = assetResourceLoadingRequest.dataRequest?.currentOffset ?? 0
        }
        if Int64(resourceData?.count ?? 0) < startOffset {
            return false
        }
        
        let unreadBytes: Int64 = Int64(resourceData?.count ?? 0) - (startOffset)
        let numberOfBytesToRespond: Int64 = min(Int64(assetResourceLoadingRequest.dataRequest?.requestedLength ?? 0), unreadBytes)
        if let subdata = (resourceData?.subdata(in: Int(startOffset)..<Int(startOffset + numberOfBytesToRespond))) {
            assetResourceLoadingRequest.dataRequest?.respond(with: subdata)
            let endOffset: Int64 = startOffset + Int64(assetResourceLoadingRequest.dataRequest?.requestedLength ?? 0)
            return Int64(resourceData?.count ?? 0) >= endOffset
        }
        return false
    }
}

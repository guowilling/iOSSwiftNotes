
import Foundation
import Alamofire

let NetworkStatusDidChangeNotification = "NetworkStatusDidChangeNotification"

typealias HTTPSuccessClosure = (_ data: Any) -> Void
typealias HTTPFailureClosure = (_ error: Error) -> Void

enum NetworkError: Int {
    case HTTPResquestFailed = -1000
    case URLResourceFailed = -2000
}

class HTTPManager: NSObject {
    
    private static let reachabilityManager = { () -> NetworkReachabilityManager in
        let manager = NetworkReachabilityManager.init()
        return manager!
    }()
    
    private static let sessionManager = { () -> SessionManager in
        let manager = SessionManager.default
        return manager
    }()
}

extension HTTPManager {
    
    static func GET(urlString: String,
                    request: BaseRequest,
                    success: @escaping HTTPSuccessClosure,
                    failure: @escaping HTTPFailureClosure) {
        sessionManager.request(Host + urlString,
                               method: HTTPMethod.get,
                               parameters: request.toJSON(),
                               encoding: URLEncoding.default,
                               headers: nil)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success:
                    let data: [String: Any] = response.result.value as! [String: Any]
                    processData(data: data, success: success, failure: failure)
                case .failure(let error):
                    if (NetworkReachabilityManager.init()?.networkReachabilityStatus == .notReachable) {
                        failure(error)
                    } else {
                        let path = response.request?.url?.path
                        if (path?.contains(FIND_USER_BY_UID))! {
                            success(String.readJSON2DicWithFileName(fileName: "user"))
                        } else if (path?.contains(LIST_AWEME_POST))! {
                            success(String.readJSON2DicWithFileName(fileName: "awemes"))
                        } else if (path?.contains(LIST_AWEME_FAVORITE))! {
                            success(String.readJSON2DicWithFileName(fileName: "favorites"))
                        } else if (path?.contains(LIST_COMMENT))! {
                            success(String.readJSON2DicWithFileName(fileName: "comments"))
                        } else if (path?.contains(LIST_GROUP_CHAT))! {
                            success(String.readJSON2DicWithFileName(fileName: "groupchats"))
                        } else {
                            failure(error)
                        }
                    }
                }
            })
    }
    
    static func POST(urlString: String,
                     request: BaseRequest,
                     success: @escaping HTTPSuccessClosure,
                     failure: @escaping HTTPFailureClosure) {
        sessionManager.request(Host + urlString,
                               method: HTTPMethod.post,
                               parameters: request.toJSON(),
                               encoding: URLEncoding.default,
                               headers: nil)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success:
                    let data: [String: Any] = response.result.value as! [String: Any]
                    processData(data: data, success: success, failure: failure)
                case .failure(let error):
                    failure(error)
                }
            })
    }
    
    static func UPLOAD(urlString: String,
                       data: Data,
                       request: BaseRequest,
                       progress: @escaping ((_ percent: CGFloat) -> Void),
                       success: @escaping HTTPSuccessClosure,
                       failure: @escaping HTTPFailureClosure) {
        let parameters = request.toJSON()
        sessionManager.upload(multipartFormData: { multipartFormData in
            for (key,value) in parameters! {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
            }
            multipartFormData.append(data, withName: "file", fileName: "file", mimeType: "multipart/form-data")
        }, usingThreshold: UInt64.init(), to: Host + urlString, method: HTTPMethod.post, headers: nil, encodingCompletion: { encodingResult in
            switch(encodingResult) {
            case .success(let request, _, _):
                request.uploadProgress(closure: { uploadProgress in
                    progress(CGFloat(uploadProgress.completedUnitCount) / CGFloat(uploadProgress.totalUnitCount))
                }).responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success:
                        let data: [String: Any] = response.result.value as! [String: Any]
                        processData(data: data, success: success, failure: failure)
                    case .failure(let error):
                        failure(error)
                    }
                })
            case .failure(let error):
                failure(error)
            }
        })
    }
    
    static func DELETE(urlString: String,
                       request: BaseRequest,
                       success: @escaping HTTPSuccessClosure,
                       failure: @escaping HTTPFailureClosure) {
        sessionManager.request(Host + urlString,
                               method: HTTPMethod.delete,
                               parameters: request.toJSON(),
                               encoding: URLEncoding.default,
                               headers: nil)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success:
                    let data: [String: Any] = response.result.value as! [String: Any]
                    processData(data: data, success: success, failure: failure)
                case .failure(let error):
                    failure(error)
                }
            })
    }
}

extension HTTPManager {
    
    static func processData(data: [String: Any], success: @escaping HTTPSuccessClosure, failure: @escaping HTTPFailureClosure) {
        let code: Int = data["code"] as! Int
        if (code == 0) {
            success(data)
        } else {
            let message:String = data["message"] as! String
            let error = NSError.init(domain: "com.demo.douyin", code: NetworkError.HTTPResquestFailed.rawValue, userInfo: [NSLocalizedDescriptionKey : message])
            failure(error)
        }
    }
    
    static func startMonitoring() {
        reachabilityManager.startListening()
        reachabilityManager.listener = { status in
            NotificationCenter.default.post(name: Notification.Name(rawValue: NetworkStatusDidChangeNotification), object: status)
        }
    }
    
    static func networkStatus() ->NetworkReachabilityManager.NetworkReachabilityStatus {
        return reachabilityManager.networkReachabilityStatus
    }
    
    static func isNetworkReachable(status: Any?) -> Bool {
        return (status as! NetworkReachabilityManager.NetworkReachabilityStatus) != .notReachable
    }
}

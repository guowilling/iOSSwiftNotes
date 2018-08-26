
import UIKit
import AFNetworking

// Swift 中的枚举支持任意数据类型
// OC 中的枚举只支持整数类型

enum WBHTTPMethod {
    case GET
    case POST
}

/// 网络管理工具
class WBNetworkManager: AFHTTPSessionManager {
    /// 静态区 & 常量 & 闭包
    /// 第一次访问时执行闭包, 并将结果保存到 shared 常量中.
    static let shared: WBNetworkManager = {
        let instance = WBNetworkManager()
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return instance
    }()
    
    lazy var userAccount = WBUserAccount()
    
    /// 用户登录标记(计算型属性)
    var userLogon: Bool {
        return userAccount.access_token != nil
    }
    
    /// token 处理
    ///
    /// - parameter method:     GET / POST
    /// - parameter URLString:  URLString
    /// - parameter parameters: 参数字典
    /// - parameter name:       上传文件使用的字段名, 默认为 nil, 非上传文件
    /// - parameter data:       上传文件的二进制数据, 默认为 nil, 非上传文件
    /// - parameter completion: 完成回调
    func tokenRequest(method: WBHTTPMethod = .GET, URLString: String, parameters: [String: AnyObject]?, name: String? = nil, data: Data? = nil, completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool)->()) {
        guard let token = userAccount.access_token else {
            //print("没有 token, 需要先登录")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserLoginNeededNotification),
                                            object: nil)
            completion(nil, false)
            return
        }
        var parameters = parameters
        if parameters == nil {
            parameters = [String: AnyObject]()
        }
        parameters!["access_token"] = token as AnyObject?
        
        if let name = name, let data = data { // 文件上传
            upload(URLString: URLString, parameters: parameters, name: name, data: data, completion: completion)
        } else { // 网络请求
            request(method: method, URLString: URLString, parameters: parameters, completion: completion)
        }
    }
    
    /// 封装 AFN 的文件上传方法
    func upload(URLString: String, parameters: [String: AnyObject]?, name: String, data: Data, completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool)->()) {
        post(URLString, parameters: parameters, constructingBodyWith: { (formData) in
            // 1. data: 要上传的二进制数据
            // 2. name: 服务器接收数据的字段名
            // 3. fileName: 保存在服务器的文件名
            // 4. mimeType: 告诉服务器上传文件的类型, 如果不想告诉可以使用 application/octet-stream(image/png image/jpg image/gif)
            formData.appendPart(withFileData: data, name: name, fileName: "xxx", mimeType: "application/octet-stream")
            }, progress: nil, success: { (_, json) in
                completion(json as AnyObject?, true)
            }) { (task, error) in
                if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                    print("token 过期了!")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserLoginNeededNotification),
                                                    object: "bad token")
                }
                print("网络错误: \(error)")
                completion(nil, false)
        }
    }
    
    /// 封装 AFN 的 GET / POST 方法
    func request(method: WBHTTPMethod = .GET, URLString: String, parameters: [String: AnyObject]?, completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool)->()) {
        let success = { (task: URLSessionDataTask, json: Any?) ->() in
            completion(json as AnyObject?, true)
        }
        let failure = { (task: URLSessionDataTask?, error: Error) ->() in
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                print("token 过期了!")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserLoginNeededNotification),
                                                object: "bad token")
            }
            print("网络错误: \(error)")
            completion(nil, false)
        }
        if method == .GET {
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}

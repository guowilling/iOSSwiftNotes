
import Foundation

extension WBNetworkManager {
    /// 加载微博数据
    ///
    /// - parameter since_id:   ID 比 since_id 大的微博, 默认为0(即比 since_id 时间晚的微博)
    /// - parameter max_id:     ID 比 max_id 小的微博, 默认为 0
    /// - parameter completion: 完成回调(微博字典数组, 是否成功)
    func statusList(since_id: Int64 = 0, max_id: Int64 = 0, completion: @escaping (_ list: [[String: AnyObject]]?, _ isSuccess: Bool)->()) {
        let URLString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        // Swift 中 Int 可以转换成 AnyObject/ 但是 Int64 不行
        let params = ["since_id": "\(since_id)",
                      "max_id": "\(max_id > 0 ? max_id - 1 : 0)"]
      
        tokenRequest(URLString: URLString, parameters: params as [String: AnyObject]?) { (json, isSuccess) in
            // 从 json 中获取 statuses 字典数组, 如果 as? 失败, result == nil
            let result = json?["statuses"] as? [[String: AnyObject]]
            completion(result, isSuccess)
        }
    }
    
    /// 返回微博的未读数量
    func unreadCount(completion: @escaping (_ count: Int)->()) {
        guard let uid = userAccount.uid else {
            return
        }
        let URLString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        let params = ["uid": uid]
        tokenRequest(URLString: URLString, parameters: params as [String: AnyObject]?) { (json, isSuccess) in
            let dict = json as? [String: AnyObject]
            let count = dict?["status"] as? Int
            completion(count ?? 0)
        }
    }
    
    /// 发布微博
    ///
    /// - parameter text:       要发布的文本
    /// - parameter image:      要上传的图像, 如果为 nil 表示纯文本微博
    /// - parameter completion: 完成回调
    func postStatus(text: String, image: UIImage?, completion: @escaping (_ result: [String: AnyObject]?, _ isSuccess: Bool)->()) -> () {
        let URLString: String
        if image == nil {
            URLString = "https://api.weibo.com/2/statuses/update.json"
        } else {
            URLString = "https://upload.api.weibo.com/2/statuses/upload.json"
        }
        let params = ["status": text]
        var name: String?
        var data: Data?
        if image != nil {
            name = "pic"
            data = UIImagePNGRepresentation(image!)
        }
        tokenRequest(method: .POST, URLString: URLString, parameters: params as [String: AnyObject]?, name: name, data: data) { (json, isSuccess) in
            completion(json as? [String: AnyObject], isSuccess)
        }
    }
}

// MARK: - OAuth 授权
extension WBNetworkManager {
    /// 提问: 网络请求异步到底应该返回什么? 需要什么返回什么?
    /// 加载 AccessToken
    ///
    /// - parameter code:       授权码
    /// - parameter completion: 完成回调[是否成功]
    func loadAccessToken(code: String, completion: @escaping (_ isSuccess: Bool)->()) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id": WBAppKey,
                      "client_secret": WBAppSecret,
                      "grant_type": "authorization_code",
                      "code": code,
                      "redirect_uri": WBRedirectURI]
        request(method: .POST, URLString: urlString, parameters: params as [String : AnyObject]?) { (json, isSuccess) in
            // 请求失败对用户账户数据也不会有任何影响, 直接使用字典设置 userAccount 的属性.
            self.userAccount.yy_modelSet(with: (json as? [String: AnyObject]) ?? [:])
            self.loadUserInfo(completion: { (dict) in
                // 使用用户信息字典设置用户账户信息, 昵称和头像地址.
                self.userAccount.yy_modelSet(with: dict)
                self.userAccount.saveAccount()
                print(self.userAccount)
                completion(isSuccess)
            })
        }
    }
    
    /// 加载当前用户信息
    func loadUserInfo(completion: @escaping (_ dict: [String: AnyObject])->()) {
        guard let uid = userAccount.uid else {
            return
        }
        let URLString = "https://api.weibo.com/2/users/show.json"
        let params = ["uid": uid]
        tokenRequest(URLString: URLString, parameters: params as [String : AnyObject]?) { (json, isSuccess) in
            completion((json as? [String: AnyObject]) ?? [:])
        }
    }
}

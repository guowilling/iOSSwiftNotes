
import Foundation

/// DAL: Data Access Layer 数据访问层
class WBStatusListDAL {
    /// 读取本地数据库或者加载网络数据
    ///
    /// - parameter since_id:   下拉刷新 id
    /// - parameter max_id:     上拉刷新 id
    /// - parameter completion: 完成回调(微博的字典数组, 是否成功)
    class func loadStatus(since_id: Int64 = 0, max_id: Int64 = 0, completion: @escaping (_ list: [[String: AnyObject]]?, _ isSuccess: Bool)->()) {
        guard let userId = WBNetworkManager.shared.userAccount.uid else {
            return
        }
        // 读取本地数据库
        let array = SQLiteManager.shared.loadStatus(userId: userId, since_id: since_id, max_id: max_id)
        if array.count > 0 {
            completion(array, true)
            return
        }
        // 加载网路数据
        WBNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            if !isSuccess {
                completion(nil, false)
                return
            }
            guard let list = list else {
                completion(nil, isSuccess)
                return
            }
            // 保存数据到本地数据库
            SQLiteManager.shared.updateStatus(userId: userId, array: list)
            completion(list, isSuccess)
        }
    }
}

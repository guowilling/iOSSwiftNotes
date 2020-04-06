
import Foundation
import SDWebImage

// Swift 中是否继承:
// 1. 如果需要使用 KVC 或者字典转模型框架, 类需要继承自 NSObject
// 2. 如果只是包装代码逻辑(函数), 可以不用继承自任何类, 更加轻量级
// 3. OC 的类一般都继承自 NSObject

private let maxPullupTryTimes = 5

/// 微博列表视图模型, 负责微博的数据处理
class WBStatusListViewModel {
    /// 懒加载微博视图模型数组
    lazy var statusList = [WBStatusViewModel]()
    
    private var pullupErrorTimes = 0
    
    /// 加载微博列表数据
    ///
    /// - parameter pullup:     是否是上拉刷新
    /// - parameter completion: 加载数据完成回调(是否成功, 是否刷新表格)
    func loadStatus(pullup: Bool, completion: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) {
        if pullup && pullupErrorTimes > maxPullupTryTimes {
            completion(true, false)
            return
        }
        // 下拉刷新 since_id 数组中第一条微博的 id
        let since_id = pullup ? 0 : (statusList.first?.status.id ?? 0)
        // 上拉刷新 max_id 数组中最后一条微博的 id
        let max_id = !pullup ? 0 : (statusList.last?.status.id ?? 0)
        WBStatusListDAL.loadStatus(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            if !isSuccess {
                completion(false, false)
                return
            }
            // 字典转模型 => 视图模型
            var array = [WBStatusViewModel]()
            for dict in list ?? [] {
                let status = WBStatus()
                status.yy_modelSet(with: dict)
                let viewModel = WBStatusViewModel(model: status)
                array.append(viewModel)
            }
            if pullup {
                self.statusList += array // 上拉刷新结果拼接在数组末尾
            } else {
                self.statusList = array + self.statusList // 下拉刷新结果拼接在数组前面
            }
            if pullup && array.count == 0 {
                self.pullupErrorTimes += 1
                completion(isSuccess, false)
            } else {
                self.cacheSingleImage(list: array, finished: completion)
            }
        }
    }
    
    /// 缓存本次微博数据中的单张图片
    /// 应该缓存完单张图片, 并且修改配图视图的大小之后, 再回调才能够保证表格等比例显示单张图像
    private func cacheSingleImage(list: [WBStatusViewModel], finished: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) {
        let dispatchGroup = DispatchGroup() // 调度组
        var length = 0 // 图片缓存大小
      
        // 遍历数组缓存单张图片的微博
        for viewModel in list {
            if viewModel.picURLs?.count != 1 {
                continue
            }
            guard let pic = viewModel.picURLs?[0].thumbnail_pic,
                let url = URL(string: pic) else {
                    continue
            }
            dispatchGroup.enter()
//            SDWebImageDownloader.shared.downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _) in
//                if let image = image,
//                    let data = UIImagePNGRepresentation(image) {
//                    length += data.count
//                    viewModel.updateSingleImageSize(image: image)
//                }
//                dispatchGroup.leave() // 放在回调的最后一句
//            })
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            print("图片缓存完成 \(length / 1024) K")
            finished(true, true)
        }
    }
}

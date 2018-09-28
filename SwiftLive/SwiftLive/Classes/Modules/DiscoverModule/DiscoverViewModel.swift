
import UIKit

class DiscoverViewModel: HomeViewModel {
    lazy var carouselModels: [CarouselModel] = [CarouselModel]()
}

extension DiscoverViewModel {
    func loadDiscoverData(_ complection : @escaping () -> ()) {
        HTTPRequestTool.request(.get, URLString: "http://qf.56.com/home/v4/guess.ios", parameters: ["count": 27], completion: { (result: Any) in
            guard let resultDict = result as? [String: Any] else {
                return
            }
            guard let msgDict = resultDict["message"] as? [String: Any] else {
                return
            }
            guard let dataArray = msgDict["anchors"] as? [[String: Any]] else {
                return
            }
            for dict in dataArray {
                self.anchorModels.append(AnchorModel(dict: dict))
            }
            complection()
        })
    }
}

extension DiscoverViewModel {
    func loadCarouselData(_ complection : @escaping () -> ()) {
        HTTPRequestTool.request(.get, URLString: "http://qf.56.com/home/v4/getBanners.ios", completion: { (result: Any) in
            guard let resultDict = result as? [String: Any] else {
                return
            }
            guard let msgDict = resultDict["message"] as? [String: Any] else {
                return
            }
            guard let bannersDict = msgDict["banners"] as? [[String: Any]] else {
                return
            }
            for bannerDict in bannersDict {
                self.carouselModels.append(CarouselModel(dict: bannerDict))
            }
            complection()
        })
    }
}

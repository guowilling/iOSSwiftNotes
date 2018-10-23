
import UIKit

class HomeViewModel: NSObject {
    lazy var anchorModels = [AnchorModel]()
}

extension HomeViewModel {
    func loadAnchorData(anchorType: AnchorType, index: Int, completion: @escaping () -> ()) {
        let params = ["type": anchorType.type, "index": index, "size": 48]
        HTTPRequestTool.request(.get, URLString: "http://qf.56.com/home/v4/moreAnchor.ios", parameters: params, completion: { (result) -> Void in
            guard let resultDict = result as? [String: Any] else {
                return
            }
            guard let messageDict = resultDict["message"] as? [String: Any] else {
                return
            }
            guard let anchorsDict = messageDict["anchors"] as? [[String: Any]] else {
                return
            }
            for (index, anchorDict) in anchorsDict.enumerated() {
                let anchorModel = AnchorModel(dict: anchorDict)
                anchorModel.isEvenIndex = index % 2 == 0
                self.anchorModels.append(anchorModel)
            }
            completion()
        })
    }
}

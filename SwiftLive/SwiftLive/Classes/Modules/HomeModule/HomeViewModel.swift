
import UIKit

class HomeViewModel: NSObject {
    lazy var anchorModels = [AnchorModel]()
}

extension HomeViewModel {
    
    func loadAnchorData(anchorType: AnchorType, index: Int, completion: @escaping () -> ()) {
        HTTPRequestTool.request(.get, urlString: "http://qf.56.com/home/v4/moreAnchor.ios", parameters: ["type": anchorType.type, "index": index, "size": 48], completion: { (result) -> Void in
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
                let anchor = AnchorModel(dict: anchorDict)
                anchor.isEvenIndex = index % 2 == 0
                self.anchorModels.append(anchor)
            }
            completion()
        })
    }
}

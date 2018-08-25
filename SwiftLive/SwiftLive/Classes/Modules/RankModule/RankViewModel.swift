
import UIKit

class RankViewModel: NSObject {

    lazy var dateModels: [RankDateModel] = [RankDateModel]()
    lazy var weekModels: [[RankWeekModel]] = [[RankWeekModel]]()
}

extension RankViewModel {
    
    func loadRankDateData(_ type: RankType, _ complection: @escaping () -> ()) {
        let urlString = "http://qf.56.com/rank/v1/\(type.typeName).ios"
        let parameters = ["pageSize": 30, "type": type.typeNum]
        HTTPRequestTool.request(.get, urlString: urlString, parameters: parameters, completion: { result in
            guard let resultDict = result as? [String: Any] else {
                return
            }
            guard let msgDict = resultDict["message"] as? [String: Any] else {
                return
            }
            guard let dataArray = msgDict[type.typeName] as? [[String: Any]] else {
                return
            }
            for dict in dataArray {
                self.dateModels.append(RankDateModel(dict: dict))
            }
            complection()
        })
    }
}

extension RankViewModel {
    
    func loadRankWeekData(_ rankType: RankType, _ completion: @escaping () -> ()) {
        let urlString = "http://qf.56.com/activity/star/v1/rankAll.ios"
        let signature = rankType.typeNum == 1 ? "b4523db381213dde637a2e407f6737a6" : "d23e92d56b1f1ac6644e5820eb336c3e"
        let ts = rankType.typeNum == 1 ? "1480399365" : "1480414121"
        let parameters: [String: Any] = ["imei": "36301BB0-8BBA-48B0-91F5-33F1517FA056", "pageSize": 30, "signature": signature, "ts": ts, "weekly": rankType.typeNum - 1]
        HTTPRequestTool.request(.get, urlString: urlString, parameters: parameters, completion: { result in
            guard let resultDict = result as? [String: Any] else {
                return
            }
            guard let msgDict = resultDict["message"] as? [String: Any] else {
                return
            }
            if let anchorDataArray = msgDict["anchorRank"] as? [[String: Any]] {
                self.processDatas(anchorDataArray)
            }
            if let fansDataArray = msgDict["fansRank"] as? [[String: Any]] {
                self.processDatas(fansDataArray)
            }
            completion()
        })
    }
    
    private func processDatas(_ dataArray: [[String: Any]]) {
        var weekModelsTemp = [RankWeekModel]()
        for dict in dataArray {
            weekModelsTemp.append(RankWeekModel(dict: dict))
        }
        weekModels.append(weekModelsTemp)
    }
}

//
//  LiveRoomViewModel.swift
//  SwiftLive
//
//  Created by 郭伟林 on 2017/9/21.
//  Copyright © 2017年 SR. All rights reserved.
//

import UIKit

class LiveRoomViewModel: NSObject {
    lazy var liveURLString: String = ""
}

extension LiveRoomViewModel {
    
    func loadLiveURL(_ roomid: Int, _ userId: String, _ completion: @escaping () -> ()) {
        let URLString = "http://qf.56.com/play/v2/preLoading.ios"
        let parameters: [String: Any] = ["imei": "36301BB0-8BBA-48B0-91F5-33F1517FA056",
                                         "roomId": roomid,
                                         "signature": "f69f4d7d2feb3840f9294179cbcb913f",
                                         "userId": userId]
        HTTPRequestTool.request(.get, URLString: URLString, parameters: parameters, completion: {
            result in
            guard let resultDict = result as? [String: Any] else {
                return
            }
            guard let msgDict = resultDict["message"] as? [String: Any] else {
                return
            }
            guard let requestURL = msgDict["rUrl"] as? String else {
                return
            }
            self.loadOnliveURL(requestURL, completion)
        })
    }
    
    fileprivate func loadOnliveURL(_ URLString: String, _ complection: @escaping () -> ()) {
        HTTPRequestTool.request(.get, URLString: URLString, completion: { result in
            guard let resultDict = result as? [String: Any] else {
                return
            }
            guard let liveURLString = resultDict["url"] as? String else {
                return
            }
            self.liveURLString = liveURLString
            complection()
        })
    }
}


import Foundation
import Starscream

let WebSocketDidReceiveMessageNotification = "WebSocketDidReceiveMessageNotification"

let WebSocketMaxReConnectCount = 5

class WebSocketManger: NSObject {
    
    var reConnectCount: Int = 0
    
    let websocket = { () -> WebSocket in
        var components = URLComponents(url: URL(string: Host + "/groupchat")!, resolvingAgainstBaseURL: false)
        components?.scheme = "ws"
        var request = URLRequest.init(url: components!.url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
        request.addValue(UDID, forHTTPHeaderField: "udid")
        let websocket = WebSocket.init(request: request)
        return websocket
    }()
    
    private static let instance = { () -> WebSocketManger in
        return WebSocketManger.init()
    }()
    
    private override init() {
        super.init()
        
        websocket.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusDidChange(notification:)), name: Notification.Name(rawValue: NetworkStatusDidChangeNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    class func shared() -> WebSocketManger {
        return instance
    }
    
    func connect() {
        if websocket.isConnected {
            disConnect()
        }
        websocket.connect()
    }
    
    func disConnect() {
        websocket.disconnect()
    }
    
    func reConnect() {
        if websocket.isConnected {
            disConnect()
        }
        websocket.connect()
    }
    
    func sendMessage(msg: String) {
        if websocket.isConnected {
            websocket.write(string: msg)
        }
    }
    
    @objc func networkStatusDidChange(notification: NSNotification) {
        if HTTPManager.isNetworkReachable(status: notification.object) && !websocket.isConnected {
            reConnect()
        }
    }
}

extension WebSocketManger: WebSocketDelegate {
    
    func websocketDidConnect(socket: WebSocketClient) {
        self.reConnectCount = 0
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if HTTPManager.networkStatus() != .notReachable {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0 , execute: {
                if self.websocket.isConnected {
                    self.reConnectCount = 0
                    return
                }
                if self.reConnectCount >= WebSocketMaxReConnectCount {
                    self.reConnectCount = 0
                    return
                }
                self.reConnect()
                self.reConnectCount += 1
            })
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WebSocketDidReceiveMessageNotification), object: text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("websocketDidReceiveData data: \(data)")
    }
}


import UIKit
import CoreTelephony

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController.init(rootViewController: UserHomeController.init())
        window?.makeKeyAndVisible()
        
        HTTPManager.startMonitoring()
        WebSocketManger.shared().connect()
        AVPlayerManager.setAudioMode()
        
        VisitorRequest.saveOrFindVisitor(success: { data in
            let response = data as! VisitorResponse
            let visitor = response.data
            Visitor.write(visitor:visitor!)
        }, failure: { error in
            print(error)
        })
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touchLocation = (event?.allTouches)?.first?.location(in: self.window)
        if UIApplication.shared.statusBarFrame.contains(touchLocation!) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DidTouchStatusBarNotification"), object: nil)
        }
    }
}


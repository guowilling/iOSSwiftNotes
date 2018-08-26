
import UIKit
import UserNotifications
import SVProgressHUD
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupAdditions()
        
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = WBTabBarController()
        window?.makeKeyAndVisible()
        
        loadMainJSON()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

// 问题: OC 中支持多继承吗? 如果不支持, 如何替代? 答案: 使用协议替代.
// Swift 的写法更类似于多继承
// class WBBaseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
// ...
// }

// extension 类似于 OC 的 分类, Swift 中可以用来组织代码, 相近功能的函数放在一个 extension 中, 便于代码的维护.
// 注意: 
// 1. 和 OC 的分类一样, extension 中不能定义属性.
// 2. extension 中不能重写`父类`本类的方法, 重写父类方法是子类对类的继承, extension 是对类的扩展.

extension AppDelegate {
    
    fileprivate func setupAdditions() {
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        
        // #available 检测设备系统版本
        if #available(iOS 10.0, *) { // >= 10.0
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .carPlay, .sound]) { (success, error) in
                print("通知授权: " + (success ? "成功" : "失败"))
            }
        } else { // < 10.0
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
    fileprivate func loadMainJSON() {
        DispatchQueue.global().async {
            let url = Bundle.main.url(forResource: "main.json", withExtension: nil)
            let data = NSData(contentsOf: url!)
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
            data?.write(toFile: jsonPath, atomically: true)
        }
    }
}

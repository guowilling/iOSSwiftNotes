
import UIKit
import SVProgressHUD

class WBTabBarController: UITabBarController {
    
    fileprivate var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        setupChildControllers()
        setupComposeButton()
        
        setupTimer()
        
        setupNewfeatureViews()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userLoginAction),
                                               name: NSNotification.Name(rawValue: WBUserLoginNeededNotification),
                                               object: nil)
    }
    
    deinit {
        timer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: - 私有控件
    fileprivate lazy var composeButton: UIButton = UIButton.sr_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
    
    // MARK: - 监听方法
    @objc private func userLoginAction(notification: Notification) {
        var when = DispatchTime.now()
        if notification.object != nil {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showInfo(withStatus: "登录状态已经超时, 请重新登录")
            when = DispatchTime.now() + 2
        }
        DispatchQueue.main.asyncAfter(deadline: when) {
            SVProgressHUD.setDefaultMaskType(.clear)
            let navC = UINavigationController(rootViewController: WBOAuthViewController())
            self.present(navC, animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func composeStatus() {
        if !WBNetworkManager.shared.userLogon {
            return
        }
        let navC = UINavigationController(rootViewController: WBComposeViewController.init())
        navC.view.layoutIfNeeded()
        self.present(navC, animated: true, completion: nil)
    }
}

// MARK: - Child Controllers
extension WBTabBarController {
    
    fileprivate func setupChildControllers() {
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
        var data = NSData(contentsOfFile: jsonPath)
        if data == nil {
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            data = NSData(contentsOfFile: path!)
        }
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String: AnyObject]] else {
            return
        }
        var arrayM = [UIViewController]()
        for dict in array! {
            arrayM.append(controller(dict: dict))
        }
        viewControllers = arrayM
    }
    
    fileprivate func controller(dict: [String: AnyObject]) -> UIViewController {
        guard let clsName = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? WBBaseViewController.Type,
            let visitorDict = dict["visitorInfo"] as? [String: String] else {
                return UIViewController()
        }
        let vc = cls.init()
        vc.title = title
        vc.visitorInfoDictionary = visitorDict
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orange], for: .highlighted)
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12)], for: UIControlState(rawValue: 0))
        let navC = WBNavigationController(rootViewController: vc) // 实例化导航控制器的时候, 会调用 push 方法将 rootVC 压入栈顶
        return navC
    }
    
    fileprivate func setupComposeButton() {
        tabBar.addSubview(composeButton)
        let count = CGFloat(childViewControllers.count)
        let w = tabBar.bounds.width / count
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0) // CGRectInset 正数向内缩进, 负数向外扩展
        //print("composeButton 宽度: \(composeButton.bounds.width)")
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
    }
}

// MARK: - Timer

extension WBTabBarController {
    fileprivate func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func timerUpdate() {
        if !WBNetworkManager.shared.userLogon {
            return
        }
        WBNetworkManager.shared.unreadCount { (count) in
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
}

// MARK: - New Features
extension WBTabBarController {
    
    fileprivate func setupNewfeatureViews() {
        let aView = isNewVersion ? WBNewFeatureView.newFeatureView() : WBWelcomeView.welcomeView()
        view.addSubview(aView)
    }
    
    // extesions 中可以有计算型属性
    private var isNewVersion: Bool {
        //print(Bundle.main().infoDictionary)
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        //print("当前版本:" + currentVersion)
        
        let path: String = ("version" as NSString).sr_appendDocumentDir()
        let sandboxVersion = (try? String(contentsOfFile: path)) ?? ""
        //print("沙盒版本:" + sandboxVersion)
        
        _ = try? currentVersion.write(toFile: path, atomically: true, encoding: .utf8)
        
        return currentVersion != sandboxVersion
    }
}

// MARK: - UITabBarControllerDelegate
extension WBTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = (childViewControllers as NSArray).index(of: viewController)
        if selectedIndex == 0 && index == selectedIndex {
            let navC = childViewControllers[0] as! UINavigationController
            let vc = navC.childViewControllers[0] as! WBHomeViewController
            vc.tableView?.setContentOffset(CGPoint(x: 0, y: -64), animated: true) // 滚动到顶部
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { // 刷新数据, 增加延迟是为了保证表格先滚动到顶部再刷新
                vc.loadData()
            })
            vc.tabBarItem.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        return !viewController.isMember(of: UIViewController.self)
    }
}

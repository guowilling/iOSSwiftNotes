//
//  AppDelegate.swift
//  SwiftU17
//
//  Created by Willing Guo on 2018/8/26.
//  Copyright © 2018年 SR. All rights reserved.
//

import UIKit
import ESTabBarController_swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        
        let tabBarController = ESTabBarController()
        
        let vc1 = U17TodayViewController()
        let vc2 = U17FindController()
        let vc3 = U17BookrackController()
        let vc4 = U17MineViewController()
        
        vc1.tabBarItem = ESTabBarItem.init(U17TabBarItemBounces(), title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        vc2.tabBarItem = ESTabBarItem.init(U17TabBarItemBounces(), title: "Find", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        vc3.tabBarItem = ESTabBarItem.init(U17TabBarItemBounces(), title: "Favor", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        vc4.tabBarItem = ESTabBarItem.init(U17TabBarItemBounces(), title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        vc1.title = "今日"
        vc2.title = "发现"
        vc3.title = "书架"
        vc4.title = "我的"
        
        let nvC1 = U17NavigationController.init(rootViewController: vc1)
        let nvC2 = U17NavigationController.init(rootViewController: vc2)
        let nvC3 = U17NavigationController.init(rootViewController: vc3)
        let nvC4 = U17NavigationController.init(rootViewController: vc4)
        
        tabBarController.viewControllers = [nvC1, nvC2, nvC3, nvC4]
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        
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


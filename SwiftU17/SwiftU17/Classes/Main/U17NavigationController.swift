//
//  U17NavigationController.swift
//  SwiftU17
//
//  Created by Willing Guo on 2018/8/26.
//  Copyright © 2018年 SR. All rights reserved.
//

import UIKit

class U17NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarAppearence()
    }
    
    func setNavBarAppearence() {
        // 设置导航栏默认背景颜色
        WRNavigationBar.defaultNavBarBarTintColor = U17ThemeColor
        // 设置导航栏默认按钮颜色
        WRNavigationBar.defaultNavBarTintColor = .white
        // 设置导航栏默认标题颜色
        WRNavigationBar.defaultNavBarTitleColor = .white
        // 设置状态栏默认样式
        WRNavigationBar.defaultStatusBarStyle = .lightContent
        // 设置导航栏底部分割线是否隐藏
        WRNavigationBar.defaultShadowImageHidden = true
    }
}

extension U17NavigationController {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}

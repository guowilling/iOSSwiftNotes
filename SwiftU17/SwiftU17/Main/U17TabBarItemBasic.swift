//
//  U17TabBarItemBasic.swift
//  SwiftU17
//
//  Created by Willing Guo on 2018/8/26.
//  Copyright © 2018年 SR. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class U17TabBarItemBasic: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
        iconColor = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
        
        highlightTextColor = UIColor.init(red: 254/255.0, green: 73/255.0, blue: 42/255.0, alpha: 1.0)
        highlightIconColor = UIColor.init(red: 254/255.0, green: 73/255.0, blue: 42/255.0, alpha: 1.0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

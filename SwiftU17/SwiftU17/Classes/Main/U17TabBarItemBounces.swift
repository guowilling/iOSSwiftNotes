//
//  U17TabBarItemBounces.swift
//  SwiftU17
//
//  Created by Willing Guo on 2018/8/26.
//  Copyright © 2018年 SR. All rights reserved.
//

import UIKit

class U17TabBarItemBounces: U17TabBarItemBasic {

    public var duration = 0.25
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bouncesAnimation()
        completion?()
    }
    
    override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bouncesAnimation()
        completion?()
    }
    
    func bouncesAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1.0, 1.25, 0.9, 1.0]
        animation.duration = duration * 2
        animation.calculationMode = CAAnimationCalculationMode.cubic
        imageView.layer.add(animation, forKey: nil)
    }
}

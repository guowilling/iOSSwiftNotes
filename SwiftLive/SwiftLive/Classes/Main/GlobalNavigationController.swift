
import UIKit

class GlobalNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var count: UInt32 = 0
        let ivars = class_copyIvarList(UIGestureRecognizer.self, &count)!
        for i in 0..<count {
            let ivar = ivars[Int(i)]
            let name = ivar_getName(ivar)
            print(String(cString: name!))
        }
        
        // 全屏 pop 返回手势
        guard let gesture = interactivePopGestureRecognizer else {
            return
        }
        gesture.isEnabled = false
        
        let target = (gesture.value(forKey: "_targets") as? [NSObject])?.first
        guard let transitionTarget = target?.value(forKey: "_target") else {
            return
        }
        let transitionSelector = Selector(("handleNavigationTransition:"))
        let popGestureRecognizer = UIPanGestureRecognizer(target: transitionTarget, action: transitionSelector)
        
        let gestureView = gesture.view
        gestureView?.addGestureRecognizer(popGestureRecognizer)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: animated)
    }
}


import Foundation

class ScalePresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to) as! AwemeListController
        let fromVC = transitionContext.viewController(forKey: .from) as! UINavigationController
        
        let userHomePageC = fromVC.viewControllers.first as! UserHomeController
        let selectedCell = userHomePageC.collectionView!.cellForItem(at: IndexPath.init(item: userHomePageC.selectIndex, section: 1))
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        
        let initialFrame = userHomePageC.collectionView!.convert(selectedCell?.frame ?? .zero, to: userHomePageC.collectionView!.superview)
        let finalFrame = transitionContext.finalFrame(for: toVC)
        let duration: TimeInterval = self.transitionDuration(using: transitionContext)
        
        toVC.view.center = CGPoint(x: initialFrame.origin.x + initialFrame.size.width / 2, y: initialFrame.origin.y + initialFrame.size.height / 2)
        toVC.view.transform = CGAffineTransform(scaleX: initialFrame.size.width / finalFrame.size.width, y: initialFrame.size.height / finalFrame.size.height)
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .layoutSubviews, animations: {
            toVC.view.center = CGPoint(x: finalFrame.origin.x + finalFrame.size.width / 2, y: finalFrame.origin.y + finalFrame.size.height / 2)
            toVC.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { finished in
            transitionContext.completeTransition(true)
        }
    }
}

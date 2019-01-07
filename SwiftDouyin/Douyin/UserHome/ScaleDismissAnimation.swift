
import Foundation

class ScaleDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    let centerFrame = CGRect(x: (ScreenWidth - 5) / 2, y: (ScreenHeight - 5)/2, width: 5, height: 5)
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from) as! AwemeListController
        let toVC = transitionContext.viewController(forKey: .to) as! UINavigationController
        
        let userHomePageC = toVC.viewControllers.first as! UserHomeController
        var snapshotView: UIView?
        
        var scaleRatio: CGFloat = 1.0
        var finalFrame: CGRect = centerFrame
        if let selectedCell = userHomePageC.collectionView!.cellForItem(at: IndexPath.init(item: fromVC.currentIndex, section: 1)) {
            snapshotView = selectedCell.snapshotView(afterScreenUpdates: false)
            scaleRatio = fromVC.view.frame.width / selectedCell.frame.width
            snapshotView?.layer.zPosition = 20
            finalFrame = userHomePageC.collectionView?.convert(selectedCell.frame, to: userHomePageC.collectionView!.superview) ?? centerFrame
        } else {
            snapshotView = fromVC.view.snapshotView(afterScreenUpdates: false)
            scaleRatio = fromVC.view.frame.width / ScreenWidth
            finalFrame = centerFrame
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(snapshotView!)
        
        snapshotView?.center = fromVC.view.center
        snapshotView?.transform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            snapshotView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            snapshotView?.frame = finalFrame
        }) { finished in
            transitionContext.finishInteractiveTransition()
            transitionContext.completeTransition(true)
            snapshotView?.removeFromSuperview()
        }
        
        fromVC.view.alpha = 0.0
    }
}


import Foundation

class SwipeLeftInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    var isInteracting: Bool = false
    
    var presentingVC: UIViewController? {
        didSet {
            presentingVC?.view.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(handlerPanGesture(gestureRecognizer:))))
            presentingVCCenter = presentingVC?.view.center ?? CGPoint(x: ScreenWidth/2, y: ScreenHeight/2)
        }
    }
    
    var presentingVCCenter: CGPoint = .zero
    
    override var completionSpeed: CGFloat {
        get { return 1 - self.percentComplete }
        set { }
    }
    
    @objc func handlerPanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view?.superview)
        print("translation: \(translation)")
        if !isInteracting && (translation.x < 0 || translation.y < 0 || translation.x < translation.y) {
            return
        }
        switch gestureRecognizer.state {
        case .began:
            isInteracting = true
        case .changed:
            var progress: CGFloat = translation.x / ScreenWidth
            progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
            let ratio: CGFloat = 1.0 - (progress * 0.5)
            presentingVC?.view.center = CGPoint(x: presentingVCCenter.x + translation.x * ratio, y: presentingVCCenter.y + translation.y * ratio)
            presentingVC?.view.transform = CGAffineTransform(scaleX: ratio, y: ratio)
            update(progress)
        case .cancelled, .ended:
            var progress:CGFloat = translation.x / ScreenWidth
            progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
            if progress < 0.3 {
                UIView.animate(withDuration: TimeInterval(progress), delay: 0.0, options: .curveEaseOut, animations: {
                    self.presentingVC?.view.center = CGPoint.init(x: ScreenWidth / 2, y: ScreenHeight / 2)
                    self.presentingVC?.view.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                }) { finished in
                    self.isInteracting = false
                    self.cancel()
                }
            } else {
                isInteracting = false
                finish()
                presentingVC?.dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
}

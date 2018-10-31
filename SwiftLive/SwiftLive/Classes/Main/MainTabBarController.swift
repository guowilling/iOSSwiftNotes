
import UIKit

class MainTabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildVC("Home")
        addChildVC("Rank")
        addChildVC("Discover")
        addChildVC("Profile")
    }
    
    fileprivate func addChildVC(_ storyboardName : String) {
        let childVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController()!
        addChildViewController(childVC)
    }
}

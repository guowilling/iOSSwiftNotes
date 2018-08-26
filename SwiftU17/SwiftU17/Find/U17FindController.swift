
import UIKit
import SwipeMenuViewController

class U17FindController: SwipeMenuViewController {
    
    var options = SwipeMenuViewOptions()
    
    var dataSource: [String] = ["推荐", "VIP", "订阅", "排行"]
    
    var vcs: [UIViewController] = [U17RecommendController(),
                                   U17VIPController(),
                                   U17SubscribeController(),
                                   U17RankController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBarBackgroundAlpha = 0
        
        self.view.backgroundColor = U17ThemeColor
        
        for vc in vcs {
            self.addChildViewController(vc)
        }
        
        self.options.tabView.style = .segmented
        self.options.tabView.itemView.textColor = UIColor.init(red: 210/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1)
        self.options.tabView.itemView.selectedTextColor = UIColor.white
        self.options.tabView.itemView.width = 60.0
        self.options.tabView.margin = 70.0
        self.options.tabView.itemView.font = UIFont.systemFont(ofSize: 20)
        self.options.tabView.addition = .none
        self.swipeMenuView.reloadData(options: options)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK - SwipeMenuViewDataSource
    override func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        return dataSource.count
    }
    
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        return dataSource[index]
    }
    
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
        return vcs[index]
    }
    
    // MARK: - SwipeMenuViewDelegate
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewWillSetupAt currentIndex: Int) {
        super.swipeMenuView(swipeMenuView, viewWillSetupAt: currentIndex)
        print("swipeMenuView viewWillSetupAt currentIndex\(currentIndex)")
    }
    
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewDidSetupAt currentIndex: Int) {
        super.swipeMenuView(swipeMenuView, viewDidSetupAt: currentIndex)
        print("swipeMenuView viewDidSetupAt currentIndex\(currentIndex)")
    }
    
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, willChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        super.swipeMenuView(swipeMenuView, willChangeIndexFrom: fromIndex, to: toIndex)
        print("swipeMenuView willChangeIndexFrom \(fromIndex) to \(toIndex)")
    }
    
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, didChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        super.swipeMenuView(swipeMenuView, didChangeIndexFrom: fromIndex, to: toIndex)
        print("swipeMenuView didChangeIndexFrom \(fromIndex) to \(toIndex)")
    }
}

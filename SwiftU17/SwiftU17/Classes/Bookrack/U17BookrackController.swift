
import UIKit
import SwipeMenuViewController

class U17BookrackController: UIViewController {

    private var dataSource: [String] = ["收藏", "书单", "历史", "下载"]
    
    private var vcs: [UIViewController] = [UIViewController(),
                                           UIViewController(),
                                           UIViewController(),
                                           UIViewController()]
    
    lazy var options: SwipeMenuViewOptions = {
        var options = SwipeMenuViewOptions()
        options.tabView.style = .segmented
        options.tabView.itemView.textColor = UIColor.black
        options.tabView.itemView.selectedTextColor = U17ThemeColor
        options.tabView.backgroundColor = UIColor.white
        options.tabView.itemView.width = 60.0
        options.tabView.margin = 20.0
        options.tabView.itemView.font = UIFont.systemFont(ofSize: 15)
        options.tabView.additionView.underline.height = 3.0
        options.tabView.additionView.backgroundColor = U17ThemeColor
        return options
    }()
    
    lazy var swipeMenuView: SwipeMenuView = {
        let swipeMenuView = SwipeMenuView.init(frame: CGRect(x: 0, y: 64, width:  ScreenWidth, height: ScreenHeigth-64), options:self.options)
        swipeMenuView.dataSource = self
        swipeMenuView.delegate = self
        return swipeMenuView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.swipeMenuView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension U17BookrackController: SwipeMenuViewDelegate {
    
}

extension U17BookrackController: SwipeMenuViewDataSource {
    
    func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        return dataSource.count
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        return dataSource[index]
    }
    
    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
        let vc = vcs[index]
        return vc
    }
}

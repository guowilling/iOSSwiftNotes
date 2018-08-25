
import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        
        setupNavigationBar()
        
        setupContentView()
    }
    
    private func setupNavigationBar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        searchBar.placeholder = "主播昵称/房间号"
        searchBar.searchBarStyle = .minimal
        let searchFiled = searchBar.value(forKey: "_searchField") as? UITextField
        searchFiled?.textColor = UIColor.white
        navigationItem.titleView = searchBar
        
//        let collectImage = UIImage(named: "home_item_follow")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: collectImage, style: .plain, target: self, action: #selector(collectItemAction))
    }
    
    private func setupContentView() {
        let types = loadAnchorTypes()
        
        let frame = CGRect(x: 0, y: kNavigationBarH + kStatusBarH, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH - kTabBarH)
        let titles = types.map({ $0.title })
        let style = SRChannelsTitleStyle()
        style.isScrollEnabled = true
        var childVCs = [HomeAnchorViewController]()
        for type in types {
            let anchorVC = HomeAnchorViewController()
            anchorVC.anchorType = type
            childVCs.append(anchorVC)
        }
        let channelsControl = SRChannelsControl(frame: frame, titles: titles, titleStyle: style, childVCs: childVCs, parentVC: self)
        view.addSubview(channelsControl)
    }
    
    private func loadAnchorTypes() -> [AnchorType] {
        let path = Bundle.main.path(forResource: "types.plist", ofType: nil)!
        let typeDics = NSArray(contentsOfFile: path) as! [[String: Any]]
        var typeModels = [AnchorType]()
        for dict in typeDics {
            typeModels.append(AnchorType(dict: dict))
        }
        return typeModels
    }
}

// MARK: - Actions
//extension HomeViewController {
//
//    @objc fileprivate func collectItemAction() {
//        let focusVC = FocusViewController()
//        navigationController?.pushViewController(focusVC, animated: true)
//    }
//}

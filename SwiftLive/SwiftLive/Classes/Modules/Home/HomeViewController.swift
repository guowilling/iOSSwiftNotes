
import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        
        setupNavigationBar()
    
        setupContentView()
    }
    
    private func setupNavigationBar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        searchBar.placeholder = "主播昵称/房间号"
        searchBar.searchBarStyle = .minimal
        let searchFiled = searchBar.value(forKey: "_searchField") as? UITextField
        searchFiled?.textColor = UIColor.black
        navigationItem.titleView = searchBar
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        
        let followImage = UIImage(named: "home_item_follow")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: followImage, style: .plain, target: self, action: #selector(followItemAction))
    }
    
    private func setupContentView() {
        let frame = CGRect(x: 0,
                           y: STATUS_BAR_H + NAVIGATION_BAR_H,
                           width: SCREEN_WIDTH,
                           height: SCREEN_HEIGHT - STATUS_BAR_H - NAVIGATION_BAR_H - TABBAR_BAR_H)
       
        let anchorTypes = loadAnchorTypes()
        let titles = anchorTypes.map({ $0.title })
       
        var childVCs = [HomeAnchorViewController]()
        for anchorType in anchorTypes {
            let anchorVC = HomeAnchorViewController()
            anchorVC.anchorType = anchorType
            childVCs.append(anchorVC)
        }
        
        let style = SRChannelsTitleStyle()
        style.isScrollEnabled = true
        
        let channelsControl = SRChannelsControl(frame: frame, titles: titles, titleStyle: style, childVCs: childVCs, parentVC: self)
        view.addSubview(channelsControl)
    }
}

// MARK: - Actions
extension HomeViewController {
    @objc fileprivate func followItemAction() {
//        let focusVC = FocusViewController()
//        navigationController?.pushViewController(focusVC, animated: true)
    }
    
    fileprivate func loadAnchorTypes() -> [AnchorType] {
        let filePath = Bundle.main.path(forResource: "AnchorTypes.plist", ofType: nil)!
        let dicts = NSArray(contentsOfFile: filePath) as! [[String: Any]]
        var models = [AnchorType]()
        for dict in dicts {
            models.append(AnchorType(dict: dict))
        }
        return models
    }
}

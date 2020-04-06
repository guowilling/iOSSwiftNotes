
import UIKit

class WBBaseViewController: UIViewController {
    
    var visitorInfoDictionary: [String: String]?
    var isPullup = false
    
    var tableView: UITableView?
    
    var refreshControl: RefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        WBNetworkManager.shared.userLogon ? loadData() : ()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loginSuccessed),
                                               name: NSNotification.Name(rawValue: WBUserLoginSuccessedNotification),
                                               object: nil)
    }
    
    @objc func loadData() {
        refreshControl?.endRefreshing()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Setup UI
extension WBBaseViewController {
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        
        automaticallyAdjustsScrollViewInsets = false // 取消自动缩进, 因为隐藏了导航栏, 不设置 view 会自动缩进 20 个点
        
        WBNetworkManager.shared.userLogon ? setupTableView() : setupVisitorView()
    }
    
    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        self.view.addSubview(tableView!)
        
        refreshControl = RefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView?.addSubview(refreshControl!)
    }
    
    private func setupVisitorView() {
        let visitorView = WBVisitorView(frame: view.bounds)
        visitorView.visitorInfo = visitorInfoDictionary
        visitorView.loginButton.addTarget(self,
                                          action: #selector(login),
                                          for: .touchUpInside)
        visitorView.registerButton.addTarget(self,
                                             action: #selector(register),
                                             for: .touchUpInside)
        self.view.addSubview(visitorView)
    }
}

// MARK: - Monitor Methods
extension WBBaseViewController {
    
    @objc fileprivate func loginSuccessed(notification: Notification) {
        print("登录成功 \(notification)")
        
        // 更新 UI, 访问 view 的 getter 时, 如果 view == nil 会调用 loadView -> viewDidLoad.
        view = nil
        
        // 这里需要注销通知, 因为重新执行 viewDidLoad 会再次注册通知
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func login() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserLoginNeededNotification), object: nil)
    }
    
    @objc fileprivate func register() {
        print("注册用户")
    }
}

// MARK: - UITableViewDataSource && UITableViewDelegate
extension WBBaseViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = tableView.numberOfSections - 1
        if row < 0 || section < 0 {
            return
        }
        let count = tableView.numberOfRows(inSection: section)
        if row == (count - 1) && !isPullup {
            isPullup = true
            loadData()
        }
    }
}

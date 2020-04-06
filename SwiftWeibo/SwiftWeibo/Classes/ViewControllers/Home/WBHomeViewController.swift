
import UIKit

private let originalCellId  = "originalCellId"
private let retweetedCellId = "retweetedCellId"

class WBHomeViewController: WBBaseViewController {
    
    fileprivate lazy var listViewModel = WBStatusListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //refreshControl?.beginRefreshing()
    }
    
    override func loadData() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.listViewModel.loadStatus(pullup: self.isPullup) { (isSuccess, shouldRefresh) in
                self.refreshControl?.endRefreshing()
                self.isPullup = false
                if shouldRefresh {
                    self.tableView?.reloadData()
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Setup UI
extension WBHomeViewController {
    
//    func setupTableView() {
//        super.setupTableView()
//        
//        tableView?.register(UINib(nibName: "WBStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalCellId)
//        tableView?.register(UINib(nibName: "WBStatusRetweetedCell", bundle: nil), forCellReuseIdentifier: retweetedCellId)
//        
//        //tableView?.rowHeight = UITableViewAutomaticDimension // 取消自动行高
//        tableView?.estimatedRowHeight = 300
//        tableView?.separatorStyle = .none
//    }
}

// MARK: - UITableViewDataSource && UITableViewDelegate
extension WBHomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let statusVM = listViewModel.statusList[indexPath.row]
        let cellId = (statusVM.status.retweeted_status != nil) ? retweetedCellId : originalCellId
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WBStatusCell
        cell.viewModel = statusVM
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let statusVM = listViewModel.statusList[indexPath.row]
        return statusVM.rowHeight
    }
}

// MARK: - WBStatusCellDelegate
extension WBHomeViewController: WBStatusCellDelegate {
    
    func statusCellDidSelectedURLString(cell: WBStatusCell, urlString: String) {
        let webVC = WBWebViewController()
        webVC.urlString = urlString
        navigationController?.pushViewController(webVC, animated: true)
    }
}

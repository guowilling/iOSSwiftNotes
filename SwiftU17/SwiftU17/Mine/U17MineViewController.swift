
import UIKit

class U17MineViewController: UIViewController {
    
    private let U17MineCellIdentifier = "U17MineCell"
    private let U17MineHeaderViewIdentifier = "U17MineHeaderView"
    
    lazy var tableview: UITableView = {
       let tabView = UITableView.init(frame: self.view.bounds, style: UITableViewStyle.grouped)
        tabView.frame.size.height -= 49;
        tabView.delegate = self
        tabView.dataSource = self
        tabView.register(U17MineCell.self, forCellReuseIdentifier: U17MineCellIdentifier)
        tabView.register(U17MineHeaderView.self, forHeaderFooterViewReuseIdentifier: U17MineHeaderViewIdentifier)
        if #available(iOS 11.0, *) {
            tabView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false;
        }
        return tabView
    }()
    
    private lazy var dataSource: Array = {
        return [
            [
                ["icon": "mine_accout", "title": "消费记录"],
                ["icon": "mine_seal", "title": "我的封印图"]
            ],
            
            [
                ["icon": "mine_message", "title": "我的消息/优惠券"],
                ["icon": "mine_freed", "title": "在线阅读免流量"]
            ],
            
            [
                ["icon": "mine_feedBack", "title": "帮助中心"],
                ["icon": "mine_mail", "title": "我要反馈"],
                ["icon": "mine_judge", "title": "给我们评分"],
                ["icon": "mine_author", "title": "成为作者"],
                ["icon": "mine_setting", "title": "退出有妖气"]
            ]
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBarBackgroundAlpha = 0
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.tableview)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension U17MineViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: U17MineCell = tableview.dequeueReusableCell(withIdentifier: U17MineCellIdentifier, for: indexPath) as! U17MineCell
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .default
        let sectionArray = dataSource[indexPath.section]
        let dict: [String: String] = sectionArray[indexPath.row]
        cell.imageView?.image =  UIImage(named: dict["icon"] ?? "")
        cell.textLabel?.text = dict["title"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: U17MineHeaderView = tableview.dequeueReusableHeaderFooterView(withIdentifier: U17MineHeaderViewIdentifier) as! U17MineHeaderView
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 280
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

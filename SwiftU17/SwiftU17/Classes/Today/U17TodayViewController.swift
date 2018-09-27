
import UIKit

class U17TodayViewController: UIViewController {
    
    private let CellIdentifier = "U17TodayCell"
    private let FooterIdentifier = "U17TodayFooterView"
    private let HeaderIdentifier = "U17TodayHeaderView"
    
    private var dayDataList = [DayItemDataListModel]()

    lazy var statusView: UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 20))
        view.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        return view
    }()

    lazy var tableView: UITableView = {
        let tabView = UITableView.init(frame: CGRect(x:0, y:20, width: ScreenWidth, height: ScreenHeigth-20), style: UITableViewStyle.grouped)
        tabView.delegate = self
        tabView.dataSource = self
        tabView.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        tabView.register(U17TodayCell.self, forCellReuseIdentifier: CellIdentifier)
        tabView.register(U17TodayFooterView.self, forHeaderFooterViewReuseIdentifier: FooterIdentifier)
        tabView.register(U17TodayHeaderView.self, forHeaderFooterViewReuseIdentifier: HeaderIdentifier)
        tabView.separatorStyle = UITableViewCellSeparatorStyle.none
        return tabView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBarBackgroundAlpha = 0
        
        self.view.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        
        self.view.addSubview(self.statusView)
        
        self.view.addSubview(self.tableView)
        
        loadData()
    }
    
    func loadData(){
        APILoadingProvider.request(U17API.todayList, model: DayDataModel.self) { [weak self] (returnData) in
            self?.dayDataList = returnData?.dayDataList ?? []
            self?.tableView.reloadData()
        }
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

extension U17TodayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dayDataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.dayDataList[section].dayItemDataList?.count)!-1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:U17TodayCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! U17TodayCell
        cell.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.model = self.dayDataList[indexPath.section].dayItemDataList?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:U17TodayHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderIdentifier) as! U17TodayHeaderView
        headerView.dayDataModel = self.dayDataList[section]
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 600
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView:U17TodayFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FooterIdentifier) as! U17TodayFooterView
        let dayItem:DayItemModel = (self.dayDataList[section].dayItemDataList?.last)!
        footView.dayItemModel = dayItem
        footView.delegate =  self
        return footView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let item = self.dayDataList[indexPath.section].dayItemDataList?[indexPath.row]
        print(item!)
    }
}

extension U17TodayViewController: U17TodayFooterViewDelegate {
    func readCartoon(dayComicItemModel: dayComicItemModel?) {
        guard let item = dayComicItemModel else {
            return
        }
        print(item)
    }
}

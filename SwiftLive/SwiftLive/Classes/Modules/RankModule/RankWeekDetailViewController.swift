
import UIKit

private let kRankWeekCellID = "kRankWeekCellID"

class RankWeekDetailViewController: RankDateDetailViewController {

    fileprivate lazy var rankVM: RankViewModel = RankViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets.zero
        tableView.register(UINib(nibName: "RankWeekCell", bundle: nil), forCellReuseIdentifier: kRankWeekCellID)
    }
    
    override init(rankType: RankType) {
        super.init(rankType: rankType)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RankWeekDetailViewController {
    
    override func loadRankData() {
        rankVM.loadRankWeekData(rankType) {
            self.tableView.reloadData()
        }
    }
}

extension RankWeekDetailViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return rankVM.weekModels.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankVM.weekModels[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kRankWeekCellID, for: indexPath) as! RankWeekCell
        cell.weekModel = rankVM.weekModels[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "主播周星榜" : "富豪周星榜"
    }
}

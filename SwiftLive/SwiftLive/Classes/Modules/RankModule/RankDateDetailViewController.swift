
import UIKit

let kRankDateCellID = "kRankDateCellID"

class RankDateDetailViewController: UIViewController {

    var rankType: RankType
    
    lazy var tableView: UITableView = UITableView()
    
    fileprivate lazy var rankVM: RankViewModel = RankViewModel()
    
    init(rankType: RankType) {
        self.rankType = rankType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        loadRankData()
    }
}

extension RankDateDetailViewController {
    
    fileprivate func setupUI() {
        tableView.frame = view.bounds
        tableView.backgroundColor = UIColor(R: 245, G: 245, B: 245)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 50
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        tableView.register(UINib(nibName: "RankDateCell", bundle: nil), forCellReuseIdentifier: kRankDateCellID)
        view.addSubview(tableView)
    }
}

extension RankDateDetailViewController {
    
    func loadRankData() {
        rankVM.loadRankDateData(rankType, {
            self.tableView.reloadData()
        })
    }
}

extension RankDateDetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankVM.dateModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kRankDateCellID, for: indexPath) as! RankDateCell
        cell.rankNum = indexPath.row
        cell.rankDateModel = rankVM.dateModels[indexPath.row]
        return cell
    }
}

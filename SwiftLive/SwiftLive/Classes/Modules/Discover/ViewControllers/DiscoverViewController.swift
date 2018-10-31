
import UIKit

class DiscoverViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate lazy var discoverVM: DiscoverViewModel = DiscoverViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupHeaderCarouselView()
        
        setupFooterView()
        
        tableView.rowHeight = ScreenW * 1.5
    }
}

extension DiscoverViewController {
    
    fileprivate func setupHeaderCarouselView() {
        discoverVM.loadCarouselData {
            var picUrls = [NSString]()
            for carouselModel in self.discoverVM.carouselModels {
                picUrls.append(carouselModel.picUrl as NSString)
            }
            let carsouselView = SRCarouselView.sr_carouselView(withImageArrary: picUrls, describe: [], placeholderImage: nil, block: { (index) in
                print(index)
            })
            let carouseViewH = ScreenW * 0.5
            carsouselView?.frame = CGRect(x: 0, y: -carouseViewH, width: ScreenW, height: carouseViewH)
            self.tableView.tableHeaderView = carsouselView
        }
    }
    
    fileprivate func setupFooterView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: 80))
        let btn = UIButton(frame: CGRect.zero)
        btn.frame.size = CGSize(width: ScreenW * 0.5, height: 40)
        btn.center = CGPoint(x: ScreenW * 0.5, y: 40)
        btn.setTitle("换一换", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.orange.cgColor
        btn.layer.borderWidth = 0.5
        btn.addTarget(self, action: #selector(switchGuessAnchor), for: .touchUpInside)
        footerView.addSubview(btn)
        footerView.backgroundColor = UIColor(R: 250, G: 250, B: 250)
        tableView.tableFooterView = footerView
    }
    
    @objc private func switchGuessAnchor() {
        let cell = tableView.visibleCells.first as? DiscoverTableViewCell
        cell?.reloadData()
        let offset = CGPoint(x: 0, y: ScreenW * 0.5 - 64)
        tableView.setContentOffset(offset, animated: true)
    }
}

extension DiscoverViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverTableViewCellID", for: indexPath) as! DiscoverTableViewCell
        cell.didSelectItem = { (anchor: AnchorModel) in
            let lrVC = LiveRoomViewController()
            lrVC.anchorModel = anchor
            self.navigationController?.pushViewController(lrVC, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenW, height: 40))
        let headerLabel = UILabel(frame: headerView.bounds)
        headerLabel.text = "猜你喜欢"
        headerLabel.textAlignment = .center
        headerLabel.textColor = UIColor.orange
        headerView.addSubview(headerLabel)
        headerView.backgroundColor = UIColor.white
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

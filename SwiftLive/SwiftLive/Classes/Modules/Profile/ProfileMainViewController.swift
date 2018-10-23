
import UIKit

class ProfileMainViewController: ProfileBaseViewController {

    fileprivate lazy var profileHeader: ProfileHeaderView = ProfileHeaderView.loadFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension ProfileMainViewController {
    
    override func setupUI() {
        super.setupUI()
        
        profileHeader.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 200)
        mainTableView.tableHeaderView = profileHeader
    }
    
    override func setupItemData() {
        let section0Model = ProfileItemSectionModel()
        section0Model.sectionHeaderHeight = 0.1
        
        let section0Item0 = ProfileItemModel(icon: "mine_follow", content: "我的关注")
        section0Model.items.append(section0Item0)
        let section0Item1 = ProfileItemModel(icon: "mine_money", content: "我的帆币")
        section0Model.items.append(section0Item1)
        let section0Item2 = ProfileItemModel(icon: "mine_fanbao", content: "我的帆宝")
        section0Model.items.append(section0Item2)
        let section0Item3 = ProfileItemModel(icon: "mine_money", content: "我的背包")
        section0Item3.accessoryType = .arrowHint
        section0Item3.hintText = "查看礼物"
        section0Model.items.append(section0Item3)
        let section0Item4 = ProfileItemModel(icon: "mine_money", content: "现金红包")
        section0Model.items.append(section0Item4)
        sections.append(section0Model)
        
        let section1Model = ProfileItemSectionModel()
        section1Model.sectionHeaderHeight = 10
        let section1Mode0 = ProfileItemModel(icon: "mine_edit", content: "编辑资料")
        section1Model.items.append(section1Mode0)
        let section1Mode1 = ProfileItemModel(icon: "mine_set", content: "设置")
        section1Model.items.append(section1Mode1)
        sections.append(section1Model)
        
        mainTableView.reloadData()
    }
}

extension ProfileMainViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        if indexPath.section == 1 && indexPath.item == 1 {
            let settingsVc = ProfileSettingsViewController()
            navigationController?.pushViewController(settingsVc, animated: true)
        }
    }
}

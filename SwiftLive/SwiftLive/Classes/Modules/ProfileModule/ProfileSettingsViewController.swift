
import UIKit

class ProfileSettingsViewController: ProfileBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileSettingsViewController {
    
    override func setupItemData() {
        let section0Model = ProfileItemSectionModel()
        section0Model.sectionHeaderHeight = 5
        let section0Item0 = ProfileItemModel(content: "开播提醒")
        section0Item0.accessoryType = .onswitch
        section0Model.items.append(section0Item0)
        let section0Item1 = ProfileItemModel(content: "移动流量提醒")
        section0Item1.accessoryType = .onswitch
        section0Model.items.append(section0Item1)
        let section0Item2 = ProfileItemModel(content: "网络环境优化")
        section0Item2.accessoryType = .onswitch
        section0Model.items.append(section0Item2)
        sections.append(section0Model)
        
        let section1Model = ProfileItemSectionModel()
        section1Model.sectionHeaderHeight = 5
        let section1Item0 = ProfileItemModel(content: "绑定手机", hint : "未绑定")
        section1Item0.accessoryType = .arrowHint
        section1Model.items.append(section1Item0)
        let section1Item1 = ProfileItemModel(content: "意见反馈")
        section1Model.items.append(section1Item1)
        let section1Item2 = ProfileItemModel(content: "直播公约")
        section1Model.items.append(section1Item2)
        let section1Item3 = ProfileItemModel(content: "关于我们")
        section1Model.items.append(section1Item3)
        let section1Item4 = ProfileItemModel(content: "我要好评")
        section1Model.items.append(section1Item4)
        sections.append(section1Model)
        
        tableView.reloadData()
    }
}

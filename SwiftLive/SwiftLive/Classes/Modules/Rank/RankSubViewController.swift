
import UIKit

class RankSubViewController: UIViewController {

    fileprivate var typeName: String = ""
    
    var currentIndex: Int = 0 {
        didSet {
            switch currentIndex {
            case 0:
                typeName = "rankStar"
            case 1:
                typeName = "rankWealth"
            case 2:
                typeName = "rankPopularity"
            case 3:
                typeName = "rankAll"
            default:
                print("Error Type!")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupUI(_ titles: [String]) {
        let frame = CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH - StatusBarH - NavigationBarH - TabBarH)
        let titles = titles
        let style = SRChannelsTitleStyle()
        style.titleNormalColor = UIColor(sr_colorWithR: 0, G: 0, B: 0)
        style.titleHeight = 35
        var childVCs = [UIViewController]()
        for i in 0..<titles.count {
            let rankType = RankType(typeName: typeName, typeNum: i + 1)
            var vc: UIViewController = RankDateDetailViewController(rankType: rankType)
            if currentIndex == 3 {
                vc = RankWeekDetailViewController(rankType : rankType)
            }
            childVCs.append(vc)
        }
        let channelsControl = SRChannelsControl(frame: frame, titles: titles, titleStyle: style, childVCs: childVCs, parentVC: self)
        view.addSubview(channelsControl)
    }
}


import UIKit

class RankViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = CGRect(x: 0, y: StatusBarH, width: ScreenW, height: ScreenH - StatusBarH)
        let titles = ["明星榜", "富豪榜", "人气榜", "周星榜"]
        let style = SRChannelsTitleStyle()
        style.isBottomLineDisplayed = true
        var childVCs = [UIViewController]()
        for i in 0..<titles.count {
            let vc: RankSubViewController = i == 3 ? RankWeekViewController() : RankDateViewController()
            vc.currentIndex = i
            childVCs.append(vc)
        }
        let channelsControl = SRChannelsControl(frame: frame, titles: titles, titleStyle: style, childVCs: childVCs, parentVC: self)
        view.addSubview(channelsControl)
    }
}

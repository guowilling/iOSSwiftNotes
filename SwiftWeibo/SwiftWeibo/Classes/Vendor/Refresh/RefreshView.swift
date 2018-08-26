
import UIKit

// UIView 封装的旋转动画:
// 1.默认顺时针旋转
// 2.就近原则
// 3.要想实现同方向旋转, 需要调整一个非常小的数字
// 4.如果想实现360旋转, 需要使用核心动画 CABaseAnimation

/// 刷新视图: 负责刷新相关的 UI 显示和动画
class RefreshView: UIView {

    /// 刷新状态
    var refreshState: CZRefreshState = .Normal {
        didSet {
            switch refreshState {
            case .Normal:
                tipIcon?.isHidden = false
                indicator?.stopAnimating()
                tipLabel?.text = "继续使劲拉..."
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon?.transform = CGAffineTransform.identity
                }
            case .Pulling:
                tipLabel?.text = "放手就刷新..."
                UIView.animate(withDuration: 0.25) {
                    self.tipIcon?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi + 0.001))
                }
            case .Refreshing:
                tipLabel?.text = "正在刷新中..."
                tipIcon?.isHidden = true
                indicator?.startAnimating()
            }
        }
    }
    
    /// 父视图的高度: 为了让刷新控件不需要关心当前具体的刷新视图是谁.
    var parentViewHeight: CGFloat = 0
    
    /// 指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView?
    
    /// 提示图标
    @IBOutlet weak var tipIcon: UIImageView?
    
    /// 提示标签
    @IBOutlet weak var tipLabel: UILabel?

    class func refreshView() -> RefreshView {
        let nib = UINib(nibName: "RefreshView", bundle: nil)
        //let nib = UINib(nibName: "CZMeituanRefreshView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! RefreshView
    }
}

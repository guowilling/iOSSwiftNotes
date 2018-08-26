
import UIKit

private let RefreshOffsetY: CGFloat = 120

enum CZRefreshState {
    case Normal
    case Pulling
    case Refreshing
}

class RefreshControl: UIControl {
    
    /// 刷新控件的父视图, 下拉刷新控件适用于 UITableView / UICollectionView.
    private weak var scrollView: UIScrollView?
    
    /// 刷新视图
    fileprivate lazy var refreshView: RefreshView = RefreshView.refreshView()
    
    // MARK: - 构造函数
    init() {
        super.init(frame: CGRect())
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }

    // 当添加到父视图的时候, newSuperview 是父视图.
    // 当从父视图移除的时候, newSuperview 是 nil.
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let aSuperview = newSuperview as? UIScrollView else {
            return
        }
        scrollView = aSuperview
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    // 基本所有的下拉刷新框架都是监听父视图的 contentOffset.
    override func removeFromSuperview() {
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
    }
    
    // 观察者模式, 不再需要的时候, 都应该释放.
    // 通知中心: 如果不释放什么也不会发生, 但是会有内存泄漏, 会有多次注册的可能.
    // KVO: 如果不释放, 会崩溃.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //print(scrollView?.contentOffset)
        guard let scrollView = scrollView else {
            return
        }
        let height = -(scrollView.contentInset.top + scrollView.contentOffset.y)
        if height < 0 {
            return
        }
        //print(height)
        self.frame = CGRect(x: 0, y: -height, width: scrollView.bounds.width, height: height)
        
        if refreshView.refreshState != .Refreshing {
            refreshView.parentViewHeight = height
        }
        
        if scrollView.isDragging {
            if height > RefreshOffsetY && (refreshView.refreshState == .Normal) {
                refreshView.refreshState = .Pulling
            } else if height <= RefreshOffsetY && (refreshView.refreshState == .Pulling) {
                refreshView.refreshState = .Normal
            }
        } else {
            if refreshView.refreshState == .Pulling {
                beginRefreshing()
                sendActions(for: .valueChanged) // 发送开始刷新事件
            }
        }
    }
    
    /// 开始刷新
    func beginRefreshing() {
        guard let scrollView = scrollView else {
            return
        }
        if refreshView.refreshState == .Refreshing {
            return
        }
        refreshView.refreshState = .Refreshing
        refreshView.parentViewHeight = RefreshOffsetY
        
        var inset = scrollView.contentInset
        inset.top += RefreshOffsetY
        scrollView.contentInset = inset
    }
    
    /// 结束刷新
    func endRefreshing() {
        guard let scrollView = scrollView else {
            return
        }
        if refreshView.refreshState != .Refreshing {
            return
        }
        refreshView.refreshState = .Normal
        refreshView.parentViewHeight = 0
        
        var inset = scrollView.contentInset
        inset.top -= RefreshOffsetY
        scrollView.contentInset = inset
    }
}

extension RefreshControl {
    
    fileprivate func setupUI() {
        backgroundColor = superview?.backgroundColor
        
        addSubview(refreshView)
        
        // xib 加载的视图, 默认就是 xib 中指定的宽高
        // 自动布局设置 xib 控件的布局, 需要指定宽高约束
        // 一定要会原生的写法, 因为如果自己开发框架, 不能用任何三方的自动布局框架
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1.0,
                                         constant: 0))
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.width))
        
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshView.bounds.height))
    }
}

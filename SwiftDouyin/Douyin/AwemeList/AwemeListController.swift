
import Foundation

enum AwemeType {
    case AwemePost
    case AwemeFavorite
}

class AwemeListController: BaseViewController {
    
    let AWEME_CELL_ID: String = "AWEME_CELL_ID"
    
    @objc dynamic var currentIndex: Int = 0
    
    var tableView: UITableView?
    var loadMoreControl: LoadMoreControl?
    
    var isCurrentPlayerPaused: Bool = false
    
    var pageIndex: Int = 0
    var pageSize: Int = 21
    
    var awemeType: AwemeType?
    
    var uid: String?
    
    var awemes = [Aweme]()
    var awemesSource = [Aweme]()
    
    init(awemes: [Aweme], currentIndex: Int, page: Int, size: Int, awemeType: AwemeType, uid: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.currentIndex = currentIndex
        self.pageIndex = page
        self.pageSize = size
        self.awemeType = awemeType
        self.uid = uid
        
        self.awemes = awemes
        self.awemesSource.append(awemes[currentIndex])
        
        NotificationCenter.default.addObserver(self, selector: #selector(didTouchStatusBar), name: NSNotification.Name(rawValue: "DidTouchStatusBarNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationwillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let background = UIImageView.init(frame: ScreenFrame)
        background.image = UIImage.init(named: "img_video_loading")
        background.contentMode = .scaleAspectFill
        background.clipsToBounds = true
        self.view.addSubview(background)
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: -ScreenHeight, width: ScreenWidth, height: ScreenHeight * 5))
        tableView?.contentInset = UIEdgeInsets(top: ScreenHeight, left: 0, bottom: ScreenHeight * 3, right: 0);
        tableView?.backgroundColor = ColorClear
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView?.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView?.register(AwemeListCell.classForCoder(), forCellReuseIdentifier: AWEME_CELL_ID)
        
        loadMoreControl = LoadMoreControl.init(frame: CGRect.init(x: 0, y: 100, width: ScreenWidth, height: 50), surplusCount: 10)
        loadMoreControl?.onLoad = { [weak self] in
            self?.loadData(page: self?.pageIndex ?? 0)
        }
        tableView?.addSubview(loadMoreControl!)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.view.addSubview(self.tableView!)
            self.awemesSource = self.awemes
            self.tableView?.reloadData()
            self.tableView?.scrollToRow(at: IndexPath.init(row: self.currentIndex, section: 0), at: UITableView.ScrollPosition.middle, animated: false)
            self.addObserver(self, forKeyPath: "currentIndex", options: [.initial, .new], context: nil)
            
            let dismissButton = UIButton.init(type: .custom);
            dismissButton.frame = CGRect.init(x: 5, y: StatusBarHeight + 5, width: 44.0, height: 44.0)
            dismissButton.setImage(UIImage.init(named: "icon_titlebar_whiteback"), for: .normal)
            dismissButton.addTarget(self, action: #selector(self.dismissButtonAction), for: .touchUpInside);
            self.view.addSubview(dismissButton)
            self.view.bringSubviewToFront(dismissButton)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tableView?.layer.removeAllAnimations()
        let cells = tableView?.visibleCells as! [AwemeListCell]
        for cell in cells {
            cell.playerView.cancelLoading()
        }
        
        NotificationCenter.default.removeObserver(self)
        self.removeObserver(self, forKeyPath: "currentIndex")
    }
}

extension AwemeListController {
    func loadData(page: Int, _ size: Int = 21) {
        if awemeType == AwemeType.AwemePost {
            AwemeListRequest.getPostAwemes(uid: uid ?? "", page: page, size, success: { [weak self] data in
                guard let self = self else { return }
                if let response = data as? AwemeListResponse {
                    self.pageIndex += 1
                    let awemes = response.data
                    
                    self.tableView?.beginUpdates()
                    self.awemesSource += awemes
                    var indexPaths = [IndexPath]()
                    for row in (self.awemesSource.count - awemes.count)..<self.awemesSource.count {
                        indexPaths.append(IndexPath.init(row: row, section: 0))
                    }
                    self.tableView?.insertRows(at: indexPaths, with: .none)
                    self.tableView?.endUpdates()
                    
                    self.loadMoreControl?.endLoading()
                    if response.has_more == 0 {
                        self.loadMoreControl?.loadingNoMore()
                    }
                }
                }, failure: { error in
                    self.loadMoreControl?.loadingFailed()
            })
        } else {
            AwemeListRequest.getFavoriteAwemes(uid: uid ?? "", page: page, size, success: { [weak self] data in
                guard let self = self else { return }
                if let response = data as? AwemeListResponse {
                    self.pageIndex += 1
                    let array = response.data
                    
                    self.tableView?.beginUpdates()
                    self.awemesSource += array
                    var indexPaths = [IndexPath]()
                    for row in (self.awemesSource.count - array.count)..<self.awemesSource.count {
                        indexPaths.append(IndexPath.init(row: row, section: 0))
                    }
                    self.tableView?.insertRows(at: indexPaths, with: .none)
                    self.tableView?.endUpdates()
                    
                    self.loadMoreControl?.endLoading()
                    if response.has_more == 0 {
                        self.loadMoreControl?.loadingNoMore()
                    }
                }
                }, failure: { error in
                    self.loadMoreControl?.loadingFailed()
            })
        }
    }
}

extension AwemeListController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return awemesSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenHeight
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AWEME_CELL_ID) as! AwemeListCell
        cell.aweme = awemesSource[indexPath.row]
        return cell
    }
}

extension AwemeListController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DispatchQueue.main.async { // amusing
            let translation = scrollView.panGestureRecognizer.translation(in: scrollView)
            scrollView.panGestureRecognizer.isEnabled = false
            
            if translation.y < -100 && self.currentIndex < (self.awemesSource.count - 1) {
                self.currentIndex += 1
            }
            if translation.y > 100 && self.currentIndex > 0 {
                self.currentIndex -= 1
            }
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
                self.tableView?.scrollToRow(at: IndexPath.init(row: self.currentIndex, section: 0), at: UITableView.ScrollPosition.top, animated: false)
            }, completion: { finished in
                scrollView.panGestureRecognizer.isEnabled = true
            })
        }
    }
}

extension AwemeListController {
    
    @objc func dismissButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentIndex" {
            isCurrentPlayerPaused = false
            guard let cell = tableView?.cellForRow(at: IndexPath.init(row: currentIndex, section: 0)) as? AwemeListCell else {
                return
            }
            if cell.isPlayerReady {
                cell.replay()
            } else {
                AVPlayerManager.shared().pauseAll()
                cell.readyToPlayClosure = { [weak self] in
                    guard let self = self else { return }
                    if let indexPath = self.tableView?.indexPath(for: cell) {
                        if !self.isCurrentPlayerPaused && indexPath.row == self.currentIndex {
                            cell.play()
                        }
                    }
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    @objc func didTouchStatusBar() {
        currentIndex = 0
    }
    
    @objc func applicationwillEnterForeground() {
        if !isCurrentPlayerPaused {
            let cell = tableView?.cellForRow(at: IndexPath.init(row: currentIndex, section: 0)) as! AwemeListCell
            cell.playerView.play()
        }
    }
    
    @objc func applicationDidEnterBackground() {
        let cell = tableView?.cellForRow(at: IndexPath.init(row: currentIndex, section: 0)) as! AwemeListCell
        isCurrentPlayerPaused = cell.playerView.rate() == 0 ? true : false
        cell.playerView.pause()
    }
}

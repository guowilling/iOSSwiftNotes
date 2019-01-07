
import Foundation
import Photos

class UserHomeController: BaseViewController {
    
    let HEADER_ID = "HEADER_ID"
    let FOOTER_ID = "FOOTER_ID"
    let COLLECTION_CELL_ID = "COLLECTION_CELL_ID"
    
    var HEADER_HEIGHT: CGFloat = 340 + StatusBarHeight
    var FOOTER_HEIGHT: CGFloat = 40
    
    var collectionView: UICollectionView?
    var loadMore: LoadMoreControl?
    var selectIndex: Int = 0
    
    let uid: String = "97795069353"
    var user: User?
    
    var postAwemes = [Aweme]()
    var favoriteAwemes = [Aweme]()
    
    var pageIndex = 0
    let pageSize = 21
    
    var tabIndex = 0
    var itemWidth: CGFloat = 0
    var itemHeight: CGFloat = 0
    
    let scalePresentAnimation = ScalePresentAnimation.init()
    let scaleDismissAnimation = ScaleDismissAnimation.init()
    let swipeLeftInteractiveTransition = SwipeLeftInteractiveTransition.init()
    
    var userInfoHeader: UserHomeHeader?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        PHPhotoLibrary.requestAuthorization { (PHAuthorizationStatus) in }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setStatusBarHidden(hidden: false)
        self.setStatusBarStyle(style: .lightContent)
        self.setStatusBarBackgroundColor(color: ColorClear)
        
        self.setNavigationBarTitleColor(color: ColorClear)
        self.setNavigationBarBackgroundColor(color: ColorClear)
        
        self.navigationItem.leftBarButtonItem = nil
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNetworkStatusChange(notification:)), name: Notification.Name(rawValue: NetworkStatusDidChangeNotification), object: nil)
    }
    
    func setupCollectionView() {
        itemWidth = (ScreenWidth - CGFloat(Int(ScreenWidth) % 3)) / 3.0 - 1.0
        itemHeight = itemWidth * 1.5
        
        let layout = HoverViewFlowLayout.init(navHeight: SafeAreaTopHeight)
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 0;
        collectionView = UICollectionView.init(frame: ScreenFrame, collectionViewLayout: layout)
        collectionView?.backgroundColor = ColorClear
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.alwaysBounceVertical = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.register(UserHomeHeader.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HEADER_ID)
        collectionView?.register(UserHomeFooter.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FOOTER_ID)
        collectionView?.register(AwemeCollectionCell.classForCoder(), forCellWithReuseIdentifier: COLLECTION_CELL_ID)
        self.view.addSubview(collectionView!)
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        loadMore = LoadMoreControl.init(frame: CGRect.init(x: 0, y: HEADER_HEIGHT + FOOTER_HEIGHT, width: ScreenWidth, height: 50), surplusCount: 15)
        loadMore?.onLoad = { [weak self] in
            self?.loadAwemesData(page: self?.pageIndex ?? 0)
        }
        collectionView?.addSubview(loadMore!)
        loadMore?.beginLoading()
    }
    
    @objc func onNetworkStatusChange(notification:NSNotification) {
        if HTTPManager.isNetworkReachable(status: HTTPManager.networkStatus()) {
            if user == nil {
                loadUserData()
            }
            if favoriteAwemes.count == 0 && postAwemes.count == 0 {
                loadAwemesData(page: pageIndex)
            }
        }
    }
    
    func loadUserData() {
        UserRequest.findUser(uid: uid, success: { [weak self] data in
            guard let self = self else { return }
            self.user = data as? User
            self.setNavigationBarTitle(title: self.user?.nickname ?? "")
            self.collectionView?.reloadSections(IndexSet.init(integer: 0))
        }, failure: { error in
            UIWindow.showTips(text: error.localizedDescription)
        })
    }
    
    func loadAwemesData(page: Int, _ size: Int = 21) {
        if tabIndex == 0 {
            AwemeListRequest.getPostAwemes(uid: uid, page: page, size, success: { [weak self] data in
                guard let self = self else { return }
                if let response = data as? AwemeListResponse {
                    if self.tabIndex != 0 {
                        return
                    }
                    let array = response.data
                    self.pageIndex += 1
                    
                    UIView.setAnimationsEnabled(false)
                    self.collectionView?.performBatchUpdates({
                        self.postAwemes += array
                        var indexPaths = [IndexPath]()
                        for row in (self.postAwemes.count - array.count)..<self.postAwemes.count {
                            indexPaths.append(IndexPath.init(row: row, section: 1))
                        }
                        self.collectionView?.insertItems(at: indexPaths)
                    }, completion: { finished in
                        UIView.setAnimationsEnabled(true)
                        self.loadMore?.endLoading()
                        if response.has_more == 0 {
                            self.loadMore?.loadingNoMore()
                        }
                    })
                }
            }, failure:{ error in
                self.loadMore?.loadingFailed()
            })
        } else {
            AwemeListRequest.getFavoriteAwemes(uid: uid, page: page, size, success: { [weak self] data in
                guard let self = self else { return }
                if let response = data as? AwemeListResponse {
                    if self.tabIndex != 1 {
                        return
                    }
                    let array = response.data
                    self.pageIndex += 1
                    
                    UIView.setAnimationsEnabled(false)
                    self.collectionView?.performBatchUpdates({
                        self.favoriteAwemes += array
                        var indexPaths = [IndexPath]()
                        for row in (self.favoriteAwemes.count - array.count)..<self.favoriteAwemes.count {
                            indexPaths.append(IndexPath.init(row: row, section: 1))
                        }
                        self.collectionView?.insertItems(at: indexPaths)
                    }, completion: { finished in
                        UIView.setAnimationsEnabled(true)
                        self.loadMore?.endLoading()
                        if response.has_more == 0 {
                            self.loadMore?.loadingNoMore()
                        }
                    })
                }
            }, failure: { error in
                self.loadMore?.loadingFailed()
            })
        }
    }
}

extension UserHomeController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return tabIndex == 0 ? postAwemes.count : favoriteAwemes.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: COLLECTION_CELL_ID, for: indexPath) as! AwemeCollectionCell
        let aweme: Aweme = tabIndex == 0 ? postAwemes[indexPath.row] : favoriteAwemes[indexPath.row]
        cell.aweme = aweme
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            if kind == UICollectionView.elementKindSectionHeader {
                userInfoHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HEADER_ID, for: indexPath) as? UserHomeHeader
                userInfoHeader?.delegate = self
                userInfoHeader?.user = user
                return userInfoHeader!
            } else {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FOOTER_ID, for: indexPath) as! UserHomeFooter
                footer.delegate = self
                footer.setLabel(titles: ["作品" + String(user?.aweme_count ?? 0),"喜欢" + String(user?.favoriting_count ?? 0)], tabIndex: tabIndex)
                return footer
            }
        }
        return UICollectionReusableView.init()
    }
    
    // UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        var vc: UIViewController?
        if tabIndex == 0 {
            vc = AwemeListController.init(awemes: postAwemes, currentIndex: indexPath.row, page: pageIndex, size: pageSize, awemeType: .AwemePost, uid: uid)
        } else {
            vc = AwemeListController.init(awemes: favoriteAwemes, currentIndex: indexPath.row, page: pageIndex, size: pageSize, awemeType: .AwemeFavorite, uid: uid)
        }
        vc!.transitioningDelegate = self
        vc!.modalPresentationStyle = .overCurrentContext
        self.present(vc!, animated: true, completion: nil)
        self.modalPresentationStyle = .currentContext
        swipeLeftInteractiveTransition.presentingVC = vc
    }
    
    // UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? CGSize.init(width: ScreenWidth, height: HEADER_HEIGHT) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return section == 0 ? CGSize.init(width: ScreenWidth, height: FOOTER_HEIGHT) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: itemWidth, height: itemHeight)
    }
}

extension UserHomeController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            userInfoHeader?.overScrollAction(offsetY: offsetY)
        } else {
            userInfoHeader?.scrollToTopAction(offsetY: offsetY)
            
            if HEADER_HEIGHT - self.navagationBarHeight() * 2 > offsetY {
                setNavigationBarTitleColor(color: ColorClear)
            } else if HEADER_HEIGHT - self.navagationBarHeight() * 2 < offsetY && offsetY < HEADER_HEIGHT - self.navagationBarHeight() {
                let alphaRatio = 1.0 - (HEADER_HEIGHT - self.navagationBarHeight() - offsetY)/self.navagationBarHeight()
                self.setNavigationBarTitleColor(color: UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: alphaRatio))
            } else if HEADER_HEIGHT - self.navagationBarHeight() < offsetY  {
                self.setNavigationBarTitleColor(color: ColorWhite)
            }
        }
    }
}

extension UserHomeController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return scalePresentAnimation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return scaleDismissAnimation
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return swipeLeftInteractiveTransition.isInteracting ? swipeLeftInteractiveTransition : nil
    }
}

extension UserHomeController: UserHomeHeaderDelegate, UserHomeFooterDelegate {
    
    func userHomeHeader(_ header: UserHomeHeader, onTapItemTag tag: Int) {
        switch tag {
        case VIEW_AVATAE_TAG:
            PhotoBroswer(user?.avatar_medium?.url_list.first).show()
        case VIEW_SEND_MESSAGE_TAG:
            self.navigationController?.pushViewController(ChatListController.init(), animated: true)
        case VIEW_SETTING_TAG:
            let menu = MenuPopView.init(titles: ["清除缓存"])
            menu.onAction = { index in
                WebCacheManager.shared().clearCache { size in
                    UIWindow.showTips(text: "清除" + size + "M 缓存")
                }
            }
            menu.show()
        default:
            break
        }
    }
    
    func userHomeFooter(_ footer: UserHomeFooter, onTapIndex index: Int) {
        if tabIndex != index {
            tabIndex = index
            pageIndex = 0
            
            UIView.setAnimationsEnabled(false)
            collectionView?.performBatchUpdates({
                postAwemes.removeAll()
                favoriteAwemes.removeAll()
                collectionView?.reloadSections(IndexSet.init(integer: 1))
            }, completion: { finished in
                UIView.setAnimationsEnabled(true)
                self.loadMore?.reset()
                self.loadMore?.beginLoading()
                self.loadAwemesData(page: self.pageIndex)
            })
        }
    }
}

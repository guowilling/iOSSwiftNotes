
import UIKit

class U17VIPController: UIViewController, UICollectionViewDataSource,  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let VIPAndSubCellIdentifier = "VIPAndSubCellIdentifier"
    private let RecommendHeaderViewIdentifier = "RecommendHeaderViewIdentifier"
    private let U17FooterViewIdentifier = "U17FooterViewIdentifier"

    private var vipList = [ComicListModel]()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let collection = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeigth-64-49), collectionViewLayout: layout)
        collection.backgroundColor = UIColor.white
        collection.delegate = self
        collection.dataSource = self
        
        collection.register(UINib.init(nibName: "U17VIPAndSubscribeCell", bundle: nil), forCellWithReuseIdentifier: VIPAndSubCellIdentifier)
        collection.register(RecommendHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: RecommendHeaderViewIdentifier)
        collection.register(U17DivideFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: U17FooterViewIdentifier)

        collection.u17RefreshHeader = URefreshHeader{ [weak self] in self?.loadData() }
        collection.u17RefreshFooter = URefreshTipKissFooter(with: "VIP用户专享\nVIP用户可以免费阅读全部漫画哦~")
        
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.collectionView)
        
        loadData()
    }
    
    private func loadData() {
        APILoadingProvider.request(U17API.vipList, model: VipListModel.self) { (returnData) in
            self.vipList = returnData?.newVipList ?? []
            self.collectionView.u17RefreshHeader.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return vipList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let comicList = vipList[section]
        return comicList.comics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: U17VIPAndSubscribeCell = collectionView.dequeueReusableCell(withReuseIdentifier: VIPAndSubCellIdentifier, for: indexPath) as! U17VIPAndSubscribeCell
        let comicList = vipList[indexPath.section]
        cell.model = comicList.comics?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView: RecommendHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: RecommendHeaderViewIdentifier, for: indexPath) as! RecommendHeaderView
            let comicList = vipList[indexPath.section]
            headerView.imageView.kf.setImage(with: URL(string:comicList.titleIconUrl!))
            headerView.titleL.text = comicList.itemTitle
            headerView.moreBtn.isHidden = !comicList.canMore
            headerView.headerMoreBtnClick = { [weak self]() in }
            return headerView
        } else if kind == UICollectionElementKindSectionFooter {
            let footerView: U17DivideFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: U17FooterViewIdentifier, for: indexPath) as! U17DivideFooterView
            return footerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comicList = vipList[indexPath.section]
        guard let item = comicList.comics?[indexPath.row] else {
            return
        }
        //...
    }
}

extension U17VIPController {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (ScreenWidth - 6 * 4) / 3, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 6, 0, 6);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: ScreenWidth, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == vipList.count - 1 {
            return CGSize.zero
        }
        return CGSize.init(width: ScreenWidth, height: 10)
    }
}

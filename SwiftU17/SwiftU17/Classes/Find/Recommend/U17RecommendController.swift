
import UIKit

class U17RecommendController: UIViewController, UICollectionViewDataSource,  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var comicLists = [ComicListModel]()
    private var galleryItems = [GalleryItemModel]()
    private var TextItems = [TextItemModel]()

    private let RecommendBannerCellIdentifier = "RecommendBannerCellIdentifier"
    private let RecommendHeaderViewIdentifier = "RecommendHeaderViewIdentifier"
    private let RecommendHorizontalCellIdentifier = "RecommendHorizontalCellIdentifier"
    private let RecommendVerticalCellIdentifier = "RecommendVerticalCellIdentifier"
    private let RecommendTopicCellIdentifier = "RecommendTopicCellIdentifier"
    private let U17FooterViewIdentifier = "U17FooterViewIdentifier"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let collection = UICollectionView.init(frame: CGRect(x:0, y: 0, width: ScreenWidth, height: ScreenHeigth-64-49), collectionViewLayout: layout)
        collection.backgroundColor = UIColor.white
        collection.delegate = self
        collection.dataSource = self
       
        collection.register(RecommendBannerCell.self, forCellWithReuseIdentifier: RecommendBannerCellIdentifier)
        collection.register(RecommendHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RecommendHeaderViewIdentifier)
        collection.register(UINib.init(nibName: "RecommendHorizontalCell", bundle: nil), forCellWithReuseIdentifier: RecommendHorizontalCellIdentifier)
        collection.register(UINib.init(nibName: "RecommendVerticalCell", bundle: nil), forCellWithReuseIdentifier: RecommendVerticalCellIdentifier)
        collection.register(UINib.init(nibName: "RecommendTopicCell", bundle: nil), forCellWithReuseIdentifier: RecommendTopicCellIdentifier)
        collection.register(U17DivideFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: U17FooterViewIdentifier)
        
        collection.u17RefreshHeader = URefreshHeader { [weak self] in self?.loadData() }
        collection.u17RefreshFooter = URefreshDiscoverFooter()
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGray
        
        self.view.addSubview(self.collectionView)
        
        loadData()
    }
    
    private func loadData(){
        APILoadingProvider.request(U17API.boutiqueList(sexType: 1), model: BoutiqueListModel.self) { [weak self] (returnData) in
            self?.comicLists = returnData?.comicLists ?? []
            self?.galleryItems = returnData?.galleryItems ?? []
            self?.TextItems = returnData?.textItems ?? []
            self?.collectionView.u17RefreshHeader.endRefreshing()
            self?.collectionView.reloadData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return comicLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 || section == 2 || section == 3 {
            return 4
        }
        if section == 4 || section == 6 || section == 9 || section == 10 ||  section == 11 {
            return 3
        }
        if section == 7 {
            return 0
        }
        if section == 5 || section == 8 {
            return 2
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let comicList = comicLists[indexPath.section]
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendBannerCellIdentifier, for: indexPath) as! RecommendBannerCell
            cell.imagePaths = self.galleryItems.filter { $0.cover != nil }.map { $0.cover! }
            cell.comicListModel = comicLists[indexPath.section]
            cell.u17BannerClick = { [weak self](index) in }
            cell.u17GridBtnClick = { [weak self](index) in }
            return cell
        } else if indexPath.section == 1 || indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendHorizontalCellIdentifier, for: indexPath) as! RecommendHorizontalCell
            cell.model = comicList.comics?[indexPath.row]
            cell.backgroundColor = UIColor.white
            return cell
        } else if indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendTopicCellIdentifier, for: indexPath) as! RecommendTopicCell
            cell.model = comicList.comics?[indexPath.row]
            return cell
        } else if indexPath.section == 4 ||
            indexPath.section == 6 ||
            indexPath.section == 9 ||
            indexPath.section == 10 ||
            indexPath.section == 11 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendVerticalCellIdentifier, for: indexPath) as! RecommendVerticalCell
            if comicList.comics?.count == 3 {
                cell.model = comicList.comics?[indexPath.row]
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendHorizontalCellIdentifier, for: indexPath) as! RecommendHorizontalCell
            cell.backgroundColor = UIColor.white
            if comicList.comics?.count == 2 {
                cell.model = comicList.comics?[indexPath.row]
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView: RecommendHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RecommendHeaderViewIdentifier, for: indexPath) as! RecommendHeaderView
            let comicList: ComicListModel = comicLists[indexPath.section]
            if (comicList.itemTitle != nil) {
                headerView.titleL.text = comicList.itemTitle
                headerView.imageView.kf.setImage(with:URL(string:comicList.newTitleIconUrl!))
            }
            headerView.headerMoreBtnClick = { [weak self]() in }
            return headerView
        } else if kind == UICollectionView.elementKindSectionFooter {
            let footerView: U17DivideFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: U17FooterViewIdentifier, for: indexPath) as! U17DivideFooterView
            return footerView
        }
        return UICollectionReusableView()
    }
}

extension U17RecommendController {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize.init(width: ScreenWidth, height: 260)
        } else if indexPath.section == 1 || indexPath.section == 2 {
            return CGSize.init(width: (ScreenWidth - 6 * 3) / 2, height: 150)
        } else if indexPath.section == 3 {
            return CGSize.init(width: (ScreenWidth - 6 * 3) / 2 , height: 120)
        } else if indexPath.section == 4 ||
            indexPath.section == 6 ||
            indexPath.section == 9 ||
            indexPath.section == 10 ||
            indexPath.section == 11 {
            return CGSize.init(width: (ScreenWidth - 6 * 4) / 3, height: 220)
        } else {
            return CGSize.init(width: (ScreenWidth - 6 * 3) / 2, height: 150)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 || section == 7 {
            return CGSize.zero
        } else {
            return CGSize.init(width: ScreenWidth, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == comicLists.count - 1 {
            return CGSize.zero
        }
        return CGSize.init(width: ScreenWidth, height: 10)
    }
}


import UIKit

class U17RankController: UIViewController, UICollectionViewDataSource,  UICollectionViewDelegate {
    
    private let U17RankCellIdentifier = "U17RankCellIdentifier"
    private let U17FooterViewIdentifier = "U17FooterViewIdentifier"
    
    private var rankList = [RankingModel]()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeigth - 64 - 49), collectionViewLayout: layout)
        collection.backgroundColor = UIColor.white
        collection.delegate = self
        collection.dataSource = self
        
        collection.register(U17RankCell.self, forCellWithReuseIdentifier: U17RankCellIdentifier)
        collection.register(U17DivideFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: U17FooterViewIdentifier)
        
        collection.u17RefreshHeader = URefreshHeader{ [weak self] in self?.loadData() }
        
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.collectionView)
        
        loadData()
    }
    
    private func loadData() {
        APILoadingProvider.request(U17API.rankList, model: RankinglistModel.self) { (returnData) in
            self.rankList = returnData?.rankinglist ?? []
            self.collectionView.u17RefreshHeader.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rankList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: U17RankCell = collectionView.dequeueReusableCell(withReuseIdentifier: U17RankCellIdentifier, for: indexPath) as! U17RankCell
        cell.model = rankList[indexPath.section]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView: U17DivideFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: U17FooterViewIdentifier, for: indexPath) as! U17DivideFooterView
            return footerView
        }
        return UICollectionReusableView()
    }
}

extension U17RankController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenWidth, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == rankList.count - 1 {
            return CGSize.zero
        }
        return CGSize(width: ScreenWidth, height: 10)
    }
}

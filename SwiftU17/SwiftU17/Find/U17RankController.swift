
import UIKit

class U17RankController: UIViewController, UICollectionViewDataSource,  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
        private let U17RankCellIdentifier = "U17RankCellIdentifier"
        private let U17FooterViewIdentifier = "U17FooterViewIdentifier"

        private var rankList = [RankingModel]()

        lazy var collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout.init()
            let collection = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeigth-64-49), collectionViewLayout: layout)
            collection.backgroundColor = UIColor.white
            collection.delegate = self
            collection.dataSource = self
            
            collection.register(U17RankCell.self, forCellWithReuseIdentifier: U17RankCellIdentifier)
            collection.register(U17DivideFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: U17FooterViewIdentifier)

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let footerView: U17DivideFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: U17FooterViewIdentifier, for: indexPath) as! U17DivideFooterView
            return footerView
        }
        return UICollectionReusableView()
    }
}

extension U17RankController {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: ScreenWidth, height: 160)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == rankList.count - 1 {
            return CGSize.zero
        }
        return CGSize.init(width: ScreenWidth, height: 10)
    }
}


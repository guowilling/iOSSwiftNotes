
import UIKit

fileprivate let kEdgeMargin: CGFloat = 7.5

fileprivate let kAnchorCellID = "kAnchorCellID"

class HomeAnchorViewController: UIViewController {
    
    // MARK: - 公有属性
    var anchorType: AnchorType!
    
    // MARK: - 私有属性
    fileprivate lazy var homeVM: HomeViewModel = HomeViewModel()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = HomeWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: kEdgeMargin, left: kEdgeMargin, bottom: kEdgeMargin, right: kEdgeMargin)
        layout.minimumLineSpacing = kEdgeMargin
        layout.minimumInteritemSpacing = kEdgeMargin
        layout.dataSource = self
        
        let vc = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        vc.backgroundColor = UIColor.white
        vc.dataSource = self
        vc.delegate = self
        vc.register(UINib(nibName: "HomeAnchorCell", bundle: nil), forCellWithReuseIdentifier: kAnchorCellID)
        vc.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        loadData(index: 0)
    }
}

extension HomeAnchorViewController {
    fileprivate func loadData(index: Int) {
        homeVM.loadAnchorData(anchorType: anchorType, index: index, completion: {
            self.collectionView.reloadData()
        })
    }
}

extension HomeAnchorViewController: UICollectionViewDataSource, UICollectionViewDelegate, HomeWaterfallLayoutDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeVM.anchorModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kAnchorCellID, for: indexPath) as! HomeAnchorCell
        cell.anchorModel = homeVM.anchorModels[indexPath.item]
        if indexPath.item == homeVM.anchorModels.count - 1 {
            loadData(index: homeVM.anchorModels.count)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lrVC = LiveRoomViewController()
        lrVC.anchorModel = homeVM.anchorModels[indexPath.item]
        navigationController?.pushViewController(lrVC, animated: true)
    }
    
    func waterfallLayout(_ layout: HomeWaterfallLayout, heightOfIndexPath indexPath: IndexPath) -> CGFloat {
        return indexPath.item % 2 == 0 ? kScreenW * 2 / 3 : kScreenW * 0.5
    }
}


import UIKit

private let kEdgeMargin: CGFloat = 8.0

private let kAnchorCellID = "kAnchorCellID"

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
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "HomeAnchorCell", bundle: nil), forCellWithReuseIdentifier: kAnchorCellID)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return collectionView
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
        let liveRoomVC = LiveRoomViewController()
        liveRoomVC.anchorModel = homeVM.anchorModels[indexPath.item]
        navigationController?.pushViewController(liveRoomVC, animated: true)
    }
    
    func waterfallLayout(_ layout: HomeWaterfallLayout, heightOfIndexPath indexPath: IndexPath) -> CGFloat {
        return indexPath.item % 2 == 0 ? kScreenW * 2 / 3 : kScreenW * 0.5
    }
}

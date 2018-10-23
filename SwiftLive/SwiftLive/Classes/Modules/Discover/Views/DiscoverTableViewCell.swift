
import UIKit

class DiscoverTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate lazy var discoverVM: DiscoverViewModel = DiscoverViewModel()
    
    fileprivate var anchorData: [AnchorModel]?
    
    fileprivate var currentIndex: Int = 0
    
    var didSelectItem: ((_ anchor: AnchorModel) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        discoverVM.loadDiscoverData {
            self.anchorData = Array(self.discoverVM.anchorModels[self.currentIndex * 9..<(self.currentIndex + 1) * 9])
            self.collectionView.reloadData()
        }
    }
    
    func reloadData() {
        currentIndex += 1
        if currentIndex > 2 {
            currentIndex = 0
        }
        anchorData = Array(discoverVM.anchorModels[currentIndex * 9..<(currentIndex + 1) * 9])
        collectionView.reloadData()
    }
    
}

extension DiscoverTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return anchorData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionViewCellID", for: indexPath) as! DiscoverCollectionViewCell
        cell.anchorModel = anchorData![indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let didSelectItem = didSelectItem {
            didSelectItem(anchorData![indexPath.item])
        }
    }
}

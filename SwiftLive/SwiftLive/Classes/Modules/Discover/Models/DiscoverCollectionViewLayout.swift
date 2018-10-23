
import UIKit

class DiscoverCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        let itemMargin: CGFloat = 10
        let itemW = (collectionView!.bounds.width - 5 * itemMargin) / 3
        let itemH = collectionView!.bounds.height / 3
        itemSize = CGSize(width: itemW, height: itemH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = itemMargin
        sectionInset = UIEdgeInsets(top: 0, left: itemMargin, bottom: 0, right: itemMargin)
        collectionView?.bounces = false
    }
}

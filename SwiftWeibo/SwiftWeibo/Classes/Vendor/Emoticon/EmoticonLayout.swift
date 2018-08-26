
import UIKit

class EmoticonLayout: UICollectionViewFlowLayout {
    // prepare 就是 OC 中的 prepareLayout
    override func prepare() {
        super.prepare()
        
        // 此方法中 collectionView 的大小已经确定.
        guard let collectionView = collectionView else {
            return
        }
        itemSize = collectionView.bounds.size
        scrollDirection = .horizontal
    }
}

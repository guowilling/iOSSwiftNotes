
import UIKit

@objc protocol HomeWaterfallLayoutDataSource : class {
    
    func waterfallLayout(_ layout: HomeWaterfallLayout, heightOfIndexPath indexPath: IndexPath) -> CGFloat
    
    @objc optional func numberOfColsInWaterfallLayout(_ layout: HomeWaterfallLayout) -> Int
}

class HomeWaterfallLayout: UICollectionViewFlowLayout {
    
    // MARK: - 公有属性
    weak var dataSource: HomeWaterfallLayoutDataSource?
    
    // MARK: - 私有属性
    fileprivate lazy var attrsArray: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    fileprivate lazy var colsHeight: [CGFloat] = {
        let cols = self.dataSource?.numberOfColsInWaterfallLayout?(self) ?? 2
        var colsHeight = Array(repeating: self.sectionInset.top, count: cols)
        return colsHeight
    }()
    
    fileprivate var maxHeight: CGFloat = 0
    
    fileprivate var startIndex = 0
}

extension HomeWaterfallLayout {
    
    override func prepare() {
        super.prepare()
        
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        let cols = dataSource?.numberOfColsInWaterfallLayout?(self) ?? 2
        let itemW = (collectionView!.bounds.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing) / CGFloat(cols)
        for i in startIndex..<itemCount {
            let indexPath = IndexPath(item: i, section: 0)
            let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            guard let height = dataSource?.waterfallLayout(self, heightOfIndexPath: indexPath) else {
                fatalError("Height must be setted!")
            }
            var minH = colsHeight.min()! // 取出高度最小的列
            let index = colsHeight.index(of: minH)!
            minH = minH + height + minimumLineSpacing
            colsHeight[index] = minH
            
            layoutAttributes.frame = CGRect(x: self.sectionInset.left + (self.minimumInteritemSpacing + itemW) * CGFloat(index),
                                            y: minH - height - self.minimumLineSpacing,
                                            width: itemW,
                                            height: height)
            
            attrsArray.append(layoutAttributes)
        }
        
        maxHeight = colsHeight.max()!
        
        startIndex = itemCount
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: maxHeight + sectionInset.bottom - minimumLineSpacing)
    }
}

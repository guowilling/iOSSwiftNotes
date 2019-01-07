
import Foundation

class HoverViewFlowLayout: UICollectionViewFlowLayout {
    
    var navHeight: CGFloat = 0
    
    init(navHeight: CGFloat) {
        super.init()
        
        self.navHeight = navHeight
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 重写 layoutAttributesForElements(in:) 方法
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect)!
    
        // 1.移除所有 Header 和 Footer 类型的元素, 即移除需要固定的 Header 和 Footer, 因为后续会单独添加
        // 因为抖音个人主页中只有第一个 section 包含 Header 和 Footer
        let layoutAttributesCopy = layoutAttributes
        for index in 0..<layoutAttributesCopy.count {
            let layoutAttribute = layoutAttributesCopy[index]
            if
                layoutAttribute.representedElementKind == UICollectionView.elementKindSectionHeader ||
                layoutAttribute.representedElementKind == UICollectionView.elementKindSectionFooter
            {
                if let idx = layoutAttributes.index(of: layoutAttribute) {
                    layoutAttributes.remove(at: idx)
                }
            }
        }
        
        // 2.单独添加上一步移除的 Header 和 Footer
        // 因为第一步只能获取当前在屏幕 rect 中显示的元素属性, 当第一个 sectioin 移出屏幕便无法获取 Header 和 Footer
        if let header = super.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath.init(item: 0, section: 0)) {
            layoutAttributes.append(header)
        }
        if let footer = super.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: IndexPath.init(item: 0, section: 0)) {
            layoutAttributes.append(footer)
        }
        
        for attributes in layoutAttributes {
            if attributes.indexPath.section == 0 {
                if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                    var rect = attributes.frame
                    if self.collectionView!.contentOffset.y + self.navHeight - rect.size.height > rect.origin.y { // Header 的 bottom 滑动到导航栏下方
                        rect.origin.y = self.collectionView!.contentOffset.y + self.navHeight - rect.size.height
                        attributes.frame = rect
                    }
                    attributes.zIndex = 5 // 保证 Header 显示时不被其它 cell 覆盖
                } else if attributes.representedElementKind == UICollectionView.elementKindSectionFooter {
                    var rect = attributes.frame
                    if (self.collectionView?.contentOffset.y)! + self.navHeight > rect.origin.y { // Footer 的 top 滑动到导航栏下方
                        rect.origin.y = (self.collectionView?.contentOffset.y)! + self.navHeight
                        attributes.frame = rect
                    }
                    attributes.zIndex = 10 // 保证 Footer 显示时不被其它 cell 覆盖同时显示在 Header 之上
                }
            }
        }

        return layoutAttributes
    }
    
    // 重写 shouldInvalidateLayoutForBoundsChange(forBoundsChange:) 方法
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

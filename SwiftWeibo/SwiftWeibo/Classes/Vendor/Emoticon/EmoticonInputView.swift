
import UIKit

private let cellId = "cellId"

/// 表情键盘输入视图
class EmoticonInputView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var toolbar: EmoticonToolbar!

    @IBOutlet weak var pageControl: UIPageControl!
    
    fileprivate var selectedEmoticonCallBack: ((_ emoticon: Emoticon?)->())?
    
    class func inputView(selectedEmoticon: @escaping (_ emoticon: Emoticon?)->()) -> EmoticonInputView {
        let emoticonInputNib = UINib(nibName: "EmoticonInputView", bundle: nil)
        let emoticonInputView = emoticonInputNib.instantiate(withOwner: nil, options: nil)[0] as! EmoticonInputView
        emoticonInputView.selectedEmoticonCallBack = selectedEmoticon
        return emoticonInputView
    }
    
    override func awakeFromNib() {
        collectionView.backgroundColor = UIColor.white
        collectionView.register(EmoticonCell.self, forCellWithReuseIdentifier: cellId)
        
        toolbar.delegate = self
        
        let bundle = EmoticonManager.shared.bundle
        guard let normalImage = UIImage(named: "compose_keyboard_dot_normal", in: bundle, compatibleWith: nil),
            let selectedImage = UIImage(named: "compose_keyboard_dot_selected", in: bundle, compatibleWith: nil) else {
                return
        }
        // KVC 设置私有属性
        pageControl.setValue(normalImage, forKey: "_pageImage")
        pageControl.setValue(selectedImage, forKey: "_currentPageImage")
        // 填充图片设置颜色
        //pageControl.pageIndicatorTintColor = UIColor(patternImage: normalImage)
        //pageControl.currentPageIndicatorTintColor = UIColor(patternImage: selectedImage)
    }
}

extension EmoticonInputView: EmoticonToolbarDelegate {
    
    func emoticonToolbarDidSelectedItemIndex(toolbar: EmoticonToolbar, index: Int) {
        let indexPath = IndexPath(item: 0, section: index)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        toolbar.selectedIndex = index
    }
}

// MARK: - UICollectionViewDelegate
extension EmoticonInputView: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1. 获取中心点
        var center = scrollView.center
        center.x += scrollView.contentOffset.x

        // 2. 获取当前显示的 cell 的 indexPath
        let paths = collectionView.indexPathsForVisibleItems
        
        // 3. 判断中心点在哪一个 indexPath 上，在哪一个页面上
        var targetIndexPath: IndexPath?
        
        for indexPath in paths {
            let cell = collectionView.cellForItem(at: indexPath)
            if cell?.frame.contains(center) == true {
                targetIndexPath = indexPath
                break
            }
        }
        guard let target = targetIndexPath else {
            return
        }
        
        // 4. 判断是否找到 目标的 indexPath
        // indexPath.section => 对应的就是分组
        toolbar.selectedIndex = target.section
        
        // 5. 设置分页控件
        // 总页数，不同的分组，页数不一样
        pageControl.numberOfPages = collectionView.numberOfItems(inSection: target.section)
        pageControl.currentPage = target.item
    }
}

// MARK: - UICollectionViewDataSource
extension EmoticonInputView: UICollectionViewDataSource {

    // 表情包的数量
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return EmoticonManager.shared.packages.count
    }

    // 表情包中表情页的数量 emoticons 数组 / 20
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EmoticonManager.shared.packages[section].numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EmoticonCell
        cell.emoticons = EmoticonManager.shared.packages[indexPath.section].emoticon(page: indexPath.item)
        cell.delegate = self // 设置代理 - 不适合用闭包
        return cell
    }
}

// MARK: - CZEmoticonCellDelegate
extension EmoticonInputView: EmoticonCellDelegate {
    /// 选中的表情回调
    ///
    /// - parameter cell: 分页 Cell
    /// - parameter em:   选中的表情，删除键为 nil
    func emoticonCellDidSelectedEmoticon(cell: EmoticonCell, em: Emoticon?) {
        // print(em)
        // 执行闭包，回调选中的表情
        selectedEmoticonCallBack?(em)
        
        // 添加最近使用的表情
        guard let em = em else {
            return
        }
        
        // 如果当前 collectionView 就是最近的分组，不添加最近使用的表情
        let indexPath = collectionView.indexPathsForVisibleItems[0]
        if indexPath.section == 0 {
            return
        }
        
        // 添加最近使用的表情
        EmoticonManager.shared.recentEmoticon(em: em)
        
        // 刷新数据 - 第 0 组
        var indexSet = IndexSet()
        indexSet.insert(0)
        
        collectionView.reloadSections(indexSet)
    }
}

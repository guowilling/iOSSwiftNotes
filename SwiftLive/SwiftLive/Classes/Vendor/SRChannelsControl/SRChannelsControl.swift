
import UIKit

class SRChannelsControl: UIView {
    
    fileprivate var titles: [String]
    fileprivate var titleStyle: SRChannelsTitleStyle
    fileprivate var childVCs: [UIViewController]
    fileprivate var parentVC: UIViewController
    
    fileprivate var channelsTitle: SRChannelsTitle!
    fileprivate var channelsContent: SRChannelsContent!
    
    init(frame: CGRect, titles: [String], titleStyle: SRChannelsTitleStyle, childVCs: [UIViewController], parentVC: UIViewController) {
        self.titles = titles
        self.titleStyle = titleStyle
        self.childVCs = childVCs
        self.parentVC = parentVC
        
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SRChannelsControl {
    fileprivate func setupUI() {
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: titleStyle.titleHeight)
        channelsTitle = SRChannelsTitle(frame: titleFrame, titles: titles, titleStyle: titleStyle)
        channelsTitle.delegate = self
        addSubview(channelsTitle)
        
        let contentFrame = CGRect(x: 0, y: titleFrame.maxY, width: bounds.width, height: frame.height - titleFrame.height)
        channelsContent = SRChannelsContent(frame: contentFrame, childVCs: childVCs, parentVC: parentVC)
        channelsContent.delegate = self
        addSubview(channelsContent)
    }
}

extension SRChannelsControl: SRChannelsContentDelegate {
    func channelsContent(_ channelsContent: SRChannelsContent, scrollFromIndex fromIndex: Int, toIndex: Int, progress: CGFloat) {
        channelsTitle.scroll(fromIndex: fromIndex, toIndex: toIndex, progress: progress)
    }
    
    func channelsContent(_ channelsContent: SRChannelsContent, didEndScrollAtIndex atIndex: Int) {
        channelsTitle.didEndScrollAtIndex(atIndex: atIndex)
    }
}

extension SRChannelsControl: SRChannelsTitleDeleate {
    func channelsTitle(_ channelsTitle: SRChannelsTitle, didSelectIndex index: Int) {
        channelsContent.didSelectIndex(index: index)
    }
}

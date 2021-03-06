
import UIKit

class DiscoverCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var onlineLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var liveImageView: UIImageView!
    
    var anchorModel: AnchorModel? {
        didSet {
            guard let anchorModel = anchorModel else {
                return
            }
            iconImageView.setImage(anchorModel.pic51, "home_pic_default")
            
            liveImageView.isHidden = anchorModel.live == 0
            
            nickNameLabel.text = anchorModel.name
            
            onlineLabel.text = "\(anchorModel.focus)人观看"
        }
    }
}

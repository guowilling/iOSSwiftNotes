
import UIKit
import Kingfisher

class HomeAnchorCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var liveImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var onlinePeopleBtn: UIButton!
    
    var anchorModel: AnchorModel? {
        didSet {
            albumImageView.setImage(anchorModel!.isEvenIndex ? anchorModel?.pic74 : anchorModel?.pic51, "home_pic_default")
            
            liveImageView.isHidden = anchorModel?.live == 0
            
            nickNameLabel.text = anchorModel?.name
            
            onlinePeopleBtn.setTitle("\(anchorModel?.focus ?? 0)", for: .normal)
        }
    }
}


import UIKit

class ProfileItemCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    @IBOutlet weak var contentLabelLeftCons: NSLayoutConstraint!
    
    var itemModel: ProfileItemModel? {
        didSet {
            guard let itemModel = itemModel else {
                return
            }
            itemModel.iconName == "" ? (iconImageView.isHidden = true) : (iconImageView.image = UIImage(named: itemModel.iconName))
          
            contentLabelLeftCons.constant = itemModel.iconName == "" ? -30 : 10
          
            contentLabel.text = itemModel.contentText
            
            switch itemModel.accessoryType {
            case .arrow:
                onSwitch.isHidden = true
                hintLabel.isHidden = true
            case .arrowHint:
                onSwitch.isHidden = true
                hintLabel.isHidden = false
                hintLabel.text = itemModel.hintText
            case .onSwitch:
                onSwitch.isHidden = false
                hintLabel.isHidden = true
                arrowImageView.isHidden = true
            }
        }
    }
}


import UIKit

class RankDateCell: UITableViewCell {

    @IBOutlet weak var rankNumBtn: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var liveImageView: UIImageView!
    
    var rankNum: Int = 0 {
        didSet {
            if rankNum < 3 {
                rankNumBtn.setTitle("", for: .normal)
                rankNumBtn.setImage(UIImage(named: "ranking_icon_no\(rankNum + 1)"), for: .normal)
            } else {
                rankNumBtn.setTitle("\(rankNum + 1)", for: .normal)
                rankNumBtn.setImage(nil, for: .normal)
            }
        }
    }
    
    var rankDateModel: RankDateModel? {
        didSet {
            iconImageView.setImage(rankDateModel?.avatar)
            nickNameLabel.text = rankDateModel?.nickname
            liveImageView.isHidden = rankDateModel?.isInLive == 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.layer.cornerRadius = iconImageView.bounds.width * 0.5
        iconImageView.layer.masksToBounds = true
    }
}

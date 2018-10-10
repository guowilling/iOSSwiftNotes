
import UIKit

class RankWeekCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var giftNumLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    
    var weekModel: RankWeekModel? {
        didSet {
            iconImageView.setImage(weekModel?.giftAppImg)
            giftNameLabel.text = weekModel?.giftName
            giftNumLabel.text = "本周获得 x\(weekModel?.giftNum ?? 0)个"
            nickNameLabel.text = weekModel?.nickname
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


import UIKit

class U17VIPAndSubscribeCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: ComicModel? {
        didSet {
            guard let model = model else {
                return
            }
            let url = URL(string:model.cover!)
            imageView.kf.setImage(with: url)
            titleLabel.text = model.name ?? model.title
        }
    }
}

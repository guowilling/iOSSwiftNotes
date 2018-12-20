
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
            guard let model = model else { return }
            imageView.kf.setImage(with: URL(string: model.cover!))
            titleLabel.text = model.name ?? model.title
        }
    }
}

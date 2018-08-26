
import UIKit

class RecommendTopicCell: UICollectionViewCell {

    @IBOutlet weak var picImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: ComicModel? {
        didSet {
            guard let model = model else {
                return
            }
            picImage.kf.setImage(with: URL(string : model.cover!))
        }
    }
}

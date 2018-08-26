
import UIKit

class WBStatusToolBar: UIView {
    
    @IBOutlet weak var retweetedButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var viewModel: WBStatusViewModel? {
        didSet {
            //retweetedButton.setTitle("\(viewModel?.status.reposts_count)", for: [])
            //commentButton.setTitle("\(viewModel?.status.comments_count)", for: [])
            //likeButton.setTitle("\(viewModel?.status.attitudes_count)", for: [])
            retweetedButton.setTitle(viewModel?.retweetedStr, for: [])
            commentButton.setTitle(viewModel?.commentStr, for: [])
            likeButton.setTitle(viewModel?.likeStr, for: [])
        }
    }
}

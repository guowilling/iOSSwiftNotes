
import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(_ URLString : String?, _ placeHolderName : String? = nil) {
        guard let URLString = URLString else {
            return
        }
        guard let imageURL = URL(string: URLString) else {
            return
        }
        guard let placeHolderName = placeHolderName else {
            kf.setImage(with: imageURL)
            return
        }
        kf.setImage(with: imageURL, placeholder : UIImage(named: placeHolderName))
    }
}

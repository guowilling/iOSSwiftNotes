
import Foundation

extension NSAttributedString {
    
    func multiLineSize(width: CGFloat) -> CGSize {
        let rect = self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return CGSize(width: rect.size.width, height: rect.size.height)
    }
}

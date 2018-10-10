
import UIKit

enum SettingAccessoryType {
    case arrow
    case arrowHint
    case onswitch
}

class ProfileItemModel: NSObject {
    
    var iconName: String = ""
    var contentText: String = ""
    var hintText: String = ""
    var accessoryType: SettingAccessoryType = .arrow
    
    init(icon: String = "", content: String, hint: String = "", type: SettingAccessoryType = .arrow) {
        self.iconName = icon
        self.contentText = content
        self.hintText = hint
        self.accessoryType = type
    }
}

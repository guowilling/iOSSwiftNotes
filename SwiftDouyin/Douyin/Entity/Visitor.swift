
import Foundation

class Visitor: BaseModel {
    var uid: String?
    var udid: String?
    var avatar_thumbnail: PictureInfo?
    var avatar_medium: PictureInfo?
    var avatar_large: PictureInfo?
    
    static func write(visitor: Visitor) {
        UserDefaults.standard.set(visitor.toJSON(), forKey: "visitor")
        UserDefaults.standard.synchronize()
    }
    
    static func read() ->Visitor {
        let visitorDic = UserDefaults.standard.object(forKey: "visitor") as! [String: Any]
        let visitor = Visitor.deserialize(from: visitorDic)
        return visitor!
    }
    
    static func formatUDID(udid: String) -> String {
        if udid.count < 8 {
            return "************"
        }
        return udid.subString(location: 0, length: 4) + "****" + udid.subString(location: udid.count - 4, length: 4)
    }
}

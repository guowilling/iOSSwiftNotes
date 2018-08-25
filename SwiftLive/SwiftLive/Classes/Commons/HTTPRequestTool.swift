
import UIKit
import Alamofire

enum HTTPRequestType {
    case get
    case post
}

class HTTPRequestTool: NSObject {
    class func request(_ type: HTTPRequestType, urlString: String, parameters: [String: Any]? = nil, completion: @escaping (_ result: Any) -> ()) {
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        Alamofire.request(urlString, method: method, parameters: parameters).responseJSON { (response) in
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            completion(result)
        }
    }
}


import UIKit
import Alamofire

enum HTTPRequestType {
    case get
    case post
}

class HTTPRequestTool: NSObject {
    class func request(_ type: HTTPRequestType, URLString: String, parameters: [String: Any]? = nil, completion: @escaping (_ result: Any) -> ()) {
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                completion(value)
            case .failure(let error):
                print(error)
            }
        }
    }
}

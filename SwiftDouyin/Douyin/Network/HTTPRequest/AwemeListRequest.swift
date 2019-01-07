
import Foundation

class AwemeListRequest: BaseRequest {
    
    var uid: String?
    var page: Int?
    var size: Int?
    
    static func getPostAwemes(uid: String, page: Int, _ size: Int = 20, success: @escaping HTTPSuccessClosure, failure: @escaping HTTPFailureClosure) {
        let request = AwemeListRequest.init()
        request.uid = uid
        request.page = page
        request.size = size
        
        HTTPManager.GET(urlString: LIST_AWEME_POST, request: request, success: { data in
            if let response = AwemeListResponse.deserialize(from: data as? [String:Any]) {
                success(response)
            }
        }, failure: { error in
            failure(error)
        })
    }
    
    static func getFavoriteAwemes(uid: String, page: Int, _ size: Int = 20, success: @escaping HTTPSuccessClosure, failure: @escaping HTTPFailureClosure) {
        let request = AwemeListRequest.init()
        request.uid = uid
        request.page = page
        request.size = size
        
        HTTPManager.GET(urlString: LIST_AWEME_FAVORITE, request: request, success: { data in
            if let response = AwemeListResponse.deserialize(from: data as? [String:Any]) {
                success(response)
            }
        }) { error in
            failure(error)
        }
    }
}

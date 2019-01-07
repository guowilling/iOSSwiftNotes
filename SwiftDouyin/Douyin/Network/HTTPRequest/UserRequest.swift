
import Foundation

class UserRequest: BaseRequest {
    
    var uid: String?
    
    static func findUser(uid:String, success:@escaping HTTPSuccessClosure, failure:@escaping HTTPFailureClosure) {
        let request = UserRequest.init()
        request.uid = uid
        
        HTTPManager.GET(urlString: FIND_USER_BY_UID, request: request, success: { data in
            let response = UserResponse.deserialize(from: data as? [String:Any])
            success(response?.data ?? User.init())
        }, failure: { error in
            failure(error)
        })
    }
}

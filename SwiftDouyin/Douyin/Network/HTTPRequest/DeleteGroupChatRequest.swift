
import Foundation

class DeleteGroupChatRequest: BaseRequest {
    
    var id: String?
    var udid: String?
    
    static func deleteGroupChat(id: String, success: @escaping HTTPSuccessClosure, failure: @escaping HTTPFailureClosure) {
        let request = DeleteGroupChatRequest.init()
        request.id = id
        request.udid = UDID
        
        HTTPManager.DELETE(urlString: DELETE_GROUP_CHAT_BY_ID, request: request, success: { data in
            let response = BaseResponse.deserialize(from: data as? [String:Any])
            success(response!)
        }, failure: { error in
            failure(error)
        })
    }
}

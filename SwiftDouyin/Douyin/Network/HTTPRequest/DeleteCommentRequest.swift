
import Foundation

class DeleteCommentRequest: BaseRequest {
    
    var cid: String?
    var udid: String?
    
    static func deleteComment(cid: String, success: @escaping HTTPSuccessClosure, failure: @escaping HTTPFailureClosure) {
        let request = DeleteCommentRequest.init()
        request.cid = cid
        request.udid = UDID
        
        HTTPManager.DELETE(urlString: DELETE_COMMENT_BY_ID, request: request, success: { data in
            let response = BaseResponse.deserialize(from: data as? [String: Any])
            success(response!)
        }, failure: { error in
            failure(error)
        })
    }
}

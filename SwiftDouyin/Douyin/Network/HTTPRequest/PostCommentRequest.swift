
import Foundation

class PostCommentRequest: BaseRequest {
    
    var aweme_id: String?
    var text: String?
    var udid: String?
    
    static func postCommentText(aweme_id: String, text: String, success: @escaping HTTPSuccessClosure, failure: @escaping HTTPFailureClosure) {
        let request = PostCommentRequest.init()
        request.aweme_id = aweme_id
        request.text = text
        request.udid = UDID
        
        HTTPManager.POST(urlString: POST_COMMENT, request: request, success: { data in
            let response = CommentResponse.deserialize(from: data as? [String:Any])
            success(response!)
        }, failure: { error in
            failure(error)
        })
    }
}

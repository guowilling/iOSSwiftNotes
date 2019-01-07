
import Foundation

class CommentListRequest: BaseRequest {
    
    var page: Int?
    var size: Int?
    var aweme_id: String?
    
    static func getComments(aweme_id: String, page: Int, _ size: Int = 20, success: @escaping HTTPSuccessClosure, failure: @escaping HTTPFailureClosure) {
        let request = CommentListRequest.init()
        request.page = page
        request.size = size
        request.aweme_id = aweme_id
        
        HTTPManager.GET(urlString: LIST_COMMENT, request: request, success: { data in
            let response = CommentListResponse.deserialize(from: data as? [String: Any])
            success(response!)
        }, failure: { error in
            failure(error)
        })
    }
}

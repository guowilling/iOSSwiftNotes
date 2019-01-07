
import Foundation

class PostGroupChatTextRequest: BaseRequest {
    
    var udid: String?
    var text: String?
    
    static func postGroupChatText(text: String, success: @escaping HTTPSuccessClosure, failure: @escaping HTTPFailureClosure) {
        let request = PostGroupChatTextRequest.init()
        request.udid = UDID
        request.text = text
        
        HTTPManager.POST(urlString: POST_GROUP_CHAT_TEXT, request: request, success: { data in
            let response = GroupChatResponse.deserialize(from: data as? [String: Any])
            success(response!)
        }, failure: { error in
            failure(error)
        })
    }
}

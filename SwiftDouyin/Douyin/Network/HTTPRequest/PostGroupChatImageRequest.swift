
import Foundation

class PostGroupChatImageRequest: BaseRequest {
    
    var udid: String?
    
    static func postGroupChatImage(data: Data, _ progress:@escaping ((_ percent: CGFloat) -> Void), success: @escaping HTTPSuccessClosure, failure: @escaping HTTPFailureClosure) {
        let request = PostGroupChatImageRequest.init()
        request.udid = UDID
        
        HTTPManager.UPLOAD(urlString: POST_GROUP_CHAT_IMAGE, data: data, request: request, progress: { percent in
            progress(percent)
        }, success: { data in
            let response = GroupChatResponse.deserialize(from: data as? [String: Any])
            success(response!)
        }, failure: { error in
            failure(error)
        })
    }
}

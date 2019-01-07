
import Foundation

class GroupChatListRequest: BaseRequest {
    
    var page: Int?
    var size: Int?
    
    static func getGroupChatList(page: Int, _ size: Int = 20, success: @escaping HTTPSuccessClosure, failure: @escaping HTTPFailureClosure) {
        let request = GroupChatListRequest.init()
        request.page = page
        request.size = size
        
        HTTPManager.GET(urlString: LIST_GROUP_CHAT, request: request, success: { data in
            let response = GroupChatListResponse.deserialize(from: data as? [String: Any])
            success(response!)
        }, failure: { error in
            failure(error)
        })
    }
}

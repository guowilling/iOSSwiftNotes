
import Foundation

class VisitorRequest: BaseRequest {
    
    var udid: String?
    
    static func saveOrFindVisitor(success: @escaping HTTPSuccessClosure, failure: @escaping HTTPFailureClosure) {
        let request = VisitorRequest.init()
        request.udid = UDID
        
        HTTPManager.POST(urlString: CREATE_VISITOR_BY_UDID, request: request, success: { data in
            let response = VisitorResponse.deserialize(from: data as? [String:Any])
            success(response!)
        }, failure: { error in
            failure(error)
        })
    }
}

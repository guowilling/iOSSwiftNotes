
import Foundation

class BaseResponse: BaseModel {
    var code: Int?
    var message: String?
    var has_more: Int = 0
    var total_count: Int = 0
}

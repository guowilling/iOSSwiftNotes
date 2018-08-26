
import Foundation

extension Bundle {
    // 计算型属性: 1.没有参数; 2.有返回值; 3.返回值自动设置给属性
    var namespace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}

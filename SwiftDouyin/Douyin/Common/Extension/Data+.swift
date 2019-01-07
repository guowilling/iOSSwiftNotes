
import Foundation

extension Data {
    
    func subdata(in range: CountableClosedRange<Data.Index>) -> Data {
        return self.subdata(in: range.lowerBound..<range.upperBound + 1)
    }
}

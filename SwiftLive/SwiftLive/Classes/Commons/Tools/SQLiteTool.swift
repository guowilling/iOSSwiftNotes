
import UIKit

class SQLiteTool: NSObject {
    fileprivate static var db: OpaquePointer? = nil
}

extension SQLiteTool {
    @discardableResult
    class func openDB(_ filePath: String) -> Bool {
        let cFilePath = filePath.cString(using: String.Encoding.utf8)!
        return sqlite3_open(cFilePath, &db) == SQLITE_OK
    }
}

extension SQLiteTool {
    @discardableResult
    class func execSQL(_ sqlString: String) -> Bool {
        let cSQLString = sqlString.cString(using: String.Encoding.utf8)!
        return sqlite3_exec(db, cSQLString, nil, nil, nil) == SQLITE_OK
    }
}

extension SQLiteTool {
    class func querySQL(_ sqlString: String) -> [[String: Any]] {
        var stmt: OpaquePointer? = nil
        sqlite3_prepare_v2(db, sqlString.cString(using: String.Encoding.utf8)!, -1, &stmt, nil)
        let count = sqlite3_column_count(stmt)
        var resultArray = [[String: Any]]()
        while sqlite3_step(stmt) == SQLITE_ROW {
            var dict = [String: Any]()
            for i in 0..<count {
                let key = String(cString: sqlite3_column_name(stmt, i), encoding: String.Encoding.utf8)!
                let value = sqlite3_column_text(stmt, i)
                let valueStr = String(cString: value!)
                dict[key] = valueStr
            }
            resultArray.append(dict)
        }
        return resultArray
    }
}

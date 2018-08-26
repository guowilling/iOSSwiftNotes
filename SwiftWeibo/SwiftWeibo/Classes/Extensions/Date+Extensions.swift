
import Foundation

private let dateFormatter = DateFormatter()

private let calendar = Calendar.current

extension Date {
    /// 得到和当前系统时间偏差 delta 秒数的日期字符串.(Swift 中如果要定义结构体的'类'函数, 使用 static 修饰 -> 静态函数)
    static func wb_dateString(delta: TimeInterval) -> String {
        let date = Date(timeIntervalSinceNow: delta)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    /// 新浪返回的时间字符串 -> 日期
    ///
    /// - parameter string: Tue Sep 15 12:12:00 +0800 2015
    ///
    /// - returns: 日期
    static func wb_sinaDate(string: String) -> Date? {
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        dateFormatter.locale = Locale.init(identifier:"en_US")
        let date = dateFormatter.date(from: string);
        //return date?.addingTimeInterval(3600 * 8);
        return date;
    }
    
    // 刚刚(一分钟内)
    // X分钟前(一小时内)
    // X小时前(当天)
    // 昨天 HH:mm(昨天)
    // MM-dd HH:mm(一年内)
    // yyyy-MM-dd HH:mm(更早期)
    var cz_dateDescription: String {
        // 今天
        if calendar.isDateInToday(self) {
            let delta = -Int(self.timeIntervalSinceNow)
            if delta < 60 {
                return "刚刚"
            }
            if delta < 3600 {
                return "\(delta / 60)分钟前"
            }
            return "\(delta / 3600)小时前"
        }
        
        // 其他天
        var format = " HH:mm"
        if calendar.isDateInYesterday(self) {
            format = "昨天" + format
        } else {
            format = "MM-dd" + format
            let year = calendar.component(.year, from: self)
            let thisYear = calendar.component(.year, from: Date())
            if year != thisYear {
                format = "yyyy-" + format
            }
        }
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

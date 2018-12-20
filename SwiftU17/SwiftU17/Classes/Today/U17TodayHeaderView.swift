
import UIKit

class U17TodayHeaderView: UITableViewHeaderFooterView {
    
    lazy var weekLabel: UILabel = {
        let label = UILabel()
        label.text = "星期日"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "07月22日"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        self.addSubview(self.timeLabel)
        self.timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.equalTo(20)
            make.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        self.addSubview(self.weekLabel)
        self.weekLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.timeLabel.snp.bottom)
            make.left.equalTo(self.timeLabel.snp.left)
            make.right.equalTo(self.timeLabel.snp.right)
            make.height.equalTo(45)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var dayDataModel: DayItemDataListModel? {
        didSet {
            guard let model = dayDataModel else {
                return
            }
            self.weekLabel.text = model.weekDay
            
            let time = (model.timeStamp! as NSString).intValue
            let timeDate = NSDate.init(timeIntervalSince1970: TimeInterval(time))
            self.timeLabel.text = dateFromString(date: timeDate as Date)
        }
    }
    
    func dateFromString(date: Date, dateFormat: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
    }
}

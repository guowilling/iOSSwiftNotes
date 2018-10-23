
private let ProfileItemCellID = "ProfileItemCell"

import UIKit

class ProfileBaseViewController: UIViewController {
    
    lazy var mainTableView: UITableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
    
    lazy var sections: [ProfileItemSectionModel] = [ProfileItemSectionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupItemData()
    }
}

extension ProfileBaseViewController {
    @objc func setupUI() {
        mainTableView.frame = view.bounds
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.rowHeight = 50
        mainTableView.separatorStyle = .none
        mainTableView.register(UINib(nibName: "ProfileItemCell", bundle: nil), forCellReuseIdentifier: ProfileItemCellID)
        view.addSubview(mainTableView)
    }
    
    @objc func setupItemData() { }
}

extension ProfileBaseViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileItemCellID, for: indexPath) as! ProfileItemCell
        let section = sections[indexPath.section]
        cell.itemModel = section.items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

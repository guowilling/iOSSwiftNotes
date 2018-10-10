
private let kProfileItemCellID = "profileItemCellID"

import UIKit

class ProfileBaseViewController: UIViewController {

    lazy var tableView: UITableView = UITableView()
    
    lazy var sections: [ProfileItemSectionModel] = [ProfileItemSectionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupItemData()
    }
}

extension ProfileBaseViewController {
    
    @objc func setupUI() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ProfileItemCell", bundle: nil), forCellReuseIdentifier: kProfileItemCellID)
        tableView.separatorStyle = .none
        tableView.rowHeight = 55
        view.addSubview(tableView)
    }
}

extension ProfileBaseViewController {
    
    @objc func setupItemData() {
        
    }
}

extension ProfileBaseViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kProfileItemCellID, for: indexPath) as! ProfileItemCell
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
}

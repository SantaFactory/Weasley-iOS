//
//  SetGroupTableViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/17.
//

import UIKit

class SetGroupTableViewController: UITableViewController {

    let setList = ["Home", "School", "Work", "Leave Group"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Group"
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.reuseID)
    }
    
}

//MARK: Tabel view data source
extension SetGroupTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //TODO: Return Group count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.reuseID, for: indexPath)
        let listItem = setList[indexPath.row]
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = listItem
        } else {
            cell.textLabel?.text = listItem
        }
        return cell
    }
}

//MARK: Tabel view delegate
extension SetGroupTableViewController {
    
}

//
//  NotificationsTableViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/17.
//

import UIKit

class NotificationsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notifications"
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.reuseID)
    }
}

//MARK: Tabel view data source
extension NotificationsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.reuseID, for: indexPath)
        return cell
    }
}

//MARK: Tabel view delegate
extension NotificationsTableViewController {
    
}

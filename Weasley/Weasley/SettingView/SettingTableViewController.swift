//
//  SettingTableViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/07.
//

import UIKit

class SettingTableViewController: UITableViewController {

    struct Setting {
        let title: String
        let image: UIImage
        let color: UIColor
        let destination: UIViewController?
    }
    
    //let settingList = ["Profile", "Group", "Notifications", "General"]
    let settingList = [
        Setting(
            title: "Profile",
            image: UIImage(systemName: "person.fill")!,
            color: .systemBlue,
            destination: ProfileViewController()
        ),
        Setting(
            title: "Groups",
            image: UIImage(systemName: "person.3.fill")!,
            color: .systemGreen,
            destination: SetGroupTableViewController()
        ),
        Setting(
            title: "Notifications",
            image: UIImage(systemName: "bell.badge.fill")!,
            color: .systemRed,
            destination: NotificationsTableViewController()
        ),
        Setting(
            title: "General",
            image: UIImage(systemName: "gearshape.2.fill")!,
            color: .systemGray,
            destination: nil
        )]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Setting"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.reuseID)
    }

}

// MARK: Table view data source
extension SettingTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.reuseID, for: indexPath)
        let setting = settingList[indexPath.row]
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.image = setting.image
            content.text = setting.title
            content.imageProperties.tintColor = setting.color
            cell.contentConfiguration = content
        } else {
            cell.imageView?.image = setting.image
            cell.imageView?.tintColor = setting.color
            cell.textLabel?.text = setting.title
        }
        return cell
    }
}
// MARK: Table view delegate
extension SettingTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = settingList[indexPath.row]
        guard let destinationVC = setting.destination else {
            return
        }
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

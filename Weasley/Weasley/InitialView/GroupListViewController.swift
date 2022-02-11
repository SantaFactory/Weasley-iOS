//
//  GroupViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/18.
//

import UIKit
import SnapKit

class GroupListViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let viewModel = UsersGroups.shared
    var alert: UIAlertController?
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .secondarySystemBackground
        self.view.addSubview(groupTableView)
        self.view.addSubview(toolbar)
        self.view.addSubview(activityIndicatorView)
        groupTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeArea.bottom)
        }
        toolbar.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeArea.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        activityIndicatorView.snp.makeConstraints { make in
            make.centerX.equalTo(toolbar)
            make.centerY.equalTo(toolbar)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.startAnimating()
        title = "My Group".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = UIColor.themeGreen
        groupTableView.dataSource = self
        groupTableView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(goSetting))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appDelegate.locationManager.requestWhenInUseAuthorization()
        appDelegate.locationManager.requestLocation()
        viewModel.loadGroups {
            self.groupTableView.reloadData()
            self.activityIndicatorView.stopAnimating()
        }
    }
   
    //MARK: Menu iOS 14.0..<
    private lazy var menu: UIMenu = {
        return UIMenu(title: "", options: [], children: menuItems)
    }()
    
    private lazy var menuItems: [UIAction] = {
        return [
            UIAction(title: "Create a new group".localized, image: UIImage(systemName: SystemImage.add.name), handler: { _ in
                self.addGroup()
            }),
            UIAction(title: "Join a group with key".localized, image: UIImage(systemName: SystemImage.key.name), handler: { _ in
                self.joinGroup()
            })
        ]
    }()
    
    //MARK: Menu ...iOS 13.0
    private lazy var alertAddGroupActions: [UIAlertAction] = {
        return [
            UIAlertAction(title: "Create a new group".localized, style: .default, handler: { _ in
                self.addGroup()
            }),
            UIAlertAction(title: "Join a group with key".localized, style: .default, handler: { _ in
                self.joinGroup()
            }),
            UIAlertAction(title: "Cancel".localized, style: .cancel)
        ]
    }()
    
    private lazy var groupTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: GroupTableViewCell.reuseID)
        return tableView
    }()
    
    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.isTranslucent = true
        toolbar.setItems([profileButton, flexibleSpace, addButton], animated: true)
        toolbar.tintColor = .themeGreen
        return toolbar
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        if #available(iOS 14.0, *) {
            return UIBarButtonItem(image: UIImage(systemName: SystemImage.addFill.name), menu: menu)
        } else {
            return UIBarButtonItem(image: UIImage(systemName: SystemImage.addFill.name), style: .plain, target: self, action: #selector(showActionSheet))
        }
    }()
    
    private lazy var flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    private lazy var profileButton = UIBarButtonItem(image: UIImage(systemName: SystemImage.profile.name), style: .plain, target: self, action: #selector(setProfile))
    private lazy var activityIndicatorView = UIActivityIndicatorView()
}

//MARK: Button Action
extension GroupListViewController {
    
    @objc private func goSetting() {
        let destinationVC = SettingTableViewController()
        destinationVC.modalPresentationStyle = .formSheet
        present(destinationVC, animated: true, completion: nil)
    }
    
    @objc private func showActionSheet() {
        alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for action in alertAddGroupActions {
            alert?.addAction(action)
        }
        self.present(alert!, animated: true, completion: nil)
    }
    
    @objc func addGroup() {
        let destinationVC = SetGroupNameViewController()
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @objc func joinGroup() {
        alert = UIAlertController(title: "Join a Group", message: "Add a key.", preferredStyle: .alert)
        let join = UIAlertAction(title: "Join".localized, style: .default) { [self] _ in
            guard let key = self.alert?.textFields![0].text else {
                return
            }
            //TODO: Join group API
            print(key)
        }
        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel)
        alert?.addTextField { [weak self] textField in
            textField.placeholder = "Key"
            textField.addTarget(self, action: #selector(self?.alertTextFieldDidChange), for: UIControl.Event.editingChanged)
        }
        alert?.addAction(join)
        alert?.addAction(cancel)
        join.isEnabled = false
        self.present(alert!, animated: true, completion: nil)
    }
    
    @objc func alertTextFieldDidChange(_ sender: UITextField) {
           alert?.actions[0].isEnabled = sender.text!.count > 0
    }
    
    @objc func setProfile() {
        let destinationVC = ProfileViewController()
        destinationVC.modalPresentationStyle = .pageSheet
        present(destinationVC, animated: true, completion: nil)
    }
}

//MARK: Table view data source
extension GroupListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groups?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.reuseID, for: indexPath) as! GroupTableViewCell
        cell.groupNameLabel.text = viewModel.groups?[indexPath.row].name
        cell.groupCountOfMember.text = "\(viewModel.groups?[indexPath.row].countOfMemeber ?? 1)"
        return cell
    }
}

//MARK: Table view delegate
extension GroupListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let destinationVC = DetailViewController(viewModel: Detail(group: viewModel.groups![indexPath.row]))
        destinationVC.modalPresentationStyle = .currentContext
        showDetailViewController(destinationVC, sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: nil) { (action, view, completion) in
            let alert = UIAlertController(title: nil, message: "Are you sure you want to leave this group? If you do, you must be invited to join the group again.".localized, preferredStyle: .actionSheet)
            let delete = UIAlertAction(title: "Leave a group".localized, style: .destructive) { [weak self] _ in
                let id = self?.viewModel.groups![indexPath.row].id
                self?.viewModel.deleteGroup(groupID: id!) {
                    self?.viewModel.loadGroups {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
            let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel) { _ in
                completion(false)
            }
            alert.addAction(delete)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        delete.image = UIImage(systemName: SystemImage.delete.name)?.withTintColor(.white)
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}

//MARK: Table view cell
class GroupTableViewCell: UITableViewCell {
    
    static let reuseID = "GroupTableViewCellReuseID"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(groupCountOfMember)
        contentView.addSubview(groupNameLabel)
        groupCountOfMember.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
        groupNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.lessThanOrEqualTo(groupCountOfMember.snp.leading).offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var groupNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .black)
        label.textColor = .themeGreen
        return label
    }()
    
    fileprivate lazy var groupCountOfMember: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .secondaryLabel
        return label
    }()
    
}

//
//  GroupViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/18.
//

import UIKit
import SnapKit
import Hero

class GroupListViewController: UIViewController {
    
    let viewModel = UsersGroups.shared
    let gradientLayer = CAGradientLayer()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .secondarySystemBackground
        self.view.addSubview(groupTableView)
        self.view.addSubview(addGroupButton)
        addGroupButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeArea.bottom).offset(-10)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
        }
        groupTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(addGroupButton.snp.top)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Band"
        navigationController?.navigationBar.prefersLargeTitles = true
        groupTableView.dataSource = self
        groupTableView.delegate = self
        if #available(iOS 14.0, *) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menu)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(showActionSheet))
        }
    }
   
    //MARK: Menu iOS 14.0..<
    private lazy var menu: UIMenu = {
        return UIMenu(title: "", options: [], children: menuItems)
    }()
    
    private lazy var menuItems: [UIAction] = {
        return [
            UIAction(title: "Setting", image: UIImage(systemName: "gearshape.fill"), handler: { _ in
                self.goSetting()
            }),
            UIAction(title: "Sign Out", image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), handler: { _ in
                self.signOut()
            })
        ]
    }()
    
    //MARK: Menu ...iOS 13.0
    private lazy var alertActions: [UIAlertAction] = {
        return [
            UIAlertAction(title: "Setting", style: .default, handler: { _ in
                self.goSetting()
            }),
            UIAlertAction(title: "Sign Out", style: .default, handler: { _ in
                self.signOut()
            }),
            UIAlertAction(title: "Cancel", style: .cancel)
        ]
    }()
    
    private lazy var groupTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: GroupTableViewCell.reuseID)
        return tableView
    }()
    
    private lazy var addGroupButton: UIButton = {
        let button = UIButton(type: .system)
        gradientLayer.getGradientLayer(
            colors: UIColor().themeColors,
            alpha: 1,
            frame: self.view.bounds,
            startPoint: CGPoint(x: 0.0, y: 0.5),
            endPoint: CGPoint(x: 1.0, y: 0.5)
        )
        let color = UIColor.gradientColor(bounds: self.view.bounds, gradientLayer: gradientLayer)
        button.tintColor = color
        button.setTitle("Add Group", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .black)
        button.backgroundColor = .systemBackground
        button.addTarget(self, action: #selector(addGroup), for: .touchUpInside)
        button.layer.borderWidth = 2
        button.layer.borderColor = color?.cgColor
        return button
    }()
}

//MARK: Button Action
extension GroupListViewController {
    
    func signOut() {
        Login().signOut()
        dismiss(animated: true, completion: nil)
    }
    
    func goSetting() {
        let destinationVC = SettingTableViewController()
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    @objc private func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for action in alertActions {
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func addGroup() {
        let destinationVC = SetGroupNameViewController()
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

//MARK: Table view data source
extension GroupListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groups?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.reuseID, for: indexPath) as! GroupTableViewCell
        let gradientLayer = CAGradientLayer()
        gradientLayer.getGradientLayer(
            colors: UIColor().themeColors,
            alpha: 0.6,
            frame: tableView.bounds,
            startPoint: CGPoint(x: 0.0, y: 0.5),
            endPoint: CGPoint(x: 1.0, y: 0.5)
        )
        cell.groupNameLabel.backgroundColor = .gradientColor(bounds: tableView.bounds, gradientLayer: gradientLayer)
        cell.groupNameLabel.text = viewModel.groups?[indexPath.row].name
        return cell
    }
}

//MARK: Table view delegate
extension GroupListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let destinationVC = MainViewController()
        destinationVC.modalPresentationStyle = .overFullScreen
        present(destinationVC, animated: true, completion: nil)
        //navigationController?.pushViewController(destinationVC, animated: true)
    }
}

//MARK: Table view cell
class GroupTableViewCell: UITableViewCell {
    
    static let reuseID = "GroupTableViewCellReuseID"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(groupNameLabel)
        groupNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate lazy var groupNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40, weight: .black)
        label.textColor = .white
        label.textAlignment = .center
        label.hero.id = "main"
        return label
    }()
    
}

//
//  GroupViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/18.
//

import UIKit
import SnapKit

class GroupViewController: UIViewController {

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .secondarySystemBackground
        self.view.addSubview(groupTableView)
        self.view.addSubview(addGroupButton)
        addGroupButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeArea.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
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
    }
    
    private lazy var groupTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: GroupTableViewCell.reuseID)
        return tableView
    }()
    
    private lazy var addGroupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Group", for: .normal)
        button.addTarget(self, action: #selector(addGroup), for: .touchUpInside)
        return button
    }()
}

extension GroupViewController {
    @objc func addGroup() {
        let destinationVC = InitialViewController()
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension GroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.reuseID, for: indexPath)
        return cell
    }
}

extension GroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

class GroupTableViewCell: UITableViewCell {
    
    static let reuseID = "GroupTableViewCellReuseID"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bandNameLabel)
        bandNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var bandNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello World!"
        label.font = UIFont.systemFont(ofSize: 40, weight: .black)
        label.textAlignment = .center
        return label
    }()
    
}

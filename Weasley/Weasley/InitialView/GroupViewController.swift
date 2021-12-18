//
//  GroupViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/18.
//

import UIKit
import SnapKit
import Hero
import SwiftUI

class GroupViewController: UIViewController {
    
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
            //make.centerX.equalToSuperview()
            //make.height.equalTo(50)
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

extension GroupViewController {
    @objc func addGroup() {
        let destinationVC = InitialViewController()
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

//MARK: Table view data source
extension GroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
        return cell
    }
}

//MARK: Table view delegate
extension GroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let destinationVC = MainViewController()
        navigationController?.pushViewController(destinationVC, animated: true)
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
        label.text = "Hello World!"
        label.font = UIFont.systemFont(ofSize: 40, weight: .black)
        label.textColor = .white
        label.textAlignment = .center
        label.hero.id = "Main"
        return label
    }()
    
}

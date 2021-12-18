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
        self.view.addSubview(addGroupButton)
        addGroupButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeArea.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
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

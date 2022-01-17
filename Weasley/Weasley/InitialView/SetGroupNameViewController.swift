//
//  InitialViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/14.
//

import UIKit
import SnapKit

class SetGroupNameViewController: UIViewController {

    let viewModel = UsersGroups.shared
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(titleLabel)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(groupNameTextField)
        self.view.addSubview(nextButton)
        self.view.backgroundColor = .systemBackground
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeArea.top).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(groupNameTextField.snp.top).offset(-20)
        }
        groupNameTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(groupNameTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupNameTextField.delegate = self
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 28)
        label.text = "Create Group".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "Pick a groupname for your group. You can always change it later.".localized
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var groupNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Groupname".localized
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.returnKeyType = .next
        textField.backgroundColor = .secondarySystemBackground
        return textField
    }()

    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next".localized, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = .themeGreen
        button.defaultAction()
        button.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        return button
    }()
    
}

//MARK: Action
extension SetGroupNameViewController {
    @objc func goNext(_ sender: UIButton?) {
        sender?.alpha = 1
        guard let groupName = groupNameTextField.text else {
            return
        }
        if groupName.isEmpty {
            showAlert()
        }
        pushView()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Group name is blank".localized, message: "Show nothing about your group name.".localized, preferredStyle: .alert)
        let okay = UIAlertAction(title: "OK".localized, style: .default) { _ in
            self.pushView()
        }
        let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel)
        alert.addAction(okay)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func pushView() {
        let destinationVC = SetHomeViewController()
        viewModel.newGroup = Group(name: groupNameTextField.text ?? "", places: [])
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}
extension SetGroupNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        goNext(nil)
        return false
    }
}

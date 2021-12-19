//
//  InitialViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/14.
//

import UIKit
import SnapKit

class InitialViewController: UIViewController {

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
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(groupNameTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(44)
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
        label.text = "Create Group"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "Pick a groupname for your group. You can always change it later."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var groupNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Groupname"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.returnKeyType = .next
        textField.backgroundColor = .secondarySystemBackground
        return textField
    }()

    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        return button
    }()
    
    @objc func goNext() {
        guard let groupName = groupNameTextField.text else {
            return
        }
        if groupName.isEmpty {
            showAlert()
        }
        let destinationVC = SetHomeViewController()
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}

extension InitialViewController {
    func showAlert() {
        let alert = UIAlertController(title: "Group name is blank", message: "Show nothing about your group name.", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Ok", style: .default) { _ in
            let destinationVC = SetHomeViewController()
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okay)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}
extension InitialViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        goNext()
        return false
    }
}

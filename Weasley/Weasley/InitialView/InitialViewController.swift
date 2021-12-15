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
        self.view.addSubview(setGroupTextField)
        self.view.addSubview(setButton)
        self.view.addSubview(skipButton)
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
            make.bottom.equalTo(setGroupTextField.snp.top).offset(-20)
        }
        setGroupTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        setButton.snp.makeConstraints { make in
            make.top.equalTo(setGroupTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        }
        skipButton.snp.makeConstraints { make in
            make.top.equalTo(setButton.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    lazy var setGroupTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Groupname"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.backgroundColor = .secondarySystemBackground
        return textField
    }()

    lazy var setButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .blue
        //button.addTarget(self, action: <#T##Selector#>, for: .touchUpInside)
        return button
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(skip), for: .touchUpInside)
        return button
    }()
    
    @objc func setGroup() {
        //MARK: Set Group Action
    }

    @objc func skip() {
        let destinationVC = MainViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: true, completion: nil)
    }
}

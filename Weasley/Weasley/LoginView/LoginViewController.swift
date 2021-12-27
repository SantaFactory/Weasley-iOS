//
//  SiginViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/10/26.
//

import UIKit
import SnapKit
import AuthenticationServices

class LoginViewController: UIViewController {

    let viewModel = Login()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(appleLoginButton)
        self.view.addSubview(googleLoginButton)
        appleLoginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        googleLoginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.bottom.equalTo(appleLoginButton.snp.top).offset(-10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.autoLogin {
            self.successLogin()
        }
    }
    
    private lazy var googleLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.2745098039, green: 0.5333333333, blue: 0.9333333333, alpha: 1)
        button.layer.cornerRadius = 5
        button.setTitle("Continue with Google", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.tintColor = .white
        button.addTarget(self, action: #selector(googleLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        return button
    }()
    
    @objc private func googleLogin() {
        self.successLogin()
//        viewModel.googleLogin(vc: self) {
//            self.successLogin()
//        }
    }
    
    private func successLogin() {
        let destinationVC = GroupListViewController()
        let navController = UINavigationController(rootViewController: destinationVC)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
}

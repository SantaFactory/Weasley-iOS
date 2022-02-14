//
//  SiginViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/10/26.
//

import UIKit
import SnapKit
import Firebase
import GoogleSignIn
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
//        viewModel.autoLogin {
//            self.successLogin()
//        }
    }
    
    private lazy var googleLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.2745098039, green: 0.5333333333, blue: 0.9333333333, alpha: 1)
        button.layer.cornerRadius = 5
        button.setTitle("Sign in with Google".localized, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.tintColor = .white
        button.addTarget(self, action: #selector(googleLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(appleLogin), for: .touchUpInside)
        return button
    }()
    
    @objc private func googleLogin() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
            guard error == nil else {
                print("Error\(error?.localizedDescription ?? "Can't find error")")
                return
            }
            guard let user = user else { return }
            user.authentication.do { authentication, error in
                guard error == nil else { return }
                guard let authentication = authentication else { return }
                
                guard let idToken = authentication.idToken else {
                    print("Control idToken is nil")
                    return
                }
                let token = Token(token: idToken)
                self.viewModel.login(token: token) {
                    self.successLogin()
                }
            }
        }
    }
    
    @objc private func appleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func successLogin() {
        let destinationVC = GroupListViewController()
        let navController = UINavigationController(rootViewController: destinationVC)
        navController.modalPresentationStyle = .currentContext
        self.present(navController, animated: true, completion: nil)
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let accessToken = String(data: appleIDCredential.identityToken!, encoding: .ascii) ?? ""
            viewModel.login(token: Token(token: accessToken)) {
                self.successLogin()
            }
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

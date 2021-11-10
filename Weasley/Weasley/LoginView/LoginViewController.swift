//
//  SiginViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/10/26.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {

    let viewModel = Login()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(googleLoginButton)
        googleLoginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.autoLogin {
            self.presentMain()
        }
    }
    
    private lazy var googleLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.2745098039, green: 0.5333333333, blue: 0.9333333333, alpha: 1)
        button.layer.cornerRadius = 25
        button.setTitle("Continue with Google", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(googleLogin), for: .touchUpInside)
        return button
    }()
    
    @objc private func googleLogin() {
        viewModel.googleLogin {
            self.presentMain()
        }
    }
    
    private func presentMain() {
        let destinationVC = MainViewController()
        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: true, completion: nil)
    }
//    private func autoLogin() {
//        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
//            if error == nil || user != nil {
//                let destinationVC = MainViewController()
//                destinationVC.modalPresentationStyle = .fullScreen
//                self.present(destinationVC, animated: true, completion: nil)
//            } else {
//                print("Signed-Out State")
//            }
//        }
//    }

}

//extension LoginViewController {
//
//    @objc private func googleLogin() {
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
//            guard error == nil else {
//                print("Error\(error?.localizedDescription ?? "Can't find error")")
//                return
//            }
//            guard let user = user else { return }
//            user.authentication.do { authentication, error in
//                guard error == nil else { return }
//                guard let authentication = authentication else { return }
//
//                guard let idToken = authentication.idToken else {
//                    print("Control idToken is nil")
//                    return
//                }
//                //MARK: Sample Code [성공]
//                //                APIManager().signInExample(idToken: idToken) { userInfo in
//                //                    DispatchQueue.main.async {
//                //                        switch userInfo {
//                //                        case .failure:
//                //                            print("fail")
//                //                            GIDSignIn.sharedInstance.signOut()
//                //                        case .success:
//                //                            print("success")
//                //                            do {
//                //                                let value = try userInfo.get()
//                //                                APIManager().performSendUser(user: value) {
//                //                                    DispatchQueue.main.async {
//                //                                        let destinationVC = MainViewController()
//                //                                        destinationVC.modalPresentationStyle = .fullScreen
//                //                                        self.present(destinationVC, animated: true, completion: nil)
//                //                                    }
//                //                                }
//                //                            } catch {
//                //                                print("Error retrieving the value: \(error)")
//                //                            }
//                //                        }
//                //                    }
//                //                }
//                //MARK: 모듈화된 메소드 사용해보기
//                let token = Token(token: idToken)
//                APIManager().performLogin(token: token) { tokenData in
//                    //TODO: 서버로 응답받은 데이터 가공하기
//                    switch tokenData {
//                    case .failure:
//                        print("fail")
//                        GIDSignIn.sharedInstance.signOut()
//                    case .success:
//                        //TODO: User default에 sub & email 저장
//                        do {
//                            let value = try tokenData.get()
//                            APIManager().performRequestUser(user: value) {
//                                DispatchQueue.main.async {
//                                    //TODO: reponse data 저장
//                                    let destinationVC = MainViewController()
//                                    destinationVC.modalPresentationStyle = .fullScreen
//                                    self.present(destinationVC, animated: true, completion: nil)
//                                }
//                            }
//                        } catch {
//                            print("Error retrieving the value: \(error)")
//                        }
//                    }
//                }
//            }
//        }
//    }
//}

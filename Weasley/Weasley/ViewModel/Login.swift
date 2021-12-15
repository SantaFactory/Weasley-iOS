//
//  Login.swift
//  Weasley
//
//  Created by Doyoung on 2021/11/10.
//

import Foundation
import Firebase
import GoogleSignIn
import UIKit

class Login {
    
    let userDefault = UserDefaults.standard
    
    func autoLogin(completion: @escaping () -> Void) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error == nil || user != nil {
                guard let sub = UserDefaults.standard.string(forKey: "userLogin") else {
                    GIDSignIn.sharedInstance.signOut()
                    return
                }
                
                APIManager().performRequestUserLoc(user: Loc(sub: sub)) { res in
                    switch res {
                    case .failure(let message):
                        print(message)
                        self.signOut()
                    case .success(let message):
                        print(message)
                        DispatchQueue.main.async {
                            completion()
                        }
                    }
                }
            } else {
                print("Signed-Out State")
            }
        }
    }
    
    func googleLogin(vc: UIViewController, completion: @escaping () -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: vc) { user, error in
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
                APIManager().performLogin(token: token) { tokenData in
                    switch tokenData {
                    case .failure:
                        print("fail")
                        GIDSignIn.sharedInstance.signOut()
                    case .success:
                        do {
                            let value = try tokenData.get()
                            print(value)
                            self.userDefault.set(value.sub, forKey: "userLogin")// Local에 sub저장
                            APIManager().performRequestUser(user: value) { res in
                                switch res {
                                case .failure(let message):
                                    print("Fail: \(message)")
                                    self.signOut()
                                case .success(let message):
                                    print("Success: \(message)")
                                    APIManager().performRequestUserLoc(user: Loc(sub: value.sub)) { res in
                                        switch res {
                                        case .failure(let message):
                                            print("Fail: \(message)")
                                            self.signOut()
                                        case .success(let message):
                                            print("Success Loc: \(message)")
                                            DispatchQueue.main.async {
                                                completion()
                                            }
                                        }
                                    }
                                }
                                
                            }
//                            APIManager().performRequestUserLoc(user: value) { res in
//                                switch res {
//                                case .failure(let message):
//                                    print("Fail: \(message)")
//                                    self.signOut()
//                                case .success(let message):
//                                    print("Success: \(message)")
//                                    DispatchQueue.main.async {
//                                        completion()
//                                    }
//                                }
//                            }
                        } catch {
                            GIDSignIn.sharedInstance.signOut()
                            print("Error retrieving the value: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func signOut() {
        userDefault.removeObject(forKey: "userLogin")
        GIDSignIn.sharedInstance.signOut()
    }
}

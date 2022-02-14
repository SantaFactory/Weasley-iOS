//
//  Login.swift
//  Weasley
//
//  Created by Doyoung on 2021/11/10.
//

import Foundation

class Login {
    
    let domain: TokenFetchable = TokenStore()

    let userDefault = UserDefaults.standard
    
//    func autoLogin(completion: @escaping () -> Void) {
//        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
//            if error == nil || user != nil {
//                guard let sub = UserDefaults.standard.string(forKey: "userLogin") else {
//                    GIDSignIn.sharedInstance.signOut()
//                    return
//                }
//                //TODO: Request user data
//            } else {
//                print("Signed-Out State")
//            }
//        }
//    }
    
    func login(token: Token, completion: @escaping() -> Void) {
        domain.fetchLoginToken(token: token) { resultToken in
            guard let resultToken = resultToken else {
                return
            }
            authToken = ["Authorization": "Bearer \(resultToken.loginData.accessToken)"]
            refreshToken = ["refreshToken": resultToken.loginData.refreshToken]
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    //TODO: Apple Login
    
//    func signOut() {
//        userDefault.removeObject(forKey: "userLogin")
//        GIDSignIn.sharedInstance.signOut()
//    }
}

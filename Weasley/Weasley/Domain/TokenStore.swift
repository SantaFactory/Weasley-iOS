//
//  TokenStore.swift
//  Weasley
//
//  Created by Doyoung on 2022/02/13.
//

import Foundation

protocol TokenFetchable {
    func fetchLoginToken(token: Token, completion: @escaping (ResultToken?) -> Void)
}

class TokenStore: TokenFetchable {
    
    func fetchLoginToken(token: Token, completion: @escaping (ResultToken?) -> Void) {
        APIService.performLogin(token: token) { result in
            switch result {
            case .success(let data):
                guard let token = try? JSONDecoder().decode(ResultToken.self, from: data) else {
                    return
                }
                completion(token)
            case .failure:
                completion(nil)
            }
        }
    }
    

}

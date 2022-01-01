//
//  LoginAPIService.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/21.
//

import Foundation

class LoginService {
    
    /**
     로그인 URLSession 메소드
      
      Post 방식으로 토큰을 제공하여, 서버로 부터 유효성 검사
      - parameters:
         - token: 로그인을 위한 토큰
         - completion: response시 실행될 메소드
     */
    private let loginURL = "\(url)/login-process"
    
    func performLogin(token: Token, completion: @escaping (Result<ResultToken, APIError>) -> Void) {
        guard let url = URL(string: loginURL) else {
            completion(.failure(.urlNotSupport))
            return
        }
        let resource = Resource<ResultToken>(url: url, method: .post(token), header: nil)
        URLSession(configuration: .default).load(resource) { resultData, _ in
            guard let data = resultData else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }
    }
}

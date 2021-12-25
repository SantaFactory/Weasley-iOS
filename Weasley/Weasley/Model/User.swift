//
//  User.swift
//  Weasley
//
//  Created by Doyoung on 2021/11/02.
//

import Foundation

//MARK: Use for Login..
struct Token: Codable {
    let id_token: String
}

struct ResultToken: Codable {
    let loginData: LoginData
    
    enum CodingKeys: String, CodingKey {
        case loginData = "data"
    }
}

struct LoginData: Codable {
    let email: String
    let sub: String
    let token: String
}

struct User: Codable {
    let sub: String
    let email: String
}

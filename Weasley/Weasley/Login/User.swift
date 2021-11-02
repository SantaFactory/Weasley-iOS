//
//  User.swift
//  Weasley
//
//  Created by Doyoung on 2021/11/02.
//

import Foundation

struct User: Codable {
    let iss: String
    let azp: String
    let sub: String
    let email: String
    let email_verified: Bool
    let at_hash: String
    let nonce: String
    let name: String
    let picture: String
    let given_name: String
    let family_name: String
    let locale: String
    let iat: String
    let exp: String
}

struct Token: Codable {
    let token: String
}

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

struct User: Codable {
    let sub: String
    let email: String
}

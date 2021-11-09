//
//  User.swift
//  Weasley
//
//  Created by Doyoung on 2021/11/02.
//

import Foundation

struct User: Codable {
    let sub: String
    let email: String
}

struct Token: Codable {
    let token: String
}

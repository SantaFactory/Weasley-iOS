//
//  User.swift
//  Weasley
//
//  Created by Doyoung on 2021/11/02.
//

import Foundation

struct User: Codable {
    let info: UserInfo
}

struct UserInfo: Codable {
    let sub: String
    //let email: String
}

struct Token: Codable {
    let token: String
}

//MARK: Sample Model for Post Location
struct Sample: Codable {
    let sub: String
    let lat: String
    let long: String
}

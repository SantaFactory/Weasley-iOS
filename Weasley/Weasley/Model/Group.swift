//
//  Group.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/21.
//

import Foundation

struct UsersGroup: Codable {
    var groupData: [GroupData]
    
    enum CodingKeys: String, CodingKey {
        case groupData = "data"
    }
}

struct GroupData: Codable {
    var countOfMemeber: Int
    var name: String
    var id: Int
    
    enum CodingKeys: String, CodingKey {
        case countOfMemeber = "userCount"
        case name = "title"
        case id
    }
}
struct Group: Codable {
    var name: String
    var places: [Place]
    
    enum CodingKeys: String, CodingKey {
        case name = "title"
        case places = "weasley"
    }
}

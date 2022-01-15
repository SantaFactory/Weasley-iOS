//
//  Group.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/21.
//

import Foundation

struct GroupsList: Codable {
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

struct GroupDetail: Codable {
    var data: DetailData
}

struct DetailData: Codable {
    var id: Int
    var title: String
    var members: [Member]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case members = "weasley"
    }
}

struct Member: Codable {
    var isCurrent: Bool
    var latitude: Double
    var longitude: Double
    var userName: String
}

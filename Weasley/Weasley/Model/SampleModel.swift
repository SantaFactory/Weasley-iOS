//
//  SampleModel.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/24.
//

import Foundation

struct SampleUser {
    let sub: String
    let userEmail: String
}

struct SampleGroup {
    var groupID: String
    var groupName: String
    var members: [SampleMember]
}

struct SampleMember {
    var user: SampleUser
    var places: [SamplePlace]
}

struct SamplePlace: Codable {
    var place: String
    var latitude: String?
    var longitude: String?
    
    enum CodingKeys: String, CodingKey {
        case place = "title"
        case latitude
        case longitude
    }
}

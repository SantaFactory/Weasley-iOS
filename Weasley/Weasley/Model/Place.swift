//
//  Place.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/21.
//

import Foundation

struct Place: Codable {
    var place: String
    var latitude: String?
    var longitude: String?
    
    enum CodingKeys: String, CodingKey {
        case place = "title"
        case latitude
        case longitude
    }
}

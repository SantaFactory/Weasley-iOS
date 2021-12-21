//
//  Group.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/21.
//

import Foundation

struct Group: Codable {
    var name: String
    var places: [Place]
    
    enum CodingKeys: String, CodingKey {
        case name = "title"
        case places = "weasley"
    }
}

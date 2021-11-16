//
//  Location.swift
//  Weasley
//
//  Created by Doyoung on 2021/11/02.
//

import Foundation

enum Location: Codable {
    case home
    case school
    case work
    case motalPeril
    case move
    case playOutside
    case travel
    case lost
}

extension Location {
    var location: Int {
        switch self {
        case .home:
            return .random(in: 271..<315)
        case .school:
            return .random(in: 316..<360)
        case .work:
            return .random(in: 1..<45)
        case .motalPeril:
            return .random(in: 46..<90)
        case .move:
            return .random(in: 91..<135)
        case .playOutside:
            return .random(in: 136..<180)
        case .travel:
            return .random(in: 181..<225)
        case .lost:
            return .random(in: 226..<270)
        }
    }
}

struct UserLoc: Codable {
    let sub: String
    let status: String
    let lat: String
    let long: String
}

struct UserLocCoordinate: Codable {
    let sub: String
    let lat: String
    let long: String
}

struct UserArea: Codable {
    let location: String
}
struct SaveRes: Codable {
    let task: String
}

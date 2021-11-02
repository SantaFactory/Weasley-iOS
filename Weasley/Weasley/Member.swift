//
//  Member.swift
//  Weasley
//
//  Created by Doyoung on 2021/11/02.
//

import Foundation

struct Member {
    var user: String //MARK: User로 변경
    var currentLoction: Location
}

struct Group {
    let id: Int
    var members: [Member]
}

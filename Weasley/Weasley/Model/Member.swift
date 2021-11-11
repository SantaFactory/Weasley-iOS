//
//  Member.swift
//  Weasley
//
//  Created by Doyoung on 2021/11/02.
//

import Foundation

struct Member {
    var user: UserInfo
    var currentLoction: Location
}

struct Group {
    let id: Int
    var members: [Member]
}

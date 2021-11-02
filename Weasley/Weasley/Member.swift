//
//  Member.swift
//  Weasley
//
//  Created by Doyoung on 2021/11/02.
//

import Foundation

struct Member {
    let user: String //MARK: User로 변경
    let location = [1,2,3,4,5,6,7,8] //MARK: Location으로 변경
    let currentLoction: Int
}

struct Group {
    let id: Int
    let members: [Member]
}

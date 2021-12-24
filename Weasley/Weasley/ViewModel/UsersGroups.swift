//
//  UsersGroups.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/24.
//

import Foundation

class UsersGroups {
    
    static let shared = UsersGroups()
    init() { }
    
    var groups: [Group]?
    
    func loadGroups() {
        //TODO: API Service
    }
    
    func addGroup(group: Group, completion: @escaping () -> Void) {
        //TODO: Complete API
        GroupAPIService().performAddGroup(group: group) { [weak self] _ in
            completion()
        }
    }
    
    func removeGroup() {
        //TODO: Complete API
    }
}

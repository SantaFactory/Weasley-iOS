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
    
    func loadGroups(completion: @escaping () -> Void) {
        //TODO: API Service
        GroupAPIService().performLoadGroups { [weak self] _ in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
   
    func addGroup(group: Group, completion: @escaping () -> Void) {
        //TODO: Complete API
    }
    
    func removeGroup() {
        //TODO: Complete API
    }
}

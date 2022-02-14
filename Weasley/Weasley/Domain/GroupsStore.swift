//
//  GroupStore.swift
//  Weasley
//
//  Created by Doyoung on 2022/02/13.
//

import Foundation

protocol GroupsFetchable {
    func fetchGroups(completion: @escaping (GroupsList?) -> Void)
    func deleteGroup(id: Int, completion: @escaping (Bool?) -> Void)
    func createGroup(group: Group, completion: @escaping(Group?) -> Void)
}

class GroupsStore: GroupsFetchable {
    
    func createGroup(group: Group, completion: @escaping (Group?) -> Void) {
        APIService.performAddGroup(group: group) { result in
            switch result {
            case .success(let data):
                guard let resultGroup = try? JSONDecoder().decode(Group.self, from: data) else {
                    return
                }
                completion(resultGroup)
            case .failure(.expirationToken):
                completion(nil)
            case .failure:
                break
            }
        }
    }
    
    func fetchGroups(completion: @escaping (GroupsList?) -> Void) {
        APIService.performLoadGroups { result in
            switch result {
            case .success(let data):
                guard let groups = try? JSONDecoder().decode(GroupsList.self, from: data) else {
                    return
                }
                completion(groups)
            case .failure(.expirationToken):
                completion(nil)
            case .failure:
                break
            }
        }
    }
    
    func deleteGroup(id: Int, completion: @escaping (Bool?) -> Void) {
        APIService.performDeleteGroup(id: id) { result in
            switch result {
            case .success:
                completion(true)
            case .failure(.expirationToken):
                completion(false)
            case .failure:
                completion(nil)
            }
        }
    }
    
    
}

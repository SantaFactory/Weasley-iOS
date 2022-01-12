//
//  GroupAPIService.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/21.
//

import Foundation

class GroupAPIService {
    
    private let loadGroupsURL = "\(url)/api/band/self"
    private let createGroupURL = "\(url)/api/band"
    private let deleteGroupURL = "\(url)/api/band/"
    
    func performLoadGroups(completion: @escaping(Result<GroupsList, APIError>) -> Void) {
        guard let url = URL(string: loadGroupsURL) else {
            completion(.failure(.urlNotSupport))
            return
        }
        let resource = Resource<GroupsList>(url: url, method: .get, header: authToken)
        URLSession(configuration: .default).load(resource) { resultData, _ in
            guard let data = resultData else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }
    }
    
    func performAddGroup(group: Group, completion: @escaping(Result<Group?, APIError>) -> Void) {
        guard let url = URL(string: createGroupURL) else {
            completion(.failure(.urlNotSupport))
            return
        }
        let resource = Resource<Group>(url: url, method: .post(group), header: authToken)
        URLSession(configuration: .default).load(resource) { resultData, _ in
            guard let data = resultData else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }
    }
    
    func performDeleteGroup(id group: Int, completion: @escaping() -> Void) {
        guard let url = URL(string: "\(deleteGroupURL)\(group)") else {
            return
        }
        let resource = Resource<String>(url: url, method: .delete, header: authToken)
        URLSession(configuration: .default).load(resource) { resultData, _ in
            completion()
        }
    }
}


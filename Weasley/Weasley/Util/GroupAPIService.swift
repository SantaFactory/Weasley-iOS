//
//  GroupAPIService.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/21.
//

import Foundation

class GroupAPIService {
    
    private let groupURL = "\(url)/api/band"
    
    func performLoadGroups(completion: @escaping(Result<GroupsList, APIError>) -> Void) {
        guard let url = URL(string: "\(groupURL)/self") else {
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
        guard let url = URL(string: groupURL) else {
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
        guard let url = URL(string: "\(groupURL)/\(group)") else {
            return
        }
        let resource = Resource<String>(url: url, method: .delete, header: authToken)
        URLSession(configuration: .default).load(resource) { resultData, _ in
            completion()
        }
    }
    
    func performLoadMembers(id group: Int, completion: @escaping() -> Void) {
        guard let url = URL(string: "\(groupURL)/\(group)/users") else {
            return
        }
        let resource = Resource<String>(url: url, method: .get, header: authToken)
        URLSession(configuration: .default).load(resource) { resultData, _ in
            completion()
        }
    }
    
    func performLoadGroupDetail(id group: Int, completion: @escaping(Result<GroupDetail, APIError>) -> Void) {
        guard let url = URL(string: "\(groupURL)/\(group)") else {
            return
        }
        let resource = Resource<GroupDetail>(url: url, method: .get, header: authToken)
        URLSession(configuration: .default).load(resource) { resultData, _ in
            guard let data = resultData else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }
    }
}


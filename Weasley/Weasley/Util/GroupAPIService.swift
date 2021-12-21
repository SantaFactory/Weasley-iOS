//
//  GroupAPIService.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/21.
//

import Foundation

class GroupAPIService {
    func performAddGroup(group: Group, completion: @escaping (Result<String?, APIError>) -> Void) {
        guard let url = URL(string: "") else {
            completion(.failure(.urlNotSupport))
            return
        }
        let resource = Resource<String>(url: url, method: .post(group))
        URLSession(configuration: .default).load(resource) { resultData, _ in
            guard let data = resultData else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }
    }
}


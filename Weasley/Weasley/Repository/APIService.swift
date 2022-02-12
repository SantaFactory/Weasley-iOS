//
//  APIService.swift
//  Weasley
//
//  Created by Doyoung on 2022/02/11.
//

import Foundation

class APIService {
    
    /**
    소셜 로그인
      
      소셜(ex: google, apple)로 제공 받은은 토큰을 이용하여 로그인을 진행하게 해줍니다.
      - parameters:
         - token: 소셜로부터 받은 토큰
     */
    static func performLogin(token: Token, completion: @escaping (Result<ResultToken, APIError>) -> Void) {
        guard let url = URL(string: WeasleyURL.login.urlString) else {
            completion(.failure(.urlNotSupport))
            return
        }
        let resource = Resource<ResultToken>(url: url, method: .post(token), header: nil)
        URLSession(configuration: .default).load(resource) { resultData, isSuccess in
            if isSuccess {
                guard let data = resultData else {
                    completion(.failure(.expirationToke))
                    return
                }
                completion(.success(data))
            } else {
                completion(.failure(.urlNotSupport))
            }
        }
    }
    
    /**
    토큰 재발급
      
     토큰 만료시 토큰 재요청하게 해줍니다.
     - parameters:
        - token: refresh token
     */
    static func performRefreshToken(token: [String: String], completion: @escaping (Result<String, APIError>) -> Void) {
        guard let url = URL(string: WeasleyURL.refreshToken.urlString) else {
            return
        }
        let resource = Resource<String>(url: url, method: .post(token), header: nil)
        URLSession(configuration: .default).load(resource) { resultData, _ in
            guard let data = resultData else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }
    }
    
    // FIXME: 업데이트 로케이션 완료하기
    static func performUpdateLocation(currentLocation: UserLocationCoordinate) {
        guard let url = URL(string: WeasleyURL.location.urlString) else {
            return
        }
        let resource = Resource<String>(url: url, method: .put(currentLocation), header: authToken)
        URLSession(configuration: .default).load(resource) { resultData, isSuccess in
            guard let data = resultData else {
                return
            }
        }
    }
    
    /**
    가입된 그룹 가져오기
      
      - 현재 가입된 그룹 리스트를 불러옵니다.
     */
    static func performLoadGroups(completion: @escaping(Result<GroupsList, APIError>) -> Void) {
        guard let url = URL(string: "\(WeasleyURL.group.urlString)/self") else {
            completion(.failure(.urlNotSupport))
            return
        }
        let resource = Resource<GroupsList>(url: url, method: .get, header: authToken)
        URLSession(configuration: .default).load(resource) { resultData, isSuccess in
            if isSuccess {
                guard let data = resultData else {
                    completion(.failure(.expirationToke))
                    return
                }
                completion(.success(data))
            } else {
                completion(.failure(.urlNotSupport))
            }
        }
    }
    
    /**
    새로운 그룹 추가
      
      - 새로운 그룹을 생성하여 추가합니다.
      - parameters:
         - group: 그룹
     */
    static func performAddGroup(group: Group, completion: @escaping(Result<Group?, APIError>) -> Void) {
        guard let url = URL(string: WeasleyURL.group.urlString) else {
            completion(.failure(.urlNotSupport))
            return
        }
        let resource = Resource<Group>(url: url, method: .post(group), header: authToken)
        URLSession(configuration: .default).load(resource) { resultData, isSuccess in
            if isSuccess {
                guard let data = resultData else {
                    completion(.failure(.expirationToke))
                    return
                }
                completion(.success(data))
            } else {
                completion(.failure(.urlNotSupport))
            }
        }
    }
    
    static func performDeleteGroup(id group: Int, completion: @escaping() -> Void) {
        guard let url = URL(string: "\(WeasleyURL.group.urlString)/\(group)") else {
            return
        }
        let resource = Resource<String>(url: url, method: .delete, header: authToken)
        URLSession(configuration: .default).load(resource) { resultData, isSuccess in
            completion()
        }
    }
    
    // FIXME: 로드 맵버 완료하기
    static func performLoadMembers(id group: Int, completion: @escaping() -> Void) {
        guard let url = URL(string: "\(WeasleyURL.group.urlString)/\(group)/users") else {
            return
        }
        let resource = Resource<String>(url: url, method: .get, header: authToken)
        URLSession(configuration: .default).load(resource) { resultData, isSuccess in
            completion()
        }
    }
    
    /**
    그룹 상세 정보
      
      - 그룹에 대한 상세 정보를 불러옵니다.
      - parameters:
         - id: 그룹 아이디, GroupData.id
     */
    static func performLoadGroupDetail(id group: Int, completion: @escaping(Result<GroupDetail, APIError>) -> Void) {
        guard let url = URL(string: "\(WeasleyURL.group.urlString)/\(group)") else {
            return
        }
        let resource = Resource<GroupDetail>(url: url, method: .get, header: authToken)
        URLSession(configuration: .default).load(resource) { resultData, isSuccess in
            if isSuccess {
                guard let data = resultData else {
                    completion(.failure(.expirationToke))
                    return
                }
                completion(.success(data))
            } else {
                completion(.failure(.urlNotSupport))
            }
        }
    }
}

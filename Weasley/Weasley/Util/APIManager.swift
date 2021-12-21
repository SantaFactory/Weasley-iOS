//
//  APIManager.swift
//  Weasley
//
//  Created by Doyoung on 2021/10/29.
//

import Foundation

let url = "http://ec2-3-36-123-250.ap-northeast-2.compute.amazonaws.com:5050"

enum APIError: LocalizedError {
    case urlNotSupport
    case noData
    var errorDescription: String? {
        switch self {
        case .urlNotSupport: return "URL NOT Supported"
        case .noData: return "No Data"
        }
    }
}

class APIManager {
    
    private lazy var session = URLSession(configuration: .default)
    
    
    /**
    사용자 현재 위치 정보를 제공받는 URLSession 메소드
     
     Post 방식으로 sub, lat, long를 제공하여, Resource(= location, ex: 'home', 'work', 'school', 'loast')를 획득
     - parameters:
        - coordinate: 유저 좌표정보(sub, 위도, 경도)
        - completion: response시 실행될 메소드
     */
    func performPostLocation(coordinate: UserLocCoordinate, completion: @escaping (Result<UserArea, APIError>) -> Void) {
        guard let url = URL(string: "\(url)/posts/userCurloc") else {
            completion(.failure(.urlNotSupport))
            return
        }
        let resource = Resource<UserArea>(url: url, method: .post(coordinate))
        session.load(resource) { resultData, _ in
            guard let data = resultData else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }
    }
    
    /**
     사용자 현재 좌표를 서버에 위치 설정 URLSession 메소드
      
      Post 방식으로 sub, lat, long, status를 제공하여, Resource(success or fail)을 얻어 위치정보 저장
      - parameters:
         - loc: 유저 좌표정보(sub, 위도, 경도, 지역)
         - completion: response시 실행될 메소드
     */
    func performSetLocation(loc: UserLoc, completion: @escaping (Result<SaveRes, APIError>) -> Void) {
        guard let url = URL(string: "\(url)/posts/userSaveLoc") else {
            completion(.failure(.urlNotSupport))
            return
        }
        let resource = Resource<SaveRes>(url: url, method: .post(loc))
        session.load(resource) { resultData, _ in
            guard let data = resultData else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }
    }
    
    func performDupLocation(loc: UserLoc, completion: @escaping (Result<SaveRes, APIError>) -> Void) {
        guard let url = URL(string: "\(url)/posts/userSaveLocAgain") else {
            completion(.failure(.urlNotSupport))
            return
        }
        let resource = Resource<SaveRes>(url: url, method: .post(loc))
        session.load(resource) { resultData, _ in
            guard let data = resultData else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }
    }
}

extension URLSession {
    func load<T>(_ resource: Resource<T>, completion: @escaping (T?, Bool) -> Void) {
        dataTask(with: resource.urlRequest) { data, response, error in
            print("Response: \(response)")
            guard error == nil else {
                print(error?.localizedDescription ?? "Unknown Error")
                return
            }
            let resData = String(data: data!, encoding: String.Encoding.utf8) as String?
            print("Data: \(resData)")
            completion(data.flatMap(resource.parseData), true)
        }.resume()
    }

}

struct Resource<T> {
    var urlRequest: URLRequest
    let parseData: (Data) -> T?
}

enum HttpMethod<Body> {
    case get
    case post(Body)
    case put(Body)
    case delete(Body)
}

extension HttpMethod {
    var method: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}

extension Resource where T: Decodable {
    
    /**
     Default GET Request
     
        - Default URLRequest
        - URL을 통해 결과 Data를 Decodable Type으로 파싱됨
     */
    init(url: URL) {
        self.urlRequest = URLRequest(url: url)
        self.parseData = { data in
            try? JSONDecoder().decode(T.self, from: data)
        }
    }
    
    /**
        GET Request with parameters
     
        - URLComponents를 사용하여 "/?name=value" 형태로 변환하여 url 요청
        - Parameter의 입력은 [String: String] dictionary의 형태로 받아, 그 값은 내부에서 URLQueryItem으로 추가
     */
    init(url: String, parameters: [String: String]) {
        var urlComponents = URLComponents(string: url)
        var items = [URLQueryItem]()
        
        for (name, value) in parameters {
            if name.isEmpty {
                continue
            }
            items.append(URLQueryItem(name: name, value: value))
        }
        if items.isEmpty {
            urlComponents?.queryItems = items
        }
        if let requestURL = urlComponents?.url {
            self.urlRequest = URLRequest(url: requestURL)
        } else {
            self.urlRequest = URLRequest(url: URL(string: url)!)
        }
        self.parseData = { data in
            try? JSONDecoder().decode(T.self, from: data)
        }
    }
    
    /**
     Others RESTAPI method
     
     - GET 방식외 method(POST, PUT, DELETE)
     - body값을 Encodable 타입으로 제한하여, data로 변경되도록 JSONEncoder를 사용
     - Content-Type -> application/json으로 설정하여 json data를 가져옴
     
     */
    init<Body: Encodable>(url: URL, method: HttpMethod<Body>) {
        self.urlRequest = URLRequest(url: url)
        self.urlRequest.httpMethod = method.method
        
        switch method {
        case .post(let body), .put(let body), .delete(let body):
            self.urlRequest.httpBody = try? JSONEncoder().encode(body)
            self.urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        default:
            break
        }
        self.parseData = { data in
            try? JSONDecoder().decode(T.self, from: data)
        }
    }
}

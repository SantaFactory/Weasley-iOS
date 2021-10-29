//
//  APIManager.swift
//  Weasley
//
//  Created by Doyoung on 2021/10/29.
//

import Foundation

class APIManager {
    
    enum APIError: LocalizedError {
        case urlNotSupport
        case noData
        var errorDescription: String? {
            switch self {
            case .urlNotSupport: return "URL NOT Supported"
            case .noData: return "Has No Data"
            }
        }
    }

    let url = ""
    
    private lazy var session = URLSession(configuration: .default)
    
    func performGet(completion: @escaping (Result<[TestModel], APIError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.urlNotSupport))
            return
        }
        let resource = Resource<[TestModel]>(url: url)
        session.load(resource) { resultDatas, _ in
            guard let data = resultDatas, !data.isEmpty else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }
    }

    func performPost(completion: @escaping (Result<[TestModel], APIError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.urlNotSupport))
            return
        }
        let resultData = TestModel(test: "")
        let resource = Resource<TestModel>(url: url, method: .post(resultData))
        session.load(resource) { resultData, _ in
            guard let data = resultData else {
                completion(.failure(.noData))
                return
            }
            completion(.success([data]))
        }
    }
//    func performPostToken(idToken: String, completion: @escaping () -> Void) {
//        guard let authData = try? JSONEncoder().encode(["idToken": idToken]) else {
//            return
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
//            // Handle response from your backend.
//        }
//        task.resume()
//    }
}

//extension URLSession {
//    func load<T>(_ resource: Resource<T>, completion: @escaping (T?, Bool) -> Void) {
//
//    }
//}

extension URLSession {
    func load<T>(_ resource: Resource<T>, completion: @escaping (T?, Bool) -> Void) {
        dataTask(with: resource.urlRequest) { data, response, error in
            guard error == nil else {
                return
            }
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

struct TestModel: Codable {
    let test: String
}

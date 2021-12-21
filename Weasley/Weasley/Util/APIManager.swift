//
//  APIManager.swift
//  Weasley
//
//  Created by Doyoung on 2021/10/29.
//

import Foundation

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

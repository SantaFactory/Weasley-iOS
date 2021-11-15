//
//  APIManager.swift
//  Weasley
//
//  Created by Doyoung on 2021/10/29.
//

import Foundation

fileprivate let url = "http://ec2-13-125-188-145.ap-northeast-2.compute.amazonaws.com:9000"

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
    
    
    private lazy var session = URLSession(configuration: .default)
    
//    func performGetLocation(user: String, lat: String, long: String, completion: @escaping (Result<UserInfo, APIError>) -> Void) {
////        guard let url = URL(string: "\(url)tokensignin") else {
////            completion(.failure(.urlNotSupport))
////            return
////        }
//        let location = ["sub": user, "lat": lat, "lon": long]
//        let resource = Resource<UserInfo>(url: url, parameters: location)
//        session.load(resource) { resultDatas, _ in
//            guard let data = resultDatas else {
//                completion(.failure(.noData))
//                return
//            }
//            completion(.success(data))
//        }
//    }
    
    //MARK: User 생성
    func performMakeUser(completion: @escaping () -> Void) {
        guard let url = URL(string: "\(url)/posts/usersloc") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            guard error == nil else {
                print("Error: \(error?.localizedDescription ?? "Error Cant find")")
                return
            }
            completion()
        }
        task.resume()
    }
    
    func performPostLocation(sample: Sample, completion: @escaping (Result<UserLocation, APIError>) -> Void) {
        guard let url = URL(string: "\(url)/posts/userCurloc") else {
            completion(.failure(.urlNotSupport))
            return
        }
        let resource = Resource<UserLocation>(url: url, method: .post(sample))
        session.load(resource) { resultData, _ in
            guard let data = resultData else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }
    }
    
    func performSetLocation(sample: SampleLoc, completion: @escaping (Result<SaveRes, APIError>) -> Void) {
        guard let url = URL(string: "\(url)/posts/userSaveLoc") else {
            completion(.failure(.urlNotSupport))
            return
        }
        let resource = Resource<SaveRes>(url: url, method: .post(sample))
        session.load(resource) { resultData, _ in
            guard let data = resultData else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }
    }
    
    func performLogin(token: Token, completion: @escaping (Result<UserInfo, APIError>) -> Void) {
        guard let url = URL(string: "\(url)/tokensignin") else {
            completion(.failure(.urlNotSupport))
            return
        }
        let resource = Resource<UserInfo>(url: url, method: .post(token))
        session.load(resource) { resultData, _ in
            guard let data = resultData else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }
    }
    
    
    func performRequestUser(user: UserInfo, completion: @escaping () -> Void) {
            guard let url = URL(string: "\(url)/posts/usersloc") else {
                print("url not support")
                return
            }
            print(url)
            let resource = Resource<UserInfo>(url: url, method: .post(user))
            session.load(resource) { resultData, _ in
//                guard let data = resultData else {
//                    print("no data")
//                    return
//                }
                completion()
            }
        }
    /**
     구글에서 제공된 Post 샘플 코드
     
    모듈화 되지 않은 평상시에 사용하던 형태입니다.
        
     ## 구글 공식 문서
     [바로가기](https://developers.google.com/identity/sign-in/ios/backend-auth)
     
     
     - parameters:
        - idToken: FireBase에서 제공받은 idToken
        - completion: response 데이터 가공하기
     */
    func signInExample(idToken: String, completion: @escaping (Result<User, APIError>) -> Void) {
        guard let authData = try? JSONEncoder().encode(Token(token: idToken)) else {
            return
        }
        let url = URL(string: "\(url)/tokensignin")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
            // Handle response from your backend.
            print(error)
            guard error == nil else {
                completion(.failure(.urlNotSupport))
                print("Error: \(error?.localizedDescription ?? "Error Cant find")")
                return
            }
            guard let resultData = data else {
                print("Can't Parsing")
                completion(.failure(.noData))
                return
            }
            let result = self.userParseExample(resultData)
            completion(.success(result!))
        }
        task.resume()
    }
    
    /**
     데이터 파싱 메소드
     
    - 모듈화되지않은 로그인을 위한 데이터 파싱하는 작업입니다.
     - 모듈화된 메소드에서는 URLSession 확장에서 load<T>에서 실행됩니다.
    
     - parameters:
        - data: 파싱할 데이터
     */
    func userParseExample(_ data: Data) -> User? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(User.self, from: data)
            return response
        } catch let error {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
    
}

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

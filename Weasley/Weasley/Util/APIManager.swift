//
//  APIManager.swift
//  Weasley
//
//  Created by Doyoung on 2021/10/29.
//

import Foundation

var authToken: [String: String]?
var refreshToken: [String: String]?

enum APIError: LocalizedError {
    case urlNotSupport
    case noData
    case expirationToken
    var errorDescription: String? {
        switch self {
        case .urlNotSupport: return "URL NOT Supported"
        case .noData: return "No Data"
        case .expirationToken: return "Token is expirated"
        }
    }
}

extension URLSession {
    
     func load(_ resource: Resource, completion: @escaping (Data?, Bool) -> Void) {
         dataTask(with: resource.urlRequest) { data, response, error in
             guard error == nil else {
                 print(error?.localizedDescription ?? "Unknown Error")
                 completion(nil, false)
                 return
             }
             guard let response = response as? HTTPURLResponse else {
                 return
             }
             switch response.statusCode {
             case 200..<300:
                 completion(data, true)
             default:
                 guard let data = data else {
                     completion(nil, false)
                     return
                 }
                 if let failedData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                     if let code = failedData["code"] as? String {
                         if code == "S001" || code == "j003" {
                             completion(nil, true)
                             print("do refresh token")
                         }
                     }
                 }
                 break
             }
             let resData = String(data: data!, encoding: String.Encoding.utf8) as String?
             print("Data: \(resData)")
         }.resume()
     }
    
    
}

struct Resource {
    var urlRequest: URLRequest
}

enum HttpMethod<Body> {
    case get
    case post(Body)
    case put(Body)
    case delete
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

extension Resource {
    
    /**
     Default GET Request
     
        - Default URLRequest
        - URL??? ?????? ?????? Data??? Decodable Type?????? ?????????
     */
    init(url: URL, method: HttpMethod<Any>, header: [String: String]?) {
        self.urlRequest = URLRequest(url: url)
        self.urlRequest.httpMethod = method.method
        if let header = header {
            for (key, value) in header {
                self.urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
    }
    
    /**
        GET Request with parameters
     
        - URLComponents??? ???????????? "/?name=value" ????????? ???????????? url ??????
        - Parameter??? ????????? [String: String] dictionary??? ????????? ??????, ??? ?????? ???????????? URLQueryItem?????? ??????
     */
    init(url: String, parameters: [String: String], header: [String: String]?) {
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
        if let header = header {
            for (key, value) in header {
                self.urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
    }
    
    /**
     Others RESTAPI method
     
     - GET ????????? method(POST, PUT)
     - body?????? Encodable ???????????? ????????????, data??? ??????????????? JSONEncoder??? ??????
     - Content-Type -> application/json?????? ???????????? json data??? ?????????
     
     */
    init<Body: Encodable>(url: URL, method: HttpMethod<Body>, header: [String: String]?) {
        self.urlRequest = URLRequest(url: url)
        self.urlRequest.httpMethod = method.method
        
        switch method {
        case .post(let body), .put(let body):
            self.urlRequest.httpBody = try? JSONEncoder().encode(body)
            self.urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        default:
            break
        }
        if let header = header {
            for (key, value) in header {
                self.urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
    }
}

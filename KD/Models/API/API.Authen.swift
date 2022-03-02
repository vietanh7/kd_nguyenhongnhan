//
//  API.Authen.swift
//  KD
//
//  Created by Nguyen Hong Nhan on 02/03/2022.
//

import Foundation
import Combine

extension API.Authen {
    
    //MARK: - Endpoint
    enum EndPoint {
        
        case login
        case register
        
        var urlString: String {
            switch self {
            case .login:
                return API.Config.endPointURL + "auth/login"
            case .register:
                return API.Config.endPointURL + "register"
            }
        }
        
    }
    
    // With Combine we return a DataTaskPublisher instead of using the completion handler of the DataTask
    static func postUserLogin(user: LoginInfo) throws -> URLSession.DataTaskPublisher {
        let headers = [
            "Content-Type": "application/json",
            "cache-control": "no-cache",
        ]
        let encoder = JSONEncoder()
        guard let postData = try? encoder.encode(user) else {
            throw APIError.invalidResponse
        }
        guard let url = URL(string: API.Authen.EndPoint.login.urlString) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        return session.dataTaskPublisher(for: request)
    }
    
    static func postUserRegister(user: RegisterInfo) throws -> URLSession.DataTaskPublisher {
        let headers = [
            "Content-Type": "application/json",
            "cache-control": "no-cache",
        ]
        let encoder = JSONEncoder()
        guard let postData = try? encoder.encode(user) else {
            throw APIError.invalidResponse
        }
        guard let url = URL(string: API.Authen.EndPoint.register.urlString) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        return session.dataTaskPublisher(for: request)
    }
    
    
}

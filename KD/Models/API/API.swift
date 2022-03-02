//
//  API.swift
//  Demo-Combine
//
//  Created by Nguyen Hong Nhan on 28/12/2021.
//

import Foundation
import Combine

struct API {
    
    //MARK: - Config
    struct Config {
        static let baseURL = "https://jsonplaceholder.typicode.com/"
    }
    
    //MARK: - Business API
    struct User { }
    
    struct Post { }
    
    static var cancellables = Set<AnyCancellable>()
}

enum APIError: Error {
    case error(String)
    case errorURL
    case invalidResponse
    case errorParsing
    case invalidURL
    case unknown
}
extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .error(let string):
            return NSLocalizedString(string, comment: "Error")
        case .errorURL:
            return NSLocalizedString("URL string is error.", comment: "Error URL")
        case .invalidResponse:
            return NSLocalizedString("Invalid response", comment: "Invalid response")
        case .errorParsing:
            return NSLocalizedString("Failed parsing response from server", comment: "Error Parsing")
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .unknown:
            return NSLocalizedString("An unknown error occurred", comment: "Unknow error")
        }
        
    }
}
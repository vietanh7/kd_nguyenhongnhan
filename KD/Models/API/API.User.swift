//
//  API.User.swift
//  Demo-Combine
//
//  Created by Nguyen Hong Nhan on 30/12/2021.
//

import Foundation
import Combine

extension API.User {
    
    //MARK: - Endpoint
    enum EndPoint {
        
        case users(offset: Int, limit: Int)
        
        
        var urlString: String {
            switch self {
            case .users(let offset, let limit):
                // https://jsonplaceholder.typicode.com/users
                return API.Config.baseURL + "users?_start=\(offset)&_limit=\(limit)"
            }
        }
        
    }
    
    
}

//
//  API.POST.swift
//  Demo-Combine
//
//  Created by Nguyen Hong Nhan on 28/12/2021.
//

import Foundation
import Combine

extension API.Post {
    
    //MARK: - Endpoint
    enum EndPoint {
        
        case posts(userId: Int, offset: Int, limit: Int)
        
        
        var urlString: String {
            switch self {
            case .posts(let userId, let offset, let limit):
                //https://jsonplaceholder.typicode.com/users/1/posts
                return API.Config.baseURL + "users/\(userId)/posts?_start=\(offset)&_limit=\(limit)"
            }
        }
        
    }
    
    
}


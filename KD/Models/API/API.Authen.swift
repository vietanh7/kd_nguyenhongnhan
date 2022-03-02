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
    
    
}

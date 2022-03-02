//
//  API.Product.swift
//  KD
//
//  Created by Nguyen Hong Nhan on 02/03/2022.
//

import Foundation
import Combine

extension API.Product {
    
    //MARK: - Endpoint
    enum EndPoint {
        
        case listProduct
        
        var urlString: String {
            switch self {
            case .listProduct:
                return API.Config.endPointURL + "items"
            }
        }
        
    }
    
    
}

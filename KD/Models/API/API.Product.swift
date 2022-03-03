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
        case delete
        case addProduct
        case updateProduct
        case searchProduct
        
        var urlString: String {
            switch self {
            case .listProduct:
                return API.Config.endPointURL + "items"
            case .delete:
                return API.Config.endPointURL + "item/delete"
            case .addProduct:
                return API.Config.endPointURL + "item/add"
            case .updateProduct:
                return API.Config.endPointURL + "item/update"
            case .searchProduct:
                return API.Config.endPointURL + "item/search"
                
            }
        }
        
    }
    
    
    static func getProducts() throws -> URLSession.DataTaskPublisher {
        
        var headers = [
            "Content-Type": "application/json",
            "cache-control": "no-cache"
        ]
        if let token = UserDefaultsHelper.getData(type: String.self, forKey: .token) {
            headers["Authorization"] = "Bearer " + token
        }
        
        guard let url = URL(string: API.Product.EndPoint.listProduct.urlString) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        return session.dataTaskPublisher(for: request)
    }
    
    static func postDelete(infoDelete: DeleteInfo) throws -> URLSession.DataTaskPublisher {
        var headers = [
            "Content-Type": "application/json",
            "cache-control": "no-cache",
        ]
        if let token = UserDefaultsHelper.getData(type: String.self, forKey: .token) {
            headers["Authorization"] = "Bearer " + token
        }
        let encoder = JSONEncoder()
        guard let postData = try? encoder.encode(infoDelete) else {
            throw APIError.invalidResponse
        }
        guard let url = URL(string: API.Product.EndPoint.delete.urlString) else {
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
    
    static func postAddProduct(productInfo: AddProductInfo) throws -> URLSession.DataTaskPublisher {
        var headers = [
            "Content-Type": "application/json",
            "cache-control": "no-cache",
        ]
        if let token = UserDefaultsHelper.getData(type: String.self, forKey: .token) {
            headers["Authorization"] = "Bearer " + token
        }
        let encoder = JSONEncoder()
        guard let postData = try? encoder.encode(productInfo) else {
            throw APIError.invalidResponse
        }
        guard let url = URL(string: API.Product.EndPoint.addProduct.urlString) else {
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
    
    
    static func postUpdateProduct(productInfo: AddProductInfo) throws -> URLSession.DataTaskPublisher {
        var headers = [
            "Content-Type": "application/json",
            "cache-control": "no-cache",
        ]
        if let token = UserDefaultsHelper.getData(type: String.self, forKey: .token) {
            headers["Authorization"] = "Bearer " + token
        }
        let encoder = JSONEncoder()
        guard let postData = try? encoder.encode(productInfo) else {
            throw APIError.invalidResponse
        }
        guard let url = URL(string: API.Product.EndPoint.updateProduct.urlString) else {
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
    
    static func postSearchProduct(searchInfo: SearchInfo) throws -> URLSession.DataTaskPublisher {
        var headers = [
            "Content-Type": "application/json",
            "cache-control": "no-cache",
        ]
        if let token = UserDefaultsHelper.getData(type: String.self, forKey: .token) {
            headers["Authorization"] = "Bearer " + token
        }
        let encoder = JSONEncoder()
        guard let postData = try? encoder.encode(searchInfo) else {
            throw APIError.invalidResponse
        }
        guard let url = URL(string: API.Product.EndPoint.searchProduct.urlString) else {
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

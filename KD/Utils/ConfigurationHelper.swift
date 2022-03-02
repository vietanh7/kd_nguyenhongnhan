//
//  Configuration.swift
//  DemoApp
//
//  Created by Nguyen Hong Nhan on 29/11/2021.
//

import Foundation

enum Configuration {
    
    enum ConfigKey: String {
        case K_APPLICATION_NAME
        case K_BUNDLE_IDENTIFIER
        case K_IDENTITY_POOL_ID
        case K_BACKEND_URL
    }
    
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }
    
    //ex: let appName = Configuration.getValue(forKey: .K_APPLICATION_NAME)
    static func getValue(forKey key: ConfigKey) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String else {
            fatalError("Invalid value or undefined key")
        }
        return value
    }
}

//
//  LoggerHelper.swift
//  Gratitapp
//
//  Created by Nguyen Hong Nhan on 4/13/21.
//

import Foundation

// Debug Print Log
public func DLog<T>(_ object: @autoclosure () -> T) {
    #if DEBUG
    let value = object()
    
    print(value)
    #endif
}

public func DLog<T>(_ string: String, _ object: @autoclosure () -> T) {
    #if DEBUG
        let valueString = string
        let value = object()
        print(valueString)
        print(value)
    #endif
}

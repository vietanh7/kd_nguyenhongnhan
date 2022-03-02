//
//  UserDefaultsHelper.swift
//  Gratitapp
//
//  Created by Nguyen Hong Nhan on 4/5/21.
//

/* GUIDE
 To set/save data, we can use this code from anywhere in our code.
 UserDefaultsHelper.setData(value: "user-001", key: .userId)
 
 To get the data:
 let id = UserDefaultsHelper.getData(type: String.self, forKey: .userId)

 To remove or clear all data in UserDefaults, we can use:
 _ = UserDefaultKeys.allCases.map({ UserDefaultsHelper.removeData(key: $0) })
 // We've confirmed to CaseIterable, hence we can use allCases here.
 */

import Foundation

enum UserDefaultKeys: String, CaseIterable {
    case token
}

final class UserDefaultsHelper {
    static func setData<T>(value: T, key: UserDefaultKeys) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key.rawValue)
    }
    
    static func getData<T>(type: T.Type, forKey: UserDefaultKeys) -> T? {
        let defaults = UserDefaults.standard
        let value = defaults.object(forKey: forKey.rawValue) as? T
        return value
    }
    
    static func removeData(key: UserDefaultKeys) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key.rawValue)
    }
    
    static func isLoggedIn() -> Bool {
        return (self.getData(type: String.self, forKey: .token) != nil)
    }
    
    static func signOut() {
        _ = UserDefaultKeys.allCases.map({ UserDefaultsHelper.removeData(key: $0) })
    }
}

///* GUIDE
// UserDefaults.standard.isLoggedIn()
// UserDefaults.standard.signOut()
// */
//extension UserDefaults {
//    func isLoggedIn() -> Bool {
//        return (UserDefaultsHelper.getData(type: String.self, forKey: .idToken) != nil)
//    }
//
//    func signOut() {
//        _ = UserDefaultKeys.allCases.map({ UserDefaultsHelper.removeData(key: $0) })
//    }
//}

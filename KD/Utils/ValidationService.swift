//
//  ValidationService.swift
//  Gratitapp
//
//  Created by Nguyen Hong Nhan on 3/1/21.
//

import Foundation

enum ValidationError: LocalizedError {
    case invalidEmail
    case invalidPhoneNumber
    case invalidName
    case invalidPassword
    case invaliaConfirmCode
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Invalid email"
        case .invalidPhoneNumber:
            return "Invalid phone number"
        case .invalidName:
            return "Invalid \nName must 2, 18 characters"
        case .invalidPassword:
            return "Invalid \nYour password must be between 8 to 16 characters, include uppercase letter, lowercase letter and number."
        case .invaliaConfirmCode:
            return "Invalid \nConfirm code must 6 characters"
        }
    }
}

struct ValidationService {
    
    static func validateEmail(_ email: String?) throws -> String {
        guard let email = email, email.isValidEmail, !email.isEmpty else { throw ValidationError.invalidEmail }
        return email
    }
    
    static func validateName(nameString: String) throws -> String {
        do {
            guard nameString.count >= 2, nameString.count <= 18 else {
                throw ValidationError.invalidName
            }
            let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$")
            if predicateTest.evaluate(with: nameString) {
                return nameString
            } else {
                throw ValidationError.invalidName
            }
        } catch {
            throw ValidationError.invalidName
        }
    }
    
    static func validatePassword(_ password: String?) throws -> String {
        guard let password = password, password.isValidPassword, !password.isEmpty else { throw ValidationError.invalidPassword
        }
        return password
    }
    
    static func validateConfirmCode(_ code: String) throws -> String {
        do {
            guard code.count == 6 else {
                throw ValidationError.invaliaConfirmCode
            }
            return code
        } catch {
            throw ValidationError.invaliaConfirmCode
        }
    }
    
    static func availableDataInput(_ inputText: String, completion: (Bool) -> Void) {
        completion((inputText.count>0) ? true : false)
    }
    
}

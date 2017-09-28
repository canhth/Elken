//
//  ValidateService.swift
//  GameOn
//
//  Created by thcanh on 1/12/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
    import RxSwift
#endif


class DefaultValidationService: ValidationService {
    
    static let sharedValidationService = DefaultValidationService()
    
    
    // validation
    
    let minPasswordCount = 5
    
    func validateEmail(_ email: String) -> ValidationResult {
        if !email.isEmail() {
            return .failed(message: "Please enter correct email format")
        }
        else if !email.contains("@babson.edu") && !email.contains("@gmail.com") {
            return .failed(message: "This email is not supported by our system")
        }
        return .ok
    }
    
    func validateLastName(_ lname: String) -> ValidationResult {
        if lname.characters.count == 0 {
            return .empty(message: "This field can be empty")
        } else {
            return .ok
        }
    }
    
    func validateEmpty(_ fname: String) -> ValidationResult {
        if fname.characters.count == 0 {
            return .empty(message: "This field can be empty")
        } else {
            return .ok
        }
    }
    
    func validateUsername(_ username: String) -> ValidationResult {
        if username.characters.count == 0 {
            return .empty(message: "This field can be empty")
        } else {
            return .ok
        }
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters = password.characters.count
        if numberOfCharacters == 0 {
            return .empty(message: "This field can be empty")
        }
        
        return .ok
    }
    
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        if repeatedPassword.characters.count == 0 {
            return .empty(message: "This field can be empty")
        } else if password != repeatedPassword {
            return .failed(message: "Confirm password does not match")
        }
        return .ok
    }
}

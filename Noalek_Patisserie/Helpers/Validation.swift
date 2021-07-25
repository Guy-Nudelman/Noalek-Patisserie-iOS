//
//  Validation.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 14/07/2021.
//

import Foundation

class Validation {
    
   static func isPasswordValid(_ testStr: String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: testStr)
    }

    static func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    static func isValidName(_ testStr:String) -> Bool {
        guard testStr.count > 1, testStr.count < 18 else { return false }
        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$")
        return predicateTest.evaluate(with: testStr)
    }
  
    static func isAdmin(callback:@escaping (Bool)-> Void){
        
        let user = Model.instance.getCurrentUser()
        if let user = user {
          let uid = user.uid
            Model.instance.getRole(userId: uid) { role in
                if role == "admin" {
                    callback(true)
                }else{
                    callback(false)
                }
            }
        }
    }

}



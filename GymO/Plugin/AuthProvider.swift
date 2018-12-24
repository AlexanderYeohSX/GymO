//
//  AuthProvider.swift
//  GymAlk
//
//  Created by Catherine on 7/28/18.
//  Copyright © 2018 GymAlk. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias LoginHandler = (_ msg: String?) -> Void

struct LoginErrorCode {
    static let INVALID_EMAIL = "Invalid Email Address, Please Provide Valid Email"
    static let WRONG_PASSWORD = "Wrong Password, Please Enter The Correct Password"
    static let PROBLEM_CONNECTING = "Problem Connecting To Database"
    static let USER_NOT_FOUND = "User Not Found, Please Register"
    static let EMAIL_ALREADY_IN_USE = "Please Use Another Email"
    static let WEAK_PASSWORD = "Password Too Short, Please Enter At Least 6 Characters"
    
}

class AuthProvider {
    private static let _instance = AuthProvider()
    
    static var Instance: AuthProvider {
        return _instance
    }
    
    var userName = "";
    
    func login(withEmail email: String, password: String, loginHandler: LoginHandler?){
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                self.handleErrors(error: error! as NSError, loginHandler: loginHandler)
            } else {
                loginHandler?(nil)
            }
            
        }
    }
    
    func signUp(withEmail email:String, password: String, loginHandler: LoginHandler?) {
        Auth.auth().createUser(withEmail: email, password: password){ (user,error) in
            
            if error != nil {
                self.handleErrors(error: error! as NSError, loginHandler: loginHandler)
            } else {
                if user?.user.uid != nil {
                   
                    //store the user to database
                    DBProvider.Instance.saveUser(withID: (user?.user.uid)!, email: email, password: password)
                    
                    //login the user
                    self.login(withEmail: email, password: password, loginHandler: loginHandler)
                    
                }
            }
        }
    }
    
    
    func isLoggedIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        }
        
        return false
    }
    
    func logOut() -> Bool {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                return true
            } catch {
                return false
            }
        }
        return true
    }
    
    func userID() -> String {
        return Auth.auth().currentUser!.uid;
    }
    
    private func handleErrors(error: NSError, loginHandler: LoginHandler?){
        if let errCode = AuthErrorCode(rawValue: error.code) {
            switch errCode {
            case .wrongPassword:
                loginHandler?(LoginErrorCode.WRONG_PASSWORD)

            case .invalidEmail:
                loginHandler?(LoginErrorCode.INVALID_EMAIL)
                
            case .userNotFound:
                loginHandler?(LoginErrorCode.USER_NOT_FOUND)
                
            case .emailAlreadyInUse:
                loginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE)
            
            case .weakPassword:
                loginHandler?(LoginErrorCode.WEAK_PASSWORD)
                
            default:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING)
            }
        }
    }
}

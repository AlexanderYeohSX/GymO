//
//  Profile.swift
//  GymO
//
//  Created by Catherine on 11/5/18.
//  Copyright © 2018 GymO. All rights reserved.
//

import Foundation
import UIKit

class Profile {
    
    var email: String = ""
    let id: String?
    var name: String
    var age: Int
//    var experience: String = ""
    var location: String?
    var gender: String
//    var description: String?
    
   /* var image: UIImage? {
        get{
            return Profile.shared.getImage(id: self.id!)
        }
        set {
            try? Profile.shared.setImage(id: self.id!, image: newValue)
        }
    }*/
    
    init (name: String, age: Int, location: String, gender: String) {
        
        self.name = name
        self.age = age
        self.location = location
        self.gender = gender
        self.id = AuthProvider.Instance.userID() //MIGHT FAIL DUE TO NO CURRENT USER/NO INTERNET
        self.email = AuthProvider.Instance.userEmail() //MIGHT FAIL DUE TO NO CURRENT USER/NO INTERNET
    }
    /*init(email: String, id: String) {
        self.email = email
        self.id = UUID.init(uuidString: id)!
    }*/
}


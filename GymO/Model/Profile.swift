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
    var id: String = ""
    var name: String
    var age: Int
//    var experience: String = ""
    var location: String?
    var gender: String
    var matchedUsers: [String] = []
//["pegODobZloOh11fLcOvkd5EFh692","XEeLsAUSuSXlvkYoRqR9w1DcDr53","n0W9760m58Y2ny73WGeJaqXoSZ22","NFAe92cZScaHBSjdmI1sdU3tQJG2","cmsHhI8FinP9SdZjZsvICMgn86i2"] // Testing
//    var description: String?
    
   /* var image: UIImage? {
        get{
            return Profile.shared.getImage(id: self.id!)
        }
        set {
            try? Profile.shared.setImage(id: self.id!, image: newValue)
        }
    }*/
    
    init (name: String, age: Int, location: String, gender: String, id: String) {
        
        self.name = name
        self.age = age
        self.location = location
        self.gender = gender
        self.id = id //MIGHT FAIL DUE TO NO CURRENT USER/NO INTERNET
        self.email = AuthProvider.Instance.userEmail() //MIGHT FAIL DUE TO NO CURRENT USER/NO INTERNET
    }
    /*init(email: String, id: String) {
        self.email = email
        self.id = UUID.init(uuidString: id)!
    }*/
}


//
//  Contact.swift
//  GymAlk
//
//  Created by Catherine on 7/29/18.
//  Copyright © 2018 GymAlk. All rights reserved.
//
//NOT USED
import Foundation

class Contact {
    private var _name = ""
    private var _id = ""
    
    var name: String {
        return _name

    }
    
    var id: String {
        return _id
    }
    
    init(id: String, name: String) {
        _id = id
        _name = name
    }
}

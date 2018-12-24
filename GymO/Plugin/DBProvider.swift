//
//  DBProvider.swift
//  GymAlk
//
//  Created by Catherine on 7/29/18.
//  Copyright © 2018 GymAlk. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol FetchData: class {
    func dataReceived(contacts: [Contact])
}

class DBProvider {
    private static let _instance = DBProvider()
    
    weak var delegate: FetchData?
    
    private init(){}
    
    static var Instance: DBProvider {
        return _instance
    }
    
    var dbRef: DatabaseReference {
        return Database.database().reference()
    }
    
    var contactsRef: DatabaseReference {
        return dbRef.child(Constants.CONTACTS)
    }
    
    var messageRef: DatabaseReference {
        return dbRef.child(Constants.MESSAGES)
    }
    
    var mediaMessageRef: DatabaseReference {
        return dbRef.child(Constants.MEDIA_MESSAGES)
    }
    
    var storageRef: StorageReference {
        return Storage.storage().reference(forURL: "gs://gymo-1.appspot.com")
    }
    
    var imageStorageRef: StorageReference {
        return storageRef.child(Constants.IMAGE_STORAGE)
    }
    
    var videoStorageRef: StorageReference {
        return storageRef.child(Constants.VIDEO_STORAGE)
    }
    
    func saveUser(withID id: String, email:String, password: String) {
        print("Abc")
        let data: Dictionary<String,Any> = [Constants.EMAIL: email, Constants.PASSWORD:password]
        
        contactsRef.child(id).setValue(data)
    }
    
    func getContacts() {
        contactsRef.observeSingleEvent(of: .value) {
            (snapshot: DataSnapshot) in
            
            var contacts = [Contact]()
            
            if let myContacts = snapshot.value as? NSDictionary {
                for (key,value) in myContacts {
                    if let contactData = value as? NSDictionary{
                        if let email = contactData[Constants.EMAIL] as? String {
                            print(email)
                            let id = key as! String
                            let newContact = Contact(id: id, name: email)
                            contacts.append(newContact)
                        }
                    }
                }
            }
            
            self.delegate?.dataReceived(contacts: contacts)
        }
      
    }
    
}

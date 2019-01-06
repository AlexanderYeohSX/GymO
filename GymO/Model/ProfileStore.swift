//
//  ProfileStore.swift
//  GymO
//
//  Created by Kean Wei Wong on 25/12/2018.
//  Copyright © 2018 GymO. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Pageboy

class ProfileStore {
    static let shared = ProfileStore()
    private var profilesCache = [Profile]()
    private var currentProfile: Profile?
    private let dbRefForUsers = Database.database().reference().child("users")
    private var addedProfilesCache = [Profile]()
    
    init(){}
    
    func addProfile(of user: Profile) -> Profile {
        
        profilesCache.append(user)
        return user
    }
    
    func getProfile(at index: Int) -> Profile {
        return profilesCache[index]
    }
    
    func getProfile(for id: String) -> Profile? {
        for profiles in profilesCache {
            if profiles.id == id {
                return profiles
            }
        }
        return nil
    }
    
    func numberOfProfiles() -> Int {
        return profilesCache.count
    }
    
    func setCurrentProfile(as user: Profile) {
        currentProfile = user
    }
    
    func getCurrentProfile() -> Profile? {
        return currentProfile
    }
    
    
    func addMatchedBuddy(id: String) {
        
        for friend in (currentProfile?.matchedUsers)! {
            if friend == id {
                return
            }
        }

        currentProfile?.matchedUsers.append(id)
        updateCurrentProfileDb(for: .matchedUsers)
    }
    
    func setupCurrentProfileDb() {
    
        dbRefForUsers.child(AuthProvider.Instance.userID()).child("name").setValue(currentProfile?.name)
        dbRefForUsers.child(AuthProvider.Instance.userID()).child("age").setValue(currentProfile?.age)
    dbRefForUsers.child(AuthProvider.Instance.userID()).child("location").setValue(currentProfile?.location)
        dbRefForUsers.child(AuthProvider.Instance.userID()).child("gender").setValue(currentProfile?.gender)
        dbRefForUsers.child(AuthProvider.Instance.userID()).child("email").setValue(currentProfile?.email)
        dbRefForUsers.child(AuthProvider.Instance.userID()).child("id").setValue(currentProfile?.id)
        
    }
    
    func updateCurrentProfileDb(for property: ProfileProperty){
        
        let uid = AuthProvider.Instance.userID()
        
        switch property{
        case .name:
            dbRefForUsers.child(uid).child("name").setValue(currentProfile?.name)
        case .age:
            dbRefForUsers.child(uid).child("age").setValue(currentProfile?.age)
        case .email:
            dbRefForUsers.child(uid).child("email").setValue(currentProfile?.email)
        case .gender:
            dbRefForUsers.child(uid).child("gender").setValue(currentProfile?.gender)
        case .id:
            dbRefForUsers.child(uid).child("id").setValue(currentProfile?.id)
        case .location:
            dbRefForUsers.child(uid).child("location").setValue(currentProfile?.location)
        case .matchedUsers:
            dbRefForUsers.child(uid).child("matchedUsers").setValue(currentProfile?.matchedUsers)
        }
    }
    
    func instantiateProfileCache(for user: String, view: PageboyViewController) {
        dbRefForUsers.observeSingleEvent(of: .value)
        { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let profileDict = value {
                for profiles in profileDict {
                    let value2 = profiles.value as? NSDictionary
                    if let profile = value2 {
                        if let age = profile["age"] ,
                            let name = profile["name"] ,
                            let location = profile["location"] ,
                            let gender = profile["gender"],
                            let id = profile["id"]
                            {
                                let currentID = profiles.key as! String
                                if currentID == AuthProvider.Instance.userID() {
                                self.currentProfile = Profile(name: name as! String,
                                                                    age: age as! Int,
                                                                    location: location as! String,
                                                                    gender: gender as! String,
                                                                    id: id as! String)
                                    if let matchedUsers = profile["matchedUsers"] {
                                        self.currentProfile?.matchedUsers = matchedUsers as! [String]
                                    }

                                } else {
                                    self.profilesCache.append(Profile(name: name as! String,
                                                             age: age as! Int,
                                                             location: location as! String,
                                                             gender: gender as! String,
                                                             id: id as! String
                                                             ))
                                }
                        }
                    }
                }
            }
            print("Firebase Completed")
            view.reloadData()
        }
    }
    
}

enum ProfileType {
    case currentUser
    case profilesCache
    case addedProfiles
}

//MARK: - Reference only
//class ProfileStore {
//    static let shared = ProfileStore()
//    private var imageCache: [UUID:UIImage] = [:]
//    var documentsFolder: URL {
//        return FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!
//    }
//
//    func getImage(id: UUID) -> UIImage? {
//
//        if let image = imageCache[id] {
//            return image
//        }
//
//        let imageURL = documentsFolder.appendingPathComponent("\(id.uuidString)-image.jpg")
//
//        guard let imageData = try? Data(contentsOf: imageURL) else {
//            return nil
//        }
//
//        guard let image = UIImage(data: imageData) else {
//            return nil
//        }
//
//        imageCache[id] = image
//
//        return image
//
//    }
//
//    func setImage(id: UUID, image: UIImage?) throws {
//
//        let fileName = "\(id.uuidString)-image.jpg"
//        let destinationURL = self.documentsFolder.appendingPathComponent(fileName)
//
//        if let image = image {
//
//            guard let data = image.jpegData(compressionQuality: 0.9) else{
//                throw ProfileStoreError.cannotSaveImage(image)
//            }
//
//            try data.write(to: destinationURL)
//        }
//        else {
//            try FileManager.default.removeItem(at: destinationURL)
//        }
//
//        imageCache[id] = image
//    }
//
//}
//
//enum ProfileStoreError : Error {
//    case cannotSaveImage(UIImage?)
//}

enum ProfileProperty {
    case name
    case age
    case location
    case gender
    case email
    case id
    case matchedUsers
}

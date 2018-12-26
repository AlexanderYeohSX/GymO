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
    
    init(){}
    
    func addProfile(of user: Profile) -> Profile {
        
        profilesCache.append(user)
        return user
    }
    
    func getProfile(at index: Int) -> Profile {
        return profilesCache[index]
    }
    
    func numberOfProfiles() -> Int {
        return profilesCache.count
    }
    
    func setCurrentProfile(as user: Profile) {
        currentProfile = user
    }
    
    func updateCurrentProfile() {
        
        dbRefForUsers.child(AuthProvider.Instance.userID()).child("name").setValue(currentProfile?.name)
        dbRefForUsers.child(AuthProvider.Instance.userID()).child("age").setValue(currentProfile?.age)
        dbRefForUsers.child(AuthProvider.Instance.userID()).child("location").setValue(currentProfile?.location)
        dbRefForUsers.child(AuthProvider.Instance.userID()).child("gender").setValue(currentProfile?.gender)
        dbRefForUsers.child(AuthProvider.Instance.userID()).child("email").setValue(currentProfile?.email)
        dbRefForUsers.child(AuthProvider.Instance.userID()).child("id").setValue(currentProfile?.id)
        
    }
    
    func instantiate(for user: String, view: PageboyViewController) {
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
                            let gender = profile["gender"]
                            {
                                let currentID = profiles.key as! String
                                if currentID == AuthProvider.Instance.userID() {
                                 self.currentProfile = Profile(name: name as! String,
                                                                      age: age as! Int,
                                                                      location: location as! String,
                                                                      gender: gender as! String)
                                } else {
                                    self.profilesCache.append(Profile(name: name as! String,
                                                             age: age as! Int,
                                                             location: location as! String,
                                                             gender: gender as! String))
                                }
                        }
                    }
                }
            }
            
            view.reloadData()
        }
    }
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


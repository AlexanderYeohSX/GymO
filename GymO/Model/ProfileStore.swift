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
import FirebaseStorage

class ProfileStore {
    static let shared = ProfileStore()
    private var profilesCache = [Profile]()
    private var currentProfile: Profile?
    private let dbRefForUsers = Database.database().reference().child("users")
    private var addedProfilesCache = [Profile]()
    private var requestProfilesCache = [Profile]()
    
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
    
    func getRequestedProfile(for id: String) -> Profile? {
        
        for profiles in requestProfilesCache {
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
        updateMatchedProfileDb(id: id)
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

    func updateMatchedProfileDb(id: String) {
        
        let date = Date()
        dbRefForUsers.child(id).child("addedBy").child((currentProfile?.id)!).child("date").setValue(date.description)
    }
    
    func instantiateProfileCache(for user: String, view: PageboyViewController) {
        dbRefForUsers.observeSingleEvent(of: .value)
        { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let profileDict = value {
                
                self.queryDatabase(profileDict: profileDict, profileType: .currentUser)
                self.queryDatabase(profileDict: profileDict, profileType: .notCurrentUser)

            }
             print("main view loaded for \(ProfileStore.shared.getCurrentProfile()?.name)")
            view.reloadData()
        }
    }
    
    func clearSession(){
        
        profilesCache = []
        currentProfile =  nil
        addedProfilesCache = []
        requestProfilesCache = []
    }
    
    func queryDatabase(profileDict: NSDictionary, profileType: ProfileType) {
        for profiles in profileDict {
            
            let currentID = profiles.key as! String
            let value2 = profiles.value as? NSDictionary
            if let profile = value2 {
                if let age = profile["age"] ,
                    let name = profile["name"] ,
                    let location = profile["location"] ,
                    let gender = profile["gender"],
                    let id = profile["id"]
                {
                    switch profileType{
                    case .currentUser:
                        
                        if currentID == AuthProvider.Instance.userID() {
                            self.currentProfile = Profile(name: name as! String,
                                                          age: age as! Int,
                                                          location: location as! String,
                                                          gender: gender as! String,
                                                          id: id as! String)
                            if let matchedUsers = profile["matchedUsers"] {
                                self.currentProfile?.matchedUsers = matchedUsers as! [String]
                            }
                            
                            if let addedBy = profile["addedBy"] as? NSDictionary {
                                for addedByUsers in addedBy {
                                
                                   let addedByUserID = addedByUsers.key as! String
                                    let value3 = addedByUsers.value as? NSDictionary
                                    if let addedByUser = value3 {
                                        guard let dateAdded = addedByUser["date"] else {
                                            fatalError("Added user Date in Database does not exist")
                                        }
                                        
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                                        let dateAddedDateFormat = dateFormatter.date(from: dateAdded as! String)
                                        
                                        var requestSender = RequestSender.init(id: addedByUserID, date: dateAddedDateFormat!, accepted: nil)
                                        
                                        if let accepted = addedByUser["accepted"] {
                                            requestSender.accepted = accepted as? Bool
                                        }
                                        
                                        self.currentProfile?.addedBy.append(requestSender)
                                        print( self.currentProfile?.addedBy)

                                    }
                                    
                                //    self.currentProfile?.addedBy.append(RequestSender)
                                }
                            }
                            
                        }
                    case .notCurrentUser:
                        
                        let allRequestSenders = ProfileStore.shared.currentProfile?.getAllRequestSender()
                        
                        if let matchedUsers = self.currentProfile?.matchedUsers {
                       
                            print(currentID)
                            if matchedUsers.contains(currentID) {
                                addedProfilesCache.append(Profile(name: name as! String,
                                                                  age: age as! Int,
                                                                  location: location as! String,
                                                                  gender: gender as! String,
                                                                  id: id as! String))
                            } else if (allRequestSenders?.contains(currentID))!{
                                requestProfilesCache.append(Profile(name: name as! String,
                                                                  age: age as! Int,
                                                                  location: location as! String,
                                                                  gender: gender as! String,
                                                                  id: id as! String))
                                print("added \(name as! String)")
                            }
                            
                                
                            else if currentID != AuthProvider.Instance.userID() {
                                self.profilesCache.append(Profile(name: name as! String,
                                                                  age: age as! Int,
                                                                  location: location as! String,
                                                                  gender: gender as! String,
                                                                  id: id as! String))
                            }
                        }
                     
                    }
                }
            }
        }
    }
    
    func uploadImageForCurrentUser(with image: UIImage) {
        let storageRef = Storage.storage().reference()
        let imagesRef = storageRef.child("images")
        let userID = AuthProvider.Instance.userID()
        let userRef = imagesRef.child(userID)
        let data = image.jpegData(compressionQuality: 1.0)
        let fileName = userID  + "-00.jpg"
        let fileRef = userRef.child(fileName)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload the file to the firebase
        if let data = data {
            print("a")
            let uploadTask = fileRef.putData(data, metadata: metadata) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print(error!)
                    return
                }
                print(metadata)
                // Metadata contains file metadata such as size, content-type.
                // You can also access to download URL after upload.
            }
            
            uploadTask.observe(.progress) { (snapshot) in
               
                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                    / Double(snapshot.progress!.totalUnitCount)
                
                print(percentComplete)
            }
            
            
        }
    }
}

enum ProfileType {
    case currentUser
    case notCurrentUser
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

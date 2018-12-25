//
//  ProfileStore.swift
//  GymO
//
//  Created by Kean Wei Wong on 25/12/2018.
//  Copyright © 2018 GymO. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ProfileStore {
    static let shared = ProfileStore()
    private var profilesCache = [Profile]()
    private var currentProfile: Profile?
    
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
        
       let dbRefForUserID = Database.database().reference().child("users").child(AuthProvider.Instance.userID())
        dbRefForUserID.child("name").setValue(currentProfile?.name)
        dbRefForUserID.child("age").setValue(currentProfile?.age)
        dbRefForUserID.child("location").setValue(currentProfile?.location)
        dbRefForUserID.child("gender").setValue(currentProfile?.gender)
        dbRefForUserID.child("email").setValue(currentProfile?.email)
        dbRefForUserID.child("id").setValue(currentProfile?.id)
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


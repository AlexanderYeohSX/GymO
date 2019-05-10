//
//  Profile.swift
//  GymO
//
//  Created by Catherine on 11/5/18.
//  Copyright © 2018 GymO. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import SDWebImage


class Profile {
    
    var email: String = ""
    var id: String = ""
    var name: String
    var age: Int
    //    var experience: String = ""

    var location: String?
    var gender: String
    var matchedUsers: [String] = []
    var addedBy = [RequestSender]()
    var picturesForProfile: [UIImage] = []
    var numberOfPictures: Int = 0
    var displayVC: ProfileViewController?
    var picturesDownloadURL: [String] = [] {
        didSet {
            downloadImageForProfile()
        }
    }
    var uploadedPictureURL: String?
    var profileImage: UIImage?
    
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

    
    init (name: String, age: Int, location: String, gender: String, id: String, numberOfPictures: Int) {
        
        self.name = name
        self.age = age
        self.location = location
        self.gender = gender
        self.id = id //MIGHT FAIL DUE TO NO CURRENT USER/NO INTERNET
        self.email = AuthProvider.Instance.userEmail() //MIGHT FAIL DUE TO NO CURRENT USER/NO INTERNET
        self.numberOfPictures = numberOfPictures
        downloadImageForProfile()
        
    }
    /*init(email: String, id: String) {
     self.email = email
     self.id = UUID.init(uuidString: id)!
     }*/

    
    func getAllRequestSender() -> [String] {
        
        var allRequestSender: [String] = []
        
        for requestSenders in addedBy {
            allRequestSender.append(requestSenders.id)
        }
        
        return allRequestSender
    }
    
    func downloadImageForProfile() {

        
        if numberOfPictures > 0 {
            
            if let displayPictureURL = picturesDownloadURL.first {
                let url = URL(string: displayPictureURL)
                print(url)
                print("downloading")
                SDWebImageManager.shared.loadImage(with: url, options: SDWebImageOptions.highPriority, context: nil, progress: nil) { (image, data, error, cacheType, bool, url) in
                    
                    if let downloadedImage = image {
                        self.profileImage = downloadedImage
                        self.displayVC?.reloadData()
                        print("Download Image Complete")
                    }
                }

                
//                let task = URLSession.shared.downloadTask(with: url) { (localURL, urlResponse, error) in
//
//                    if let location = localURL {
//                        print(localURL?.absoluteString)
//                        if let image = try? UIImage(contentsOfFile: location.path) {
//
//
//                        }
//                    }
//                }
//
//                task.resume()
            }

        } else {
            
            let profileGender = self.gender
            
            if profileGender == "Male" {
                profileImage = UIImage(imageLiteralResourceName: "male-default")
            } else if profileGender == "Female" {
                profileImage = UIImage(imageLiteralResourceName: "female-default")
            } else {
                fatalError("No image downloaded and no gender/ profile view error")
            }
            self.displayVC?.reloadData()
        }
        
        //        for pictureNumber in 0...(numberOfPictures - 1) {
        //
        //
        //            let fileName = userID  + "-0\(pictureNumber).jpg"
        //            let fileRef = userRef.child(fileName)
        //
        //            print("Downloaded image called")
        //            //Download file with maxsize of 30MB
        //            //Might get error where the first downloaded image is from a later integer
        //            fileRef.getData(maxSize: 30 * 1024 * 1024) { (data, error) in
        //
        //                var profileImage: UIImage?
        //
        //                if let downloadedData = data {
        //                    profileImage = UIImage(data: downloadedData)
        //                }
        //
        //                //print("in Profile")
        //                //print("Downloaded image")
        //                //print(self.name)
        //                if let obtainedImage = profileImage{
        //                    self.picturesForProfile.append(obtainedImage)
        //                }
        //                //print(self.picturesForProfile)
        //                self.displayVC?.reloadData()
        //            }
        //        }
    }
}

struct RequestSender {
    
    let id: String
    var date: Date
    var accepted: Bool?
    
}

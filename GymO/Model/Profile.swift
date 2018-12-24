//
//  Profile.swift
//  GymO
//
//  Created by Catherine on 11/5/18.
//  Copyright © 2018 GymO. All rights reserved.
//

import Foundation
import UIKit

class Profile: Codable {
    let email: String = ""
    let id: UUID?
    var name: String = ""
    var age: Int = 0
    var experience: String = ""
    var location: String?
    var description: String?
    
   /* var image: UIImage? {
        get{
            return Profile.shared.getImage(id: self.id!)
        }
        set {
            try? Profile.shared.setImage(id: self.id!, image: newValue)
        }
    }*/
    
    
    /*init(email: String, id: String) {
        self.email = email
        self.id = UUID.init(uuidString: id)!
    }*/
}

class ProfileStore {
    static let shared = ProfileStore()
    private var imageCache: [UUID:UIImage] = [:]
    var documentsFolder: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!
    }

    func getImage(id: UUID) -> UIImage? {
        
        if let image = imageCache[id] {
            return image
        }
        
        let imageURL = documentsFolder.appendingPathComponent("\(id.uuidString)-image.jpg")
        
        guard let imageData = try? Data(contentsOf: imageURL) else {
            return nil
        }
        
        guard let image = UIImage(data: imageData) else {
            return nil
        }
        
        imageCache[id] = image
        
        return image
        
    }
    
    func setImage(id: UUID, image: UIImage?) throws {
        
        let fileName = "\(id.uuidString)-image.jpg"
        let destinationURL = self.documentsFolder.appendingPathComponent(fileName)
        
        if let image = image {
            
            guard let data = image.jpegData(compressionQuality: 0.9) else{
                throw ProfileStoreError.cannotSaveImage(image)
            }
            
            try data.write(to: destinationURL)
        }
        else {
            try FileManager.default.removeItem(at: destinationURL)
        }
        
        imageCache[id] = image
    }

}

enum ProfileStoreError : Error {
    case cannotSaveImage(UIImage?)
}


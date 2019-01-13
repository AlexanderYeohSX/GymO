//
//  EditTableViewController.swift
//  GymO
//
//  Created by Catherine on 11/23/18.
//  Copyright © 2018 GymO. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class EditTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    struct User : Codable {
        var name: String
        var age: String
        var experience: String
        var location: String
        var description: String
    }
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var experience: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var userDescription: UITextField!
    @IBOutlet weak var gender: UITextField!
    
    @IBAction func uploadPhotoCamera(_ sender: Any)
    {
        let vc = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            vc.sourceType = .camera
            vc.delegate = self
            print("camera available")
            present(vc, animated: true, completion: nil)
        } else {
            print("camera unavailable")
            return
        }
        print("upload Camera")
    }
    
    @IBAction func uploadPhotoLibrary(_ sender: Any) {
        let vc = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            vc.sourceType = .photoLibrary
            vc.delegate = self
            print("photo library available")
            present(vc, animated: true, completion: nil)
        } else {
            print("photo library unavailable")
            return
        }

        
        print("upload Photo Library")
    }
    
    @IBAction func updateProfile(_ sender: Any) {
    
        
        //NOTE: Force unwrapping Int()! for age will be dangerous in the future
        ProfileStore.shared.setCurrentProfile(as:
            Profile(name: name.text!,
                    age: Int(age.text!)!,
                    location: location.text!,
                    gender: gender.text!,
                    id: AuthProvider.Instance.userID()
        ))
        
        ProfileStore.shared.setupCurrentProfileDb()
        
//      OLD CODES//        let encoder = JSONEncoder()
//
//        do {
//            let data = try encoder.encode(userProfile)
//            Database.database().reference().child("users/\(AuthProvider.Instance.userID())").setValue(String(data: data, encoding: .utf8)!)
//             alertUser(title: "Update Complete!", message: "Your profile has been updated! Yay")
//            print(String(data: data, encoding: .utf8)!)
//        } catch let error{
//            print(error)
//            return
//        }
        
    }
    
    @IBAction func logOut(_ sender: Any) {
        if AuthProvider.Instance.logOut(){
            //IF ERROR SAYING NO CURRENT PROFILE OR PROFILE CACHE EMPTY DEBUG FROM HERE.
            ProfileStore.shared.clearSession()
            
            dismiss(animated: true, completion: nil)

        } else {
            alertUser(title: "Could Not Logged Out", message: "Please Try Again Later")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    private func alertUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    // NO USE DAO
//    func jsonToString(json: AnyObject){
//        do {
//            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
//            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
//            print(convertedString!) // <-- here is ur string
//
//        } catch let myJSONError {
//            print(myJSONError)
//        }
//
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        var image:UIImage
       
        
        //To append to editedImage after not using simulator
        if info[.editedImage] == nil {
            guard let imageObtained = info[.originalImage] as? UIImage else {
                print("No image found")
                return
            }
            
            image = imageObtained
        } else {
            guard let imageObtained = info[.editedImage] as? UIImage else {
                print("No image found")
                return
            }
            
            image = imageObtained
        }
        
         print(image.size)
        // print out the image size as a test
        
        ProfileStore.shared.uploadImageForCurrentUser(with: image)
        picker.dismiss(animated: true)

    }
    
    func uploadImage(image: UIImage) {
      
    }
}

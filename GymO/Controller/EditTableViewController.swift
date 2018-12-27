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
        
        ProfileStore.shared.updateCurrentProfile()
        
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
            dismiss(animated: true, completion: nil)
        } else {
            alertUser(title: "Could Not Logged Out", message: "Please Try Again Later")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

   /* override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    private func alertUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
    func jsonToString(json: AnyObject){
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString!) // <-- here is ur string
            
        } catch let myJSONError {
            print(myJSONError)
        }
        
    }
    
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
        
        uploadImage(image: image)
        picker.dismiss(animated: true)

    }
    
    func uploadImage(image: UIImage) {
        let storageRef = Storage.storage().reference()
        let imagesRef = storageRef.child("images")
        let userID = AuthProvider.Instance.userID()
        let userRef = imagesRef.child(userID)
        let data = image.pngData()
        let fileName = userID  + "-profilepic.jpg"
        let fileRef = userRef.child(fileName)
        
        
        // Upload the file to the firebase
        if let data = data {
            print("a")
            fileRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print(error!)
                    return
                }
                print(metadata)
                // Metadata contains file metadata such as size, content-type.
                // You can also access to download URL after upload.
                fileRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        
                        print(error!)
                        return
                    }
                    print(downloadURL)
                }
            }
            
        }
    }
    

}

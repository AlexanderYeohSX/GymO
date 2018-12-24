//
//  MainViewController.swift
//  GymO
//
//  Created by Kean Wei Wong on 02/12/2018.
//  Copyright © 2018 GymO. All rights reserved.
//

import UIKit
import FirebaseStorage

class MainViewController: UIViewController {
    
    var profiles = [Profile]()
    
    let storageRef = Storage.storage().reference()
    

    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //SHafie image
       setPicture(uid: AuthProvider.Instance.userID())
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func setPicture (uid: String) {
        let imagesRef = storageRef.child("images")
        let userRef = imagesRef.child(uid)
        let fileName = uid  + "-profilepic.jpg"
        let fileRef = userRef.child(fileName)
        
        
        fileRef.getData(maxSize: 100 * 1024 * 1024){
            (data,error) in
            
            
            if let error = error {
                // Uh-oh, an error occurred!
                print(error)
            } else {
                // Data for "images" is returned
                let imageObtained = UIImage(data: data!)!
                self.profileImage.image = imageObtained
            }
        }
    }
}

//
//  ProfileViewController.swift
//  GymO
//
//  Created by Kean Wei Wong on 25/12/2018.
//  Copyright © 2018 GymO. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    private var parentVC: MainPageViewController?
    @IBOutlet weak var profileImage: UIImageView!
    private var profileDisplayed: Profile?
    var currentIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parentVC = parentPageboy as? MainPageViewController
        if let currentIndex = parentVC?.viewControllers.index(of: self) {
        
            profileDisplayed = ProfileStore.shared.getProfile(at: currentIndex)
        } else {
            print("Error, index not found")
        }
        print("view loaded for \(profileDisplayed?.name)")
       updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {

        parentVC?.updateUI(at: (parentVC?.viewControllers.index(of: self))!)
    }
    
   
    
    override func viewWillDisappear(_ animated: Bool) {
    
        parentVC?.transitioningUI()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
   
    
    private func updateUI(){

        if profileDisplayed?.gender == "Male" {
            profileImage.image = UIImage(imageLiteralResourceName: "male-default")
        } else if profileDisplayed?.gender == "Female" {
            profileImage.image = UIImage(imageLiteralResourceName: "female-default")
        }
        
    }
}

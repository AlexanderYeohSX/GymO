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
    var profileDisplayed: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parentVC = parentPageboy as? MainPageViewController
        guard let currentIndex = parentVC?.viewControllers.index(of: self)
        else {
            fatalError("Missing index for profile view controller")
        }
        
        profileDisplayed = ProfileStore.shared.getProfile(at: currentIndex)
        reloadData()
        
        print("view loaded for \(profileDisplayed?.name)")
        
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
    
   
    
    func reloadData(){
        print("Update UI Reached")
        

        print(profileDisplayed?.name)
        if let profilePicture = profileDisplayed?.profileImage {
            self.profileImage.image = profilePicture
            print("and updated picture")
        }
    }
    
    func getDisplayedProfileGender() -> String {
        return (profileDisplayed?.gender)!
    }
    
    func getDisplayedProfileName() -> String {
        return (profileDisplayed?.name)!
    }
}

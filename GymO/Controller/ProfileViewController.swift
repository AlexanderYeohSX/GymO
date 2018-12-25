//
//  ProfileViewController.swift
//  GymO
//
//  Created by Kean Wei Wong on 25/12/2018.
//  Copyright © 2018 GymO. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    private var indexOfPage: Int?
    private var parentVC: MainPageViewController?
    private var profileDisplayed:Profile?
    
    @IBOutlet weak var nameLabel: UILabel! 
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parentVC = parentPageboy as? MainPageViewController
        
        
        updateIndex()
        if let index = indexOfPage {
            profileDisplayed = ProfileStore.shared.getProfile(at: index)
        }
        print(profileDisplayed?.name)
        updateUI()
        
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
    
    private func updateIndex() {
        if let index = (parentVC)?.viewControllers.index(of: self) {
            print(index)
            
            
            indexOfPage = index
        }
    }
    
    private func updateUI() {
        if profileDisplayed != nil {
            nameLabel.text = profileDisplayed?.name
            ageLabel.text = String(profileDisplayed!.age)
            locationLabel.text = profileDisplayed?.location
            
            if profileDisplayed?.gender == "Male" {
                
                profileImage.image = UIImage(imageLiteralResourceName: "male-default")
            } else if profileDisplayed?.gender == "Female" {
                profileImage.image = UIImage(imageLiteralResourceName: "female-default")
            }
            
        }
        
    }
}

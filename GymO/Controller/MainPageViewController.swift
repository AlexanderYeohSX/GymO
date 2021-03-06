//
//  MainViewController.swift
//  GymO
//
//  Created by Kean Wei Wong on 02/12/2018.
//  Copyright © 2018 GymO. All rights reserved.
//

import UIKit
import Firebase
import Pageboy

class MainPageViewController: PageboyViewController {
    
    let storageRef = Storage.storage().reference()
    var imageViewRef: UIImageView?
    
    @IBOutlet weak var collectionViewRef: UICollectionView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var profileView: UIScrollView!
    @IBOutlet weak var bottomScrollView: UIView!
    
    @IBOutlet weak var matchButton: UIButton!
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    
    lazy var viewControllers: [UIViewController] = {
        var viewControllers = [UIViewController]()
        for i in 0 ..< ProfileStore.shared.numberOfProfiles(){
            viewControllers.append(makeProfileViewController(at: i))
            let currentVC = viewControllers[i] as! ProfileViewController
            let profileDisplay = ProfileStore.shared.getProfile(at: i)
            profileDisplay.displayVC = currentVC
            
        }
        return viewControllers
    }()
    
    @IBAction func matchButtonPressed(_ sender: UIButton) {
        
        ProfileStore.shared.addMatchedBuddy(id: ProfileStore.shared.getProfile(at: sender.tag).id)
        self.performSegue(withIdentifier: "GoToChat", sender: sender)

        
    }
    
    
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        matchButton.layer.cornerRadius = 15
        self.transition = Transition(style: .fade, duration: 1.0)
        
        let currentVC = self
        ProfileStore.shared.instantiateProfileCache(for: AuthProvider.Instance.userID(), view: currentVC)

        self.dataSource = self
        bottomScrollView.layer.cornerRadius = 15
        
        ProfileStore.shared.mainPageVC = self
        profileView.delegate = self
        
        photoCollectionView.dataSource = self
        
        //Use Division method for autolayout
        //SHafie image

    }
    
    func makeProfileViewController(at index: Int?) -> ProfileViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
    }
    
    func updateUI(at index: Int) {
        let profileDisplayed = ProfileStore.shared.getProfile(at: index)
        if profileDisplayed.id != ProfileStore.shared.getCurrentProfile()?.id {
            nameLabel.text = profileDisplayed.name
            locationLabel.text = profileDisplayed.location
        }

        
        matchButton.isHidden = false
        matchButton.tag = index
        updateCollectionView()
        
    }
    

    func transitioningUI() {
        nameLabel.text = ""
        locationLabel.text = ""
        matchButton.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "GoToChat" {
            let matchedUser = sender as! UIButton
            let destinationVC = segue.destination as! ChatViewController
            destinationVC.receiver = ProfileStore.shared.getProfile(at: matchedUser.tag).name
        }
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     
    
    // Funtion to insert picture from Firebase
    //    func setPicture (uid: String) {
    //        let imagesRef = storageRef.child("images")
    //        let userRef = imagesRef.child(uid)
    //        let fileName = uid  + "-profilepic.jpg"
    //        let fileRef = userRef.child(fileName)
    //
    //
    //        fileRef.getData(maxSize: 100 * 1024 * 1024){
    //            (data,error) in
    //
    //
    //            if let error = error {
    //                // Uh-oh, an error occurred!
    //                print(error)
    //            } else {
    //                // Data for "images" is returned
    //                let imageObtained = UIImage(data: data!)!
    //                self.profileImage.image = imageObtained
    //            }
    //        }
    //    }

    */
}

extension MainPageViewController: PageboyViewControllerDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        
        return ProfileStore.shared.numberOfProfiles()
        
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        
        return viewControllers[index]

    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        
        return nil
        
    }
    
}

extension MainPageViewController: PageboyViewControllerDelegate {
    func pageboyViewController(_ pageboyViewController: PageboyViewController, willScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollTo position: CGPoint, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didReloadWith currentViewController: UIViewController, currentPageIndex: PageboyViewController.PageIndex) {
        
    }
    
}

extension MainPageViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionViewRef = collectionView
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath)
        
        
        return cell
    }
    
    func updateCollectionView(){
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = collectionViewRef.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath)
        let imageViewRef = collectionViewRef?.cellForItem(at: indexPath)?.contentView.subviews[0] as! UIImageView
        imageViewRef.image = UIImage(named: "female-default")
        
        
        collectionViewRef?.reloadData()
        
    }

    
    
}


//Fake Profiles

//        ProfileStore.shared.addProfile(of:Profile(name: "Kean", age: 23, location: "Sunway", gender: "Male"))
//        ProfileStore.shared.addProfile(of:Profile(name: "Shafie", age: 24, location: "Sunway", gender: "Male"))
//        ProfileStore.shared.addProfile(of:Profile(name: "Kahou", age: 23, location: "I dont go gym", gender: "Male"))
//        ProfileStore.shared.addProfile(of:Profile(name: "Jayson", age: 23, location: "Penang", gender: "Male"))
//        ProfileStore.shared.addProfile(of:Profile(name: "Alex", age: 23, location: "Sunway", gender: "Male"))
//        ProfileStore.shared.addProfile(of:Profile(name: "Winnie", age: 22, location: "Brunei", gender: "Female"))
//        ProfileStore.shared.addProfile(of:Profile(name: "Magdelene", age: 23, location: "Sabah", gender: "Female"))
//        ProfileStore.shared.addProfile(of:Profile(name: "Yolanda", age: 23, location: "Penang", gender: "Female"))
//        ProfileStore.shared.addProfile(of:Profile(name: "Weichoong", age: 23, location: "Penang", gender: "Male"))
//        ProfileStore.shared.addProfile(of:Profile(name: "Ben", age: 23, location: "Clayton", gender: "Male"))


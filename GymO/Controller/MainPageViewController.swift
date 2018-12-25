//
//  MainViewController.swift
//  GymO
//
//  Created by Kean Wei Wong on 02/12/2018.
//  Copyright © 2018 GymO. All rights reserved.
//

import UIKit
import FirebaseStorage
import Pageboy

class MainPageViewController: PageboyViewController {
    
    let storageRef = Storage.storage().reference()
    
    lazy var viewControllers: [UIViewController] = {
        var viewControllers = [UIViewController]()
        for i in 0 ..< ProfileStore.shared.numberOfProfiles(){
            viewControllers.append(makeProfileViewController(at: i))
        }
        return viewControllers
    }()
    

    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        //Populating array with fake profiles
        ProfileStore.shared.addProfile(of:Profile(name: "Kean", age: 23, location: "Sunway", gender: "Male"))
        ProfileStore.shared.addProfile(of:Profile(name: "Shafie", age: 24, location: "Sunway", gender: "Male"))
        ProfileStore.shared.addProfile(of:Profile(name: "Kahou", age: 23, location: "I dont go gym", gender: "Male"))
        ProfileStore.shared.addProfile(of:Profile(name: "Jayson", age: 23, location: "Penang", gender: "Male"))
        ProfileStore.shared.addProfile(of:Profile(name: "Alex", age: 23, location: "Sunway", gender: "Male"))
        ProfileStore.shared.addProfile(of:Profile(name: "Winnie", age: 22, location: "Brunei", gender: "Female"))
        ProfileStore.shared.addProfile(of:Profile(name: "Magdelene", age: 23, location: "Sabah", gender: "Female"))
        ProfileStore.shared.addProfile(of:Profile(name: "Yolanda", age: 23, location: "Penang", gender: "Female"))
        ProfileStore.shared.addProfile(of:Profile(name: "Weichoong", age: 23, location: "Penang", gender: "Male"))
        ProfileStore.shared.addProfile(of:Profile(name: "Ben", age: 23, location: "Clayton", gender: "Male"))

        
        self.dataSource = self
        //SHafie image
//       setPicture(uid: AuthProvider.Instance.userID())
        // Do any additional setup after loading the view.
    }
    
    func makeProfileViewController(at index: Int?) -> ProfileViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
}

extension MainPageViewController: PageboyViewControllerDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        
        //Fatal Error because the app will not function if vc page and profile amount dont tally
        if viewControllers.count == ProfileStore.shared.numberOfProfiles(){
            return viewControllers.count
        }else {
            fatalError("Number of vc and number of profiles does not tally")
        }
        
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

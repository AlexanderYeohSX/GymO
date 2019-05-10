//
//  FirstCustomizationTableTViewController.swift
//  GymO
//
//  Created by Kean Wei Wong on 02/01/2019.
//  Copyright © 2019 GymO. All rights reserved.
//

import UIKit

class FirstCustomizationTableViewController: UITableViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var experience: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var userDescription: UITextField!
    @IBOutlet weak var gender: UITextField!
    
    @IBAction func doneButtonPressed(_ sender: Any) {

        if name.text != "", age.text != "", location.text != "", gender.text != "" {
            ProfileStore.shared.setCurrentProfile(as:
                Profile(name: name.text!,
                        age: Int(age.text!)!,
                        location: location.text!,
                        gender: gender.text!,
                        id: AuthProvider.Instance.userID(),
                        numberOfPictures: (ProfileStore.shared.getCurrentProfile()?.picturesForProfile.count)!
            ))
            
            ProfileStore.shared.setupCurrentProfileDb()
            dismiss(animated: true, completion: nil)
            
        } else {
            
            print("Error Doing First Time Customization")
        }
    }
    
    
    @IBAction func updateProfile(_ sender: Any) {
        
        
        //NOTE: Force unwrapping Int()! for age will be dangerous in the future

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
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
}

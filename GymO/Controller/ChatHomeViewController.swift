//
//  ChatHomeViewController.swift
//  GymO
//
//  Created by Kean Wei Wong on 08/05/2019.
//  Copyright © 2019 Kean Wei Wong. All rights reserved.
//

import UIKit

class ChatHomeViewController: UIViewController {

    let friends = ProfileStore.shared.getCurrentProfile()?.matchedUsers ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.dataSource = self
        chatTableView.delegate = self
        chatTableView.rowHeight = 72
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "ChatSegue" {
            let cellSelected = sender as! UITableViewCell
            let destinationVC = segue.destination as! ChatViewController
            destinationVC.profileDisplayed = ProfileStore.shared.getProfile(for: friends[cellSelected.tag])
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
 
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var chatTableView: UITableView!
    
    
    
}

extension ChatHomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchedCell", for: indexPath)
        cell.tag = indexPath.row
        
        let nameLabel = cell.contentView.subviews[1] as! UILabel
        //CHANGE TO GET ADDED PROFILE
        nameLabel.text = ProfileStore.shared.getMatchedProfile(for: friends[indexPath.row])?.name
        
        //print(ProfileStore.shared.getProfile(for: friends[indexPath.row])?)
        // Configure the cell...
        
        return cell
    }
}

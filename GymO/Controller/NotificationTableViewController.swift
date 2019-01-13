//
//  NotificationTableViewController.swift
//  GymO
//
//  Created by Kean Wei Wong on 08/01/2019.
//  Copyright © 2019 GymO. All rights reserved.
//

import UIKit

class NotificationTableViewController: UITableViewController {

    var notiDisplayProfile :[String] = []
    var notiDisplayPicture = UIImage(named: "female-default")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let requestSenderArray = ProfileStore.shared.getCurrentProfile()?.addedBy {
            for requestSender in requestSenderArray {
                notiDisplayProfile.append(requestSender.id)
            }
        }
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notiDisplayProfile.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath)
        
       let notiDisplayView = cell.contentView.subviews[0] as? UIView
        print(notiDisplayView?.layer.cornerRadius)
        notiDisplayView?.layer.cornerRadius = 25
        print(notiDisplayView?.layer.cornerRadius)
        let notiDisplayLabel = cell.contentView.subviews[1] as? UILabel
        let notiDisplayName = ProfileStore.shared.getRequestedProfile(for: notiDisplayProfile[indexPath.row])?.name
        notiDisplayLabel?.text = "\(notiDisplayName!) has added you!"
       // let notiDisplayView = NotificationView(frame: CGRect(x: 0, y: 0, width: 375, height: 70))
        
       // cell.contentView.addSubview(notiDisplayView)

        return cell
    }
 

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

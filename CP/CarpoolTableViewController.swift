//
//  CarpoolTableViewController.swift
//  CP
//
//  Created by Gavin Olsen on 5/20/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import UIKit

class CarpoolTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //as soon as they can see carpools, I want to 
        
        NotificationManager.shared.requestReminderAuthorization()
        EventManager.shared.requestEventAuthorization()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(self.gotCarpools(_:)), name: ParentController.CarpoolArrayNotification, object: nil)
        
    }
    
    func gotCarpools(_ notification: Notification) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return ParentController.shared.parent?.carpools.count ?? 0 }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "carpoolCell", for: indexPath)

        guard let carpool = ParentController.shared.parent?.carpools[indexPath.row] else { return UITableViewCell() }
        
        var dateString: String = ""
        
        for date in carpool.notificationTimeStrings {
            
            dateString += "\(date) "
        }
        
        cell.textLabel?.text = carpool.eventName
        cell.detailTextLabel?.text = dateString

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

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
        nc.addObserver(self, selector: #selector(self.gotCarpools(_:)), name: CarpoolController.ParentsCarpoolArrayNotification, object: nil)
        
    }
    
    func gotCarpools(_ notification: Notification) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return CarpoolController.shared.parentsCarpools.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "carpoolCell", for: indexPath)

        let carpool = CarpoolController.shared.parentsCarpools[indexPath.row]
        
        cell.textLabel?.text = carpool.eventName
        cell.detailTextLabel?.text = carpool.getTimeString()

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedCarpool = CarpoolController.shared.parentsCarpools[indexPath.row]
            ParentController.shared.removeCarpoolFromParent(carpool: deletedCarpool)
            CarpoolController.shared.parentsCarpools.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

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

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "carpoolToKidsSegue" {
            guard let destinationVC = segue.destination as? AddKidToCarpoolTableViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let carpool = CarpoolController.shared.parentsCarpools[indexPath.row]
            //shows out of range for parentsCarpoolsRecords
            
            if ParentController.shared.parentsCarpoolsRecords.count > 0 {
                carpool.ckRecord = ParentController.shared.parentsCarpoolsRecords[indexPath.row]
            } else {
                return
            }
            
            
            destinationVC.carpool = carpool
            
        }
    }

}


















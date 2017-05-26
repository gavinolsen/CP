//
//  LeaderedCarpoolsTableViewController.swift
//  CP
//
//  Created by Gavin Olsen on 5/25/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import UIKit

class LeaderedCarpoolsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return ParentController.shared.parent?.leaderdCarpools.count ?? 0 }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderedCarpoolsKids", for: indexPath)

        guard let carpool = ParentController.shared.parent?.leaderdCarpools[indexPath.row] else { return UITableViewCell() }
        
        cell.textLabel?.text = carpool.eventName
        cell.detailTextLabel?.text = carpool.passkey
        
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goingToKidsInLeaderedCarpoolSegue" {
            
            guard let destinatinoVC = segue.destination as? KidsInCarpoolTableViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guard let carpool = ParentController.shared.parent?.leaderdCarpools[indexPath.row] else { return }
            
            destinatinoVC.carpool = carpool
    }}

}


















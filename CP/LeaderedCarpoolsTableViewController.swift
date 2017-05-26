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

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //remove the carpool from the kid, parent (each the leaderd carpools and carpools...), and each in the database...
            
            guard let deletedCarpoolID = ParentController.shared.parent?.leaderdCarpools[indexPath.row].ckRecordID else { return }
            ParentController.shared.parent?.leaderdCarpools.remove(at: indexPath.row)
            
            //I want to find the leaderd carpool in the array of normal carpools...
            guard let carpools = ParentController.shared.parent?.carpools else { return }
            
            //the array of leaderd carpools isn't going to be the same
            //order as the normal carpools. and normally, there will actually
            //be more in the normal carpools. so i want to make sure that I'm 
            //deleting the right one.. so i just loop through and see if 
            //i'm hitting the right record in there, and i'll delete it 
            //according to what the variable checker is at.
            
            var checker = 0
            
            for carpool in carpools {
                if carpool.ckRecordID == deletedCarpoolID {
                    ParentController.shared.parent?.carpools.remove(at: checker)
                    break
                }
                checker += 1
            }
            
            //I also have to delete the carpool from the kid
            
            checker = 0
            
            guard let kids = ParentController.shared.parent?.kids else { return }
            
            for kid in kids {
                for carpool in kid.carpools {
                    if carpool.ckRecordID == deletedCarpoolID {
                        kid.carpools.remove(at: checker)
                        break
                    }
                    checker += 1
                }
            }

            CloudKitManager.shared.deleteRecordWithID(deletedCarpoolID, completion: { (recordID, error) in
                if error != nil || recordID == nil {
                    print("something's wrong")
                }
            })
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
        
        if segue.identifier == "goingToKidsInLeaderedCarpoolSegue" {
            
            guard let destinatinoVC = segue.destination as? KidsInCarpoolTableViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guard let carpool = ParentController.shared.parent?.leaderdCarpools[indexPath.row] else { return }
            
            destinatinoVC.carpool = carpool
    }}

}


















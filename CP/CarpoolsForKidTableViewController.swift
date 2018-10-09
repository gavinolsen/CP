//
//  CarpoolsForKidTableViewController.swift
//  CP
//
//  Created by Gavin Olsen on 5/25/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import UIKit

class CarpoolsForKidTableViewController: UITableViewController {
    
    var kid: Child?
    var carpools: [Carpool] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.title = ""
        
        guard let kidsCarpools = kid?.carpools else { return }
        carpools = kidsCarpools
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return carpools.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "carpoolForKidCell", for: indexPath)

        let carpool = carpools[indexPath.row]

        cell.textLabel?.text = carpool.getTimeString()
        cell.detailTextLabel?.text = carpool.eventName
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //first i have to find the child in the ParentController.shared.parent.kids object... then i have to find the carpool from that kid
            
            guard let kids = ParentController.shared.parent?.kids else { return }
            var checker = 0
            
            for searchedKid in kids {
                if searchedKid.ckRecordID == kid?.ckRecordID {
                    //now i have the kid. i need to delete the carpool from the child...
                    //based on the indexPath that was passed through!!
                    guard let kidID = ParentController.shared.parent?.kids[checker].ckRecordID else { return }
                    guard let carpoolID = ParentController.shared.parent?.kids[checker].carpools[indexPath.row].ckRecordID else { return }
                    CloudKitManager.shared.removeChild(childRecordID: kidID, from: carpoolID)
                    
                    ParentController.shared.parent?.kids[checker].carpools.remove(at: indexPath.row)
                }
                checker += 1
            }
            carpools.remove(at: indexPath.row)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

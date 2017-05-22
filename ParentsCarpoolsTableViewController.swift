//
//  ParentsCarpoolsTableViewController.swift
//  CP
//
//  Created by Gavin Olsen on 5/22/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import UIKit

class ParentsCarpoolsTableViewController: UITableViewController {
    
    var givenParent: Parent?
    var parentsCarpools: [Carpool] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let parentReference = givenParent?.ckReference else { print ("bad parent"); return}

        CarpoolController.shared.fetchCarpoolsForParent(reference: parentReference) {
            
            
            
        }
        
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parentsCarpools.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "parentsCarpoolCell", for: indexPath)

        let carpool = parentsCarpools[indexPath.row]
        
        cell.textLabel?.text = carpool.eventName
        
        var timestring: String = ""
        
        for string in carpool.notificationTimeStrings {
            timestring += string + ", "
        }
        
        cell.detailTextLabel?.text = timestring
        
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
    
    @IBAction func saveYourselfToCarpool(_ sender: Any) {
     
        //i want to make a reference to the parent, and 
        //save it in the carpool...
        
        guard let parent = ParentController.shared.parent else {print("bad parent from controller"); return}
        
        guard let indexPaths = tableView.indexPathsForSelectedRows else { return }
        
        for index in indexPaths {
            let carpool = parentsCarpools[index.row]
            guard let record = CarpoolController.shared.carpoolRecords?[index.row] else { print("can't retrieve the record from carpool controller"); return }
            carpool.drivers?.append(parent)
            CarpoolController.shared.modify(carpool, withRecord: record)
        }
     
        let nc = navigationController
        nc?.popViewController(animated: true)
        
    }

}









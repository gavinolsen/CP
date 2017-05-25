//
//  KidsInCarpoolTableViewController.swift
//  CP
//
//  Created by Gavin Olsen on 5/24/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import UIKit

class AddKidToCarpoolTableViewController: UITableViewController {
    
    var carpool: Carpool?

    var kids: [Child] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //now i need to fetch the kids for this carpool
        //guard let carpool = carpool else { return }
        //ChildController.shared.getKidsIn(carpool: carpool)
        
        guard let kidos = ParentController.shared.parent?.kids else { return }
        kids = kidos
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        //reset the kids array to 0
//        ChildController.shared.kids = []
//    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return kids.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kidInCarpoolCell", for: indexPath)

        let kid = kids[indexPath.row]
        
        cell.textLabel?.text = kid.name

        return cell
    }

    @IBAction func saveKidToCarpool(_ sender: Any) {
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        let kid = kids[indexPath.row]
        
        //now i need to modify the carpool
        //to have this kid in it...
        guard let carpoolRecord = carpool?.ckRecord else { return }
        
        CarpoolController.shared.modify(carpoolRecord: carpoolRecord, with: kid)
        
        let nc = navigationController
        nc?.popViewController(animated: true)
        
    }
    
    
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
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}

/*
 var kids: [Child] = []
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 //ParentController.shared.getParentInfo()
 
 let nc = NotificationCenter.default
 nc.addObserver(self, selector: #selector(updateView(_:)), name: ParentController.ChildArrayNotification, object: nil)
 
 guard let kidos = ParentController.shared.parent?.kids else { return }
 kids = kidos
 }
 
 func updateView(_ notification: Notification) {
 
 guard let kidos = ParentController.shared.parent?.kids else { return }
 kids = kidos
 
 tableView.reloadData()
 }
 
 // MARK: - Table view data source
 
 override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
 return ParentController.shared.parent?.kids.count ?? 0
 }
 
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "kidCell", for: indexPath)
 
 cell.textLabel?.text = kids[indexPath.row].name
 
 return cell
 }

 */
























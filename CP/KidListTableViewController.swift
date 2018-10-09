//
//  KidListTableViewController.swift
//  CP
//
//  Created by Gavin Olsen on 5/11/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import UIKit

class KidListTableViewController: UITableViewController {
    
    var kids: [Child] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Your kids"
        
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

        cell.textLabel?.font = UIFont(name: "GillSans-UltraBold", size: 25)
        cell.textLabel?.text = kids[indexPath.row].name
        
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if kids.count == 0 { return }
            
            let kid = kids[indexPath.row]
            ChildController.shared.deleteChild(kid: kid)
            ParentController.shared.parent?.kids.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            guard let kidID = kid.ckRecordID else { return }
            CloudKitManager.shared.deleteRecordWithID(kidID, completion: { (record, error) in
                if record == nil || error != nil {
                    print("someting went wron")
                }
            })
            CloudKitManager.shared.removeChildFromCarpools(kidID)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "kidIdentifier" {
            
            guard let destinationVC = segue.destination as? KidDetailViewController else { return }

            guard let index = tableView.indexPathForSelectedRow else { return }
            
            if kids.count == 0 { return }
            
            let kid = kids[index.row]
            
            destinationVC.kid = kid
        }
        
        
    }

}



































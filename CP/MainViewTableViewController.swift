//
//  MainViewTableViewController.swift
//  CP
//
//  Created by Gavin Olsen on 5/10/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import UIKit

class MainViewTableViewController: UITableViewController {
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var greetingView: UIView!
    
    var user: Parent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        DispatchQueue.main.async {
            ParentController.shared.getParentInfo()
            let nc = NotificationCenter.default
            nc.addObserver(self, selector: #selector(self.userChanged(_:)), name: ParentController.ParentNameChangedNotification, object: nil)
        }
    }
    
    //MARK: Observer
    func userChanged(_ notification: Notification) {
        
        guard let name = ParentController.shared.parentName else { return }
        self.greetingLabel.text = "gotcha " + name
        
        greetingView.reloadInputViews()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let kids = ParentController.shared.parent?.kids else { return 0 }
        return kids.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kidCell", for: indexPath) as? KidTableViewCell else { return UITableViewCell() }

        guard let kids = ParentController.shared.parent?.kids else { print("can't get the kids"); return UITableViewCell() }
        let kid = kids[indexPath.row]
        
        cell.setViewWith(kid: kid)
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        ParentController.shared.getParentInfo()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(userChanged(_:)), name: ParentController.ParentChangedNotification, object: nil)
        
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
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

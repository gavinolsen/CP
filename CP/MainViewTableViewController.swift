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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParentController.shared.getParentInfo()
        
        guard let name = ParentController.shared.parentName else { return }
        
        greetingLabel.text = "gotcha" + name
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

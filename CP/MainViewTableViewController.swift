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
    
        DispatchQueue.main.async {
            ParentController.shared.getParentInfo()
            let nc = NotificationCenter.default
            nc.addObserver(self, selector: #selector(self.userChanged(_:)), name: ParentController.ParentNameChangedNotification, object: nil)
            nc.addObserver(self, selector: #selector(self.gotKids(_:)), name: ParentController.ChildArrayNotification, object: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: Observers
    func userChanged(_ notification: Notification) {

        guard let name = ParentController.shared.parentName else { return }
        self.greetingLabel.text = "Hello " + name
        greetingView.reloadInputViews()
    }
    
    func gotKids(_ notification: Notification) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let kids = ParentController.shared.parent?.kids else { return 0 }
        return kids.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kidCell", for: indexPath) as? KidTableViewCell else { return UITableViewCell() }

        guard let kid = ParentController.shared.parent?.kids[indexPath.row] else { return UITableViewCell() }
        
        cell.setViewWith(kid: kid)
        
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
    }

}





















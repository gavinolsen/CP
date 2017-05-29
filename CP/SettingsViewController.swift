//
//  SettingsViewController.swift
//  CP
//
//  Created by Gavin Olsen on 5/27/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func cancelNotifications(_ sender: Any) {
        notifyUser()
    }

    func notifyUser() {
        
        let certificationAlert = UIAlertController(title: "Are you sure you want to remove all notifications for your carpools?", message: nil, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "No", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            NotificationManager.shared.removeNotifications()
            self.confirmDeletion()
        }
        certificationAlert.addAction(dismissAction)
        certificationAlert.addAction(okAction)
        present(certificationAlert, animated: true, completion: nil)
    }
    
    func confirmDeletion() {
        let confirmAlert = UIAlertController(title: "Notifications have been deleted", message: "You can always make and join other carpools", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        confirmAlert.addAction(dismissAction)
        present(confirmAlert, animated: true, completion: nil)
    }
    
}

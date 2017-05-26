//
//  JoinCarpoolViewController.swift
//  CP
//
//  Created by Gavin Olsen on 5/25/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import UIKit

class JoinCarpoolViewController: UIViewController {

    //properties:
    var carpool: Carpool?
    
    //outlets
    @IBOutlet weak var carpoolKeyTextField: UITextField!
    @IBOutlet weak var carpoolNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //actions
    
    @IBAction func searchForCarpool(_ sender: Any) {
        
        guard let keyString = carpoolKeyTextField.text else { return }
        
        if keyString == "" { return }
        
        //I need a function in my carpool controller that searches
        //for the specific keystring that was given
    
        CarpoolController.shared.fetchCarpoolWithKey(passKey: keyString) { (compleitonCarpool) in
            DispatchQueue.main.async {
                guard let fetchedCarpool = compleitonCarpool else { return }
                self.carpool = fetchedCarpool
                self.setViewWith(carpool: fetchedCarpool)
            }
        }
        
    }
    
    @IBAction func joinCarpool(_ sender: Any) {
        
        guard let carpool = carpool else { return }
        let carpoolRecord = CarpoolController.shared.carpoolRecords[0]
        ParentController.shared.joinCarpool(record: carpoolRecord)
        ParentController.shared.parent?.carpools.append(carpool)
        NotificationManager.shared.loadCarpoolToReminders(carpool: carpool)
        EventManager.shared.loadCarpoolToCalendar(carpool: carpool)
        
        print(carpool)
        let nc = navigationController
        nc?.popViewController(animated: true)
        
    }
    
    
    func setViewWith(carpool: Carpool) {
        
        //as long as this funciton is called on the main queue
        //this will be updated real time.
        
        carpoolNameLabel.text = carpool.eventName
    }
    
}

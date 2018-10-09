//
//  JoinCarpoolViewController.swift
//  CP
//
//  Created by Gavin Olsen on 5/25/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import UIKit
import CloudKit

class JoinCarpoolViewController: UIViewController {

    //properties:
    var carpool: Carpool?
    
    //outlets
    @IBOutlet weak var enterCarpoolKeyLabel: UILabel!
    @IBOutlet weak var carpoolKeyTextField: UITextField!
    @IBOutlet weak var carpoolNameLabel: UILabel!
    @IBOutlet weak var carpoolLeaderNameLabel: UILabel!
    @IBOutlet weak var carpoolTimesLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        carpoolNameLabel.fadeOut(duration: 3, delay: 0) { (_) in }
        carpoolTimesLabel.fadeOut(duration: 3, delay: 0) { (_) in }
        carpoolLeaderNameLabel.fadeOut(duration: 3, delay: 0) { (_) in }
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
        
        if ParentController.shared.parent?.kids == nil || ParentController.shared.parent?.kids.count == 0  {
            registerKidsAlert()
            return
        }
        
        getFirstChildAlertWith(carpool: carpool, and: carpoolRecord)
        
        let nc = navigationController
        nc?.popViewController(animated: true)
        
    }
    
    func getFirstChildAlertWith(carpool: Carpool, and record: CKRecord) {
        
        let alertController = UIAlertController(title: "Which of your kids will be enrolled in this carpool?", message: "Please pick one child", preferredStyle: .alert)
        alertController.view.layer.cornerRadius = 8.0
        guard let kids = ParentController.shared.parent?.kids else { return }
        
        for kid in kids {
            let kidAction = UIAlertAction(title: kid.name, style: .default, handler: { (_) in
                
                //i need to know which of the carpools of
                //the parent i need to add this kid to...
                //or maybe i can just add the kid to the carpool directly..
                
                carpool.kids?.append(kid)
                
                ParentController.shared.joinCarpool(record: record)
                CarpoolController.shared.parentsCarpools.append(carpool)
                ParentController.shared.parent?.carpools.append(carpool)
                NotificationManager.shared.loadCarpoolToReminders(carpool: carpool)
                EventManager.shared.loadCarpoolToCalendar(carpool: carpool)
                
                let nc = self.navigationController
                nc?.popViewController(animated: true)
                
            })
            alertController.addAction(kidAction)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    
    func setViewWith(carpool: Carpool) {
        
        carpoolNameLabel.text = carpool.eventName
        carpoolTimesLabel.text = carpool.getTimeString()
        carpoolLeaderNameLabel.text = carpool.leaderName
        
        carpoolNameLabel.fadeIn(duration: 4, delay: 0) { (_) in }
        carpoolTimesLabel.fadeIn(duration: 4, delay: 0) { (_) in }
        carpoolLeaderNameLabel.fadeIn(duration: 4, delay: 0) { (_) in }
        
    }
    
    func registerKidsAlert() {
        let enterNameAlertController = UIAlertController(title: "You must register at least one child before making a carpool", message: "You can do this from the Family tab below", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        enterNameAlertController.addAction(dismiss)
        present(enterNameAlertController, animated: true, completion: nil)
    }
    
}

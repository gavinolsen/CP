//
//  MainViewTableViewController.swift
//  CP
//
//  Created by Gavin Olsen on 5/10/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class MainViewTableViewController: UITableViewController {
    
    //MARK: labels
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var greetingView: UIView!
    
    
    //MARK: carpool labels
    @IBOutlet weak var carpoolsTodayCountLabel: UILabel!
    @IBOutlet weak var carpoolsTodayDetailsLabel: UILabel!
    @IBOutlet weak var carpoolsTomorrowCountLabel: UILabel!
    @IBOutlet weak var carpoolsTomorrowDetailsLabel: UILabel!
    @IBOutlet weak var carpoolsWeeklyCountLabel: UILabel!
    
    static let shared = MainViewTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        DispatchQueue.main.async {
            ParentController.shared.getParentInfo()
            let nc = NotificationCenter.default
            nc.addObserver(self, selector: #selector(self.userChanged(_:)), name: ParentController.ParentNameChangedNotification, object: nil)
            nc.addObserver(self, selector: #selector(self.gotKids(_:)), name: ParentController.ChildArrayNotification, object: nil)
            nc.addObserver(self, selector: #selector(self.gotCarpools(_:)), name: ParentController.CarpoolArrayNotification, object: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: Observers
    func userChanged(_ notification: Notification) {

        guard let name = ParentController.shared.parentName else { return }
        
        if name == "" {
            print("need to get the name")
            getName()
        }
        self.greetingLabel.text = "Hello " + name
        greetingView.reloadInputViews()
    }
    
    
    func gotKids(_ notification: Notification) {
        tableView.reloadData()
    }
    
    func gotCarpools(_ notification: Notification) {
        
        
        //I need to get the current day so that I know
        //how many carpools fall on this day, as well as tomorrow...
        guard let carpools = ParentController.shared.parent?.carpools else { return }
        if carpools.count == 0 {
            return
        }
        setLabels(carpools: carpools)
    }
    
    func setLabels(carpools: [Carpool]) {
        var todaysCarpoolCount = 0
        var todaysCarpoolString = ""
        var tomorrowsCarpoolCount = 0
        var tomorrowsCarpoolString = ""
        var drives = 0
        
        //this function from event manager
        //is giving back the day of the month
        //i need the day of the week...
        let today = EventManager.shared.getWeekDay()
        
        for carpool in carpools {
            
            //i need an integer to count through
            //evetything so that i have a way to
            //reference the minutes and the seconds as well...
            
            for i in 0...carpool.notificationDays.count - 1 {
                if carpool.notificationDays[i] == today {
                    todaysCarpoolCount += 1
                    todaysCarpoolString += "\(getTimeString(hour: carpool.notificationHours[i], minutes: carpool.notificationMinutes[i]))"
            
                    //i want to know if this is the last time that will be added
                    
                } else if carpool.notificationDays[i] == today + 1 {
                    tomorrowsCarpoolCount += 1
                    tomorrowsCarpoolString += "\(getTimeString(hour: carpool.notificationHours[i], minutes: carpool.notificationMinutes[i]))"
                }
                drives += 1
            }
            
        }
        
        DispatchQueue.main.async {
            
            //now i have everything that I need, so i'll set the labels...
            self.carpoolsTodayCountLabel.text = "You have \(self.getPluralCarpool(num: todaysCarpoolCount)) scheduled today:"
            self.carpoolsTodayDetailsLabel.text = self.getTimeStringFrom(timeString: todaysCarpoolString)
            self.carpoolsTomorrowCountLabel.text = "You have \(self.getPluralCarpool(num: tomorrowsCarpoolCount)) scheduled tomorrow:"
            self.carpoolsTomorrowDetailsLabel.text = self.getTimeStringFrom(timeString: tomorrowsCarpoolString)
            self.carpoolsWeeklyCountLabel.text = "There will be \(self.getDrives(num: drives)) this week"
        }
    }
    
    func getTimeStringFrom(timeString: String) -> String {
        
        var mod = timeString.components(separatedBy: "M").joined(separator: "M,").components(separatedBy: ",")
        
        mod.remove(at: mod.count - 1)
        
        var modedStringArray = ""
        
        for time in mod {
            if time != mod.last {
                modedStringArray += time + ", "
            } else {
                modedStringArray += time
            }
        }
        return modedStringArray
    }
    
    func getDrives(num: Int) -> String {
        
        if num == 0 {
            return "no carpool drives"
        } else if num == 1 {
            return "1 carpool drive"
        } else {
            return "\(num) carpool drives"
        }
    }
    
    func getPluralCarpool(num: Int) -> String {
        if num == 0 {
            return "no carpools"
        } else if num == 1 {
            return "\(num) carpool"
        } else {
            return "\(num) carpools"
        }
    }
    
    func getTimeString(hour: Int, minutes minuteRecieved: Int) -> String {
        
        var minuteReturned = ""
        
        if minuteRecieved < 10 {
            minuteReturned = "0\(minuteRecieved)"
        } else {
            minuteReturned = "\(minuteRecieved)"
        }
        
        if hour <= 12 {
            return "\(hour):\(minuteReturned) AM"
        } else {
            return "\(hour - 12):\(minuteReturned) PM"
        }
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
        
        if segue.identifier == "kidsCarpoolSegue" {
            
            guard let destinationVC = segue.destination as? CarpoolsForKidTableViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            //carpools is assigned as 0... we need to assign the carpools of each kid. 
            //the best place to do this would be in the getParentInfo() function
            //of the ParentController class. when we have the record of each kid,
            //we can search for the carpools of each kid and append them to the
            //kid.carpool property of the parent. perfecto...
            
            guard let kid = ParentController.shared.parent?.kids[indexPath.row] else { return }
            
            destinationVC.kid = kid
        }
        
    }

    //MARK: - EventKit
    
    func getName() {
        var alertTextField: UITextField?
        let alertController = UIAlertController(title: "Name:", message: "Please enter your name", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            alertTextField = textField
        }
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        
        //here is where we add the text
        let addAction = UIAlertAction(title: "Add", style: .cancel) { _ in
            guard let text = alertTextField?.text, !text.isEmpty else { return }
            
            ParentController.shared.makeParentWithName(name: text)
        }
        
        alertController.addAction(dismissAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true, completion: nil)
        
    }

}





















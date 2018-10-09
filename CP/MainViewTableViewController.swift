 //
//  MainViewTableViewController.swift
//  CP
//
//  Created by Gavin Olsen on 5/10/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import UIKit

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
    
    let carpool = Carpool(name: "g car", timeStrings: ["1", "2", "2", "2"], days: [1,3,5], hours: [16,15,14], minutes: [0, 30, 0], passkey: "passkey", leaderName: "Gavin")
    
    var mockKids: [Child] = []
    
    static let shared = MainViewTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let kid1 = Child(name: "g kid", age: 10, details: "mmeememememe", parent: nil, carpools: [self.carpool, carpool, carpool, carpool, carpool], ckReference: nil)
        
        mockKids = [kid1]
        
        DispatchQueue.main.async {
            //now I'm going to chang it, so that I will get the name of the parent for 
            //the first time, no matter what...
            
            self.setupViews()
            
            //MARK:
            ParentController.shared.getParentInfo()
            self.addObservers()
            
            //I want to check if the user has logged in before. I'll
            //make a function in parentController that will make a 
            //variable and store it to the user defaults...
        }
//        performSegue(withIdentifier: "introSegue", sender: nil)
        checkForIntro()
    }
    
    func setupViews() {
        let font = UIFont(name: "AppleSDGothicNeo-Thin", size: 18)
        let bigFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        
        greetingLabel.font = bigFont
        
        carpoolsTodayCountLabel.font = font
        carpoolsTodayDetailsLabel.font = font
        carpoolsTomorrowCountLabel.font = font
        carpoolsTomorrowDetailsLabel.font = font
        carpoolsWeeklyCountLabel.font = font
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: Observers
    func userChanged(_ notification: Notification) {
        
        if ParentController.shared.parentName == "" || ParentController.shared.parentName == nil {
            getName()
            return
        }
        
        guard let name = ParentController.shared.parentName else { return }
        
        self.greetingLabel.text = "Hello " + name
        greetingView.reloadInputViews()
    }
    
    func gotKids(_ notification: Notification) {
        tableView.reloadData()
    }
    
    func gotCarpools(_ notification: Notification) {
        //I need to get the current day so that I know
        //how many carpools fall on this day, as well as tomorrow...
        let carpools = CarpoolController.shared.parentsCarpools
        if carpools.count == 0 {
            resetLabels()
        } else {
            setLabels(carpools: carpools)
        }
    }
    
    func resetLabels() {
        
        DispatchQueue.main.async {
            
            self.carpoolsTodayCountLabel.text = "Congrats"
            self.carpoolsTodayDetailsLabel.text = "You're free"
            self.carpoolsTomorrowCountLabel.text = "No more carpools!!!"
            self.carpoolsTomorrowDetailsLabel.text = "It must be summer"
            self.carpoolsWeeklyCountLabel.text = "Or you just lost your license..."
        }
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
            
            self.carpoolsTodayCountLabel.text = "You have \(self.getPluralCarpool(num: todaysCarpoolCount)) today:"
            self.carpoolsTodayDetailsLabel.text = self.getTimeStringFrom(timeString: todaysCarpoolString)
            self.carpoolsTomorrowCountLabel.text = "You have \(self.getPluralCarpool(num: tomorrowsCarpoolCount)) tomorrow:"
            self.carpoolsTomorrowDetailsLabel.text = self.getTimeStringFrom(timeString: tomorrowsCarpoolString)
            self.carpoolsWeeklyCountLabel.text = "There will be \(self.getDrives(num: drives)) this week"
            
        }
    }
    
    
    func getTimeStringFrom(timeString: String) -> String {
        
        var mod = timeString.components(separatedBy: "M").joined(separator: "M,").components(separatedBy: ",")
        
        mod.remove(at: mod.count - 1)
        
        var modedStringArray = ""
        var counter = 1
        
        if mod.count == 1 {
            return mod[0]
        }
        
        for time in mod {
            if mod.count > counter {
                modedStringArray += time + ", "
            } else {
                modedStringArray += "& " + time
            }
            counter += 1
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

    func addObservers() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(self.userChanged(_:)), name: ParentController.ParentNameChangedNotification, object: nil)
        nc.addObserver(self, selector: #selector(self.gotKids(_:)), name: ParentController.ChildArrayNotification, object: nil)
        nc.addObserver(self, selector: #selector(self.gotCarpools(_:)), name: CarpoolController.ParentsCarpoolArrayNotification, object: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let kids = ParentController.shared.parent?.kids else { return 0 }
        return kids.count
//        return mockKids.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kidCell", for: indexPath) as? KidTableViewCell else { return UITableViewCell() }

        guard let kid = ParentController.shared.parent?.kids[indexPath.row] else { return UITableViewCell() }
        
//        let kid = mockKids[indexPath.row]
        
        cell.setViewWith(kid: kid)
        
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "kidsCarpoolSegue" {
            
            guard let destinationVC = segue.destination as? CarpoolsForKidTableViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            guard let kid = ParentController.shared.parent?.kids[indexPath.row] else { return }
            
            destinationVC.kid = kid
        }
        
    }
    
    //MARK: - INTROOOOOO
    
    func checkForIntro() {
        if ParentController.shared.checkIfParentNeedsIntro() {
            performSegue(withIdentifier: "introSegue", sender: nil)
        } else {
            return
        }
    }
    
    func pracDates() {
    
        let carpool = Carpool(name: "g car", timeStrings: ["1", "2", "2", "2"], days: [1,3,5], hours: [16,15,14], minutes: [0, 30, 0], passkey: "passkey", leaderName: "Gavin")
        EventManager.shared.loadCarpoolToCalendar(carpool: carpool)
    }

    //MARK: - Alerts
    
    func getName() {
        var alertTextField: UITextField?
        let alertController = UIAlertController(title: "Please enter your name", message: "You only have to enter it once. We will always refer to you by this name from now on. You won't be able to save any information until you have saved a name", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            alertTextField = textField
        }
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        
        //here is where we add the text
        let addAction = UIAlertAction(title: "Add", style: .cancel) { _ in
            guard let text = alertTextField?.text, !text.isEmpty else { return }
            
            ParentController.shared.makeNewParent(nameString: text)
        }
        alertController.addAction(dismissAction)
        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
    }
}





















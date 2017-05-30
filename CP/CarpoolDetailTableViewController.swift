//
//  CarpoolDetailTableViewController.swift
//  CP
//
//  Created by Gavin Olsen on 5/11/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import UIKit
import EventKit
import UserNotifications

class CarpoolDetailTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var carpoolDetailView: UIView!
    let dayPickerLabel = UILabel()
    let dayPicker = UIPickerView()
    let carpoolNameLabel = UILabel()
    let carpoolTextField = UITextField()
    
    //MARK: properties
    var carpool: Carpool?
    var times: [Date]?
    var firstKid: Child?
    
    //dayString: day, hourString: hour, minuteString: minute, isPm: isPm,
    //arrays i need to save a carpool
    
    var days: [Int] = []
    var hours: [Int] = []
    var minutes: [Int] = []
    var isPmArray: [Bool] = []
    
    //might not need
    var calendar: EKCalendar!
    var timeArray: [String] = []
    var carpoolDateComponents: [DateComponents] = []

    //MARK: setup picker
    let daysOfWeek = ["Mon", "Tues", "Wed", "Thur", "Fri", "Sat"]
    let hoursOfDay = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    var minutesOfHour: [String] {
        var arrayOfMin: [String] = []
        
        for i in 0...60 {
            
            var min = ""
            
            if i < 10 {
                min = "0\(i)"
            } else {
                min = "\(i)"
            }
            arrayOfMin.append(min)
        }
        return arrayOfMin
    }
    let amPm = ["AM", "PM"]
    
    var pickerData: [[String]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.dayPicker.delegate = self
        self.dayPicker.dataSource = self
        
        pickerData = [daysOfWeek, hoursOfDay, minutesOfHour, amPm]
        
        setupViews()
        setupConstraints()
        setKeyboards()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height - 100
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height - 100
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return timeArray.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "carpoolTimeCell", for: indexPath)

        cell.textLabel?.text = timeArray[indexPath.row]

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            days.remove(at: indexPath.row)
            hours.remove(at: indexPath.row)
            minutes.remove(at: indexPath.row)
            isPmArray.remove(at: indexPath.row)
            
            carpoolDateComponents.remove(at: indexPath.row)
            timeArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    @IBAction func addTimeToCarpool(_ sender: Any) {
        addCarpoolTime()
    }
    
    @IBAction func saveCarpoolToParent(_ sender: Any) {
        //make sure the carpool will have a name
        if carpoolTextField.text == "" {
            enterNameAlert()
            return
        }
        
        //make sure the user has enterd in a time
        if timeArray.count == 0 {
            noTimesEnteredAlert()
            return
        }
        
        //make sure there are kids
        if ParentController.shared.parent?.kids.count == 0 || ParentController.shared.parent?.kids == nil || ParentController.shared.parent == nil {
            registerKidsAlert()
            return
        }
        NotificationManager.shared.makeNewNotificationsWith(name: carpoolTextField.text ?? "Planned Activity", and: carpoolDateComponents)
        getFirstChildAlert()
    }
}

extension CarpoolDetailTableViewController: UIPickerViewDelegate, UIPickerViewDataSource  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return pickerData.count }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return pickerData[component].count}
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return pickerData[component][row] }
    
    func setupViews() {
        
        dayPickerLabel.text = "Enter time of event:"
        carpoolNameLabel.text = "Enter carpool name:"
        carpoolTextField.placeholder = "carpool name"
        
        carpoolTextField.returnKeyType = .done
        carpoolTextField.delegate = self
        
        carpoolDetailView.addSubview(dayPickerLabel)
        carpoolDetailView.addSubview(dayPicker)
        carpoolDetailView.addSubview(carpoolNameLabel)
        carpoolDetailView.addSubview(carpoolTextField)
    }
    
    func setupConstraints() {
        
        dayPickerLabel.translatesAutoresizingMaskIntoConstraints = false
        dayPicker.translatesAutoresizingMaskIntoConstraints = false
        carpoolNameLabel.translatesAutoresizingMaskIntoConstraints = false
        carpoolTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let pickerLablTop = NSLayoutConstraint(item: dayPickerLabel, attribute: .top, relatedBy: .equal, toItem: carpoolDetailView, attribute: .top, multiplier: 1, constant: 0)
        let pickerLabelLeading = NSLayoutConstraint(item: dayPickerLabel, attribute: .leading, relatedBy: .equal, toItem: carpoolDetailView, attribute: .leading, multiplier: 1, constant: 0)
        let pickerLabelTrailing = NSLayoutConstraint(item: dayPickerLabel, attribute: .trailing, relatedBy: .equal, toItem: carpoolDetailView, attribute: .trailing, multiplier: 1, constant: 0)
        carpoolDetailView.addConstraints([pickerLablTop, pickerLabelLeading, pickerLabelTrailing])
        
        let pickerTop = NSLayoutConstraint(item: dayPicker, attribute: .top, relatedBy: .equal, toItem: dayPickerLabel, attribute: .bottom, multiplier: 1, constant: 0)
        let pickerLeading = NSLayoutConstraint(item: dayPicker, attribute: .leading, relatedBy: .equal, toItem: carpoolDetailView, attribute: .leading, multiplier: 1, constant: 0)
        let pickerTrailing = NSLayoutConstraint(item: dayPicker, attribute: .trailing, relatedBy: .equal, toItem: carpoolDetailView, attribute: .trailing, multiplier: 1, constant: 0)
        carpoolDetailView.addConstraints([pickerTop, pickerLeading, pickerTrailing])
        
        let carpoolNameTop = NSLayoutConstraint(item: carpoolNameLabel, attribute: .top, relatedBy: .equal, toItem: dayPicker, attribute: .bottom, multiplier: 1, constant: 0)
        let carpoolNameLead = NSLayoutConstraint(item: carpoolNameLabel, attribute: .leading, relatedBy: .equal, toItem: carpoolDetailView, attribute: .leading, multiplier: 1, constant: 0)
        let carpoolNameTrail = NSLayoutConstraint(item: carpoolNameLabel, attribute: .trailing, relatedBy: .equal, toItem: carpoolDetailView, attribute: .trailing, multiplier: 1, constant: 0)
        carpoolDetailView.addConstraints([carpoolNameLead, carpoolNameTop, carpoolNameTrail])
        
        let carpoolTextTop = NSLayoutConstraint(item: carpoolTextField, attribute: .top, relatedBy: .equal, toItem: carpoolNameLabel, attribute: .bottom, multiplier: 1, constant: 0)
        let carpooltextLead = NSLayoutConstraint(item: carpoolTextField, attribute: .leading, relatedBy: .equal, toItem: carpoolDetailView, attribute: .leading, multiplier: 1, constant: 0)
        let carpooltextTrail = NSLayoutConstraint(item: carpoolTextField, attribute: .trailing, relatedBy: .equal, toItem: carpoolDetailView, attribute: .trailing, multiplier: 1, constant: 0)
        carpoolDetailView.addConstraints([carpoolTextTop, carpooltextLead, carpooltextTrail])
    }
    
    func setKeyboards() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(CarpoolDetailTableViewController.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.carpoolTextField.inputAccessoryView = keyboardToolbar
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}


extension CarpoolDetailTableViewController {
    
    //in this extension i'll make the functionality to add a date to the carpool
    //as well as saving the carpool to the parent's array of carpools!
    
    func addCarpoolTime() {
        
        let selectedDayRow = dayPicker.selectedRow(inComponent: 0)
        let day = daysOfWeek[selectedDayRow]
        let selectedHourRow = dayPicker.selectedRow(inComponent: 1)
        let hour = hoursOfDay[selectedHourRow]
        let selectedMinuteRow = dayPicker.selectedRow(inComponent: 2)
        let minute = minutesOfHour[selectedMinuteRow]
        let amOrPmRow = dayPicker.selectedRow(inComponent: 3)
        let amOrPm = amPm[amOrPmRow]
        
        var isPm: Bool = false
        if amOrPm == "PM" {
            isPm = true
        }
        
        //I want to make the date from ^^^ into a date that can be found
        //dayString: day, hourString: hour, minuteString: minute, isPm: isPm,
        
        let dayInt = NotificationManager.shared.getSelectedDay(day: day)
        
        guard var hourInt = Int(hour) else { return }
        guard let minuteInt = Int(minute) else { return }
        
        if isPm {
            hourInt += 12
        }
        
        days.append(dayInt)
        hours.append(hourInt)
        minutes.append(minuteInt)
        isPmArray.append(isPm)
        
        let timeString = "\(day) \(hour):\(minute) \(amOrPm)"
        
        let weeklyComponents = DateComponents(calendar: nil, timeZone: nil, era: nil, year: NotificationManager.shared.getYear(), month: NotificationManager.shared.getMonth(), day: nil, hour: hourInt, minute: minuteInt, second: nil, nanosecond: nil, weekday: dayInt, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        carpoolDateComponents.append(weeklyComponents)
        timeArray.append(timeString)
        tableView.reloadData()
    }
    
    func saveCarpool() {
        
        guard let parent = ParentController.shared.parent else { return }
        guard let firstKid = firstKid else { return }
        guard let newCarpool = CarpoolController.shared.makeNewCarpool(name: carpoolTextField.text ?? "new carpool default name", timeStrings: timeArray, days: days, hours: hours, minutes: minutes, components: carpoolDateComponents, kids: [firstKid], leader: parent, driver: parent, completion: { (passkey) in
            guard let key = passkey else { return }
            self.alertUserOfPassKey(passKey: key)
        }) else { return }
        
        guard let kids = ParentController.shared.parent?.kids else { return }
        
        for kid in kids {
            if kid.ckRecordID?.recordName == firstKid.ckRecordID?.recordName {
                kid.carpools.append(newCarpool)
                break
            }
        }
        
        //i need to know which kid is the parents 
        //in the order, so i know which kid to append the carpool to...
    
        CarpoolController.shared.parentsCarpools.append(newCarpool)
        ParentController.shared.parent?.leaderdCarpools.append(newCarpool)
        NotificationManager.shared.loadCarpoolToReminders(carpool: newCarpool)
        EventManager.shared.loadCarpoolToCalendar(carpool: newCarpool)
        
    }
    
    //MARK: all my alerts----
    //here will be my function for presenting the alert view...
    
    func getFirstChildAlert() {
        
        let alertController = UIAlertController(title: "Which of your kids will be enrolled in this carpool?", message: "Please pick one child", preferredStyle: .alert)
        alertController.view.layer.cornerRadius = 8.0
        guard let kids = ParentController.shared.parent?.kids else { return }
        
        for kid in kids {
            let kidAction = UIAlertAction(title: kid.name, style: .default, handler: { (_) in
                self.firstKid = kid
                self.saveCarpool()
            })
            alertController.addAction(kidAction)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: TODO--------
    func alertUserOfPassKey(passKey: String) {
        
        let passAlertController = UIAlertController(title: passKey, message: "Other parents who want to join your carpool will need this key. You can find it again in your leaderd carpools tab.", preferredStyle: .alert)
        passAlertController.view.layer.cornerRadius = 8
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
            let nc = self.navigationController
            nc?.popViewController(animated: true)
        })
        passAlertController.addAction(dismissAction)
        present(passAlertController, animated: true, completion: nil)
    }
    
    //the following two
    //could be condensed 
    //into a function that
    //passes in the title as a parameter...
    
    func enterNameAlert() {
        let enterNameAlertController = UIAlertController(title: "You must enter a name before saving your carpool", message: nil, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        enterNameAlertController.addAction(dismiss)
        present(enterNameAlertController, animated: true, completion: nil)
    }
    
    func registerKidsAlert() {
        let enterNameAlertController = UIAlertController(title: "You must register at least one child before making a carpool", message: "You can do this from the Family tab below", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        enterNameAlertController.addAction(dismiss)
        present(enterNameAlertController, animated: true, completion: nil)
    }
    
    func noTimesEnteredAlert() {
        let enterNameAlertController = UIAlertController(title: "You must add at least one time before registering a carpool", message: "You can do this by tapping the Add Time button above", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        enterNameAlertController.addAction(dismiss)
        present(enterNameAlertController, animated: true, completion: nil)
    }
    
}

/*
 The usual solution is to slide the field (and everything above it) up with an animation, and then back down when you are done. You may need to put the text field and some of the other items into another view and slide the view as a unit. (I call these things "plates" as in "tectonic plates", but that's just me). But here is the general idea if you don't need to get fancy.
 
 - (void)textFieldDidBeginEditing:(UITextField *)textField
 {
 [self animateTextField: textField up: YES];
 }
 
 
 - (void)textFieldDidEndEditing:(UITextField *)textField
 {
 [self animateTextField: textField up: NO];
 }
 
 - (void) animateTextField: (UITextField*) textField up: (BOOL) up
 {
 const int movementDistance = 80; // tweak as needed
 const float movementDuration = 0.3f; // tweak as needed
 
 int movement = (up ? -movementDistance : movementDistance);
 
 [UIView beginAnimations: @"anim" context: nil];
 [UIView setAnimationBeginsFromCurrentState: YES];
 [UIView setAnimationDuration: movementDuration];
 self.view.frame = CGRectOffset(self.view.frame, 0, movement);
 [UIView commitAnimations];
 
 */





























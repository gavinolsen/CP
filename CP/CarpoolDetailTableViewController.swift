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

class CarpoolDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var carpoolDetailView: UIView!
    let dayPickerLabel = UILabel()
    let dayPicker = UIPickerView()
    let carpoolNameLabel = UILabel()
    let carpoolTextField = UITextField()
    
    //MARK: properties
    var carpool: Carpool?
    var times: [Date]?
    
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
        
        self.dayPicker.delegate = self
        self.dayPicker.dataSource = self
        
        pickerData = [daysOfWeek, hoursOfDay, minutesOfHour, amPm]
        
        setupViews()
        setupConstraints()
        setKeyboards()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return timeArray.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "carpoolTimeCell", for: indexPath)

        cell.textLabel?.text = timeArray[indexPath.row]

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    @IBAction func addTimeToCarpool(_ sender: Any) {
        addCarpoolTime()
    }
    
    @IBAction func saveCarpoolToParent(_ sender: Any) {
        saveCarpool()
        let nc = navigationController
        nc?.popViewController(animated: true)
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
        
        let pickerTop = NSLayoutConstraint(item: dayPicker, attribute: .top, relatedBy: .equal, toItem: dayPickerLabel, attribute: .bottom, multiplier: 1, constant: -10)
        let pickerLeading = NSLayoutConstraint(item: dayPicker, attribute: .leading, relatedBy: .equal, toItem: carpoolDetailView, attribute: .leading, multiplier: 1, constant: 0)
        let pickerTrailing = NSLayoutConstraint(item: dayPicker, attribute: .trailing, relatedBy: .equal, toItem: carpoolDetailView, attribute: .trailing, multiplier: 1, constant: 0)
        carpoolDetailView.addConstraints([pickerTop, pickerLeading, pickerTrailing])
        
        let carpoolNameTop = NSLayoutConstraint(item: carpoolNameLabel, attribute: .top, relatedBy: .equal, toItem: dayPicker, attribute: .bottom, multiplier: 1, constant: -10)
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
        
        var name = "default carpool name"
        
        if carpoolTextField.text != "" {
            name = carpoolTextField.text!
        }
        
        NotificationManager.shared.makeNewNotificationWith(carpoolName: name, dayString: day, hourString: hour, minuteString: minute, isPm: isPm, completion: { (components) in
            self.carpoolDateComponents.append(components)
        })
        timeArray.append(timeString)
        tableView.reloadData()
        
    }
    
    func addTime(){
        
        let selectedDayRow = dayPicker.selectedRow(inComponent: 0)
        let day = daysOfWeek[selectedDayRow]
        let selectedHourRow = dayPicker.selectedRow(inComponent: 1)
        let hour = hoursOfDay[selectedHourRow]
        let selectedMinuteRow = dayPicker.selectedRow(inComponent: 2)
        let minute = minutesOfHour[selectedMinuteRow]
        let amOrPmRow = dayPicker.selectedRow(inComponent: 3)
        let amOrPm = amPm[amOrPmRow]
        
        print( day + " " + hour + " " + minute + " " + amOrPm )
        
        guard let calendarEvent = EventManager.shared.eventStore.calendar(withIdentifier: calendar.calendarIdentifier) else { print("can't get calendar with key"); return }
        
        let newEvent = EKEvent(eventStore: EventManager.shared.eventStore)
        
        newEvent.calendar = calendarEvent
        newEvent.title = carpoolTextField.text ?? "default name"
        
        
    }
    
    func saveCarpool() {
        
        guard let parent = ParentController.shared.parent else { return }
        let newCarpool = Carpool(name: carpoolTextField.text ?? "new carpool default name", timeStrings: timeArray, days: days, hours: hours, minutes: minutes, components: carpoolDateComponents, leader: parent)
        newCarpool.drivers?.append(parent)
        CarpoolController.shared.save(newCarpool)
        ParentController.shared.parent?.carpools.append(newCarpool)
        
        EventManager.shared.loadCarpoolToCalendar(carpool: newCarpool)
        
    }
}































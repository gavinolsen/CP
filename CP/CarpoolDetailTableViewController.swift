//
//  CarpoolDetailTableViewController.swift
//  CP
//
//  Created by Gavin Olsen on 5/11/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import UIKit
import EventKit

class CarpoolDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var carpoolDetailView: UIView!
    let dayPicker = UIPickerView()
    
    var carpool: Carpool?
    var times: [Date]?
    
    /*
     i'm going to have 4 arrays of strings
     1- day of the week
     2- hour of the day
     3- minute of the hour
     4- am/pm
     */

    let daysOfWeek = ["Mon", "Tues", "Wed", "Thur", "Fri", "Sat", "Sun"]
    let hoursOfDay = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    var minutesOfHour: [String] {
        var arrayOfMin: [String] = [""]
        
        for i in 1...60 {
            
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
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "carpoolDateCell", for: indexPath)

        // Configure the cell...

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
        addTime()
    }
    
    @IBAction func saveCarpoolToParent(_ sender: Any) {
        saveCarpool()
    }
    
}

extension CarpoolDetailTableViewController: UIPickerViewDelegate, UIPickerViewDataSource  {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return pickerData.count }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return pickerData[component].count}
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return pickerData[component][row] }
    
    func setupViews() {
        
        carpoolDetailView.addSubview(dayPicker)
    }
    
    func setupConstraints() {
        
        
        dayPicker.translatesAutoresizingMaskIntoConstraints = false
        
        let pickerTop = NSLayoutConstraint(item: dayPicker, attribute: .top, relatedBy: .equal, toItem: carpoolDetailView, attribute: .top, multiplier: 1, constant: 0)
        let pickerLeading = NSLayoutConstraint(item: dayPicker, attribute: .leading, relatedBy: .equal, toItem: carpoolDetailView, attribute: .leading, multiplier: 1, constant: 0)
        let pickerTrailing = NSLayoutConstraint(item: dayPicker, attribute: .trailing, relatedBy: .equal, toItem: carpoolDetailView, attribute: .trailing, multiplier: 1, constant: 0)
        
        carpoolDetailView.addConstraints([pickerTop, pickerLeading, pickerTrailing])
        
    }
}


extension CarpoolDetailTableViewController {
    
    //in this extension i'll make the functionality to add a date to the carpool
    //as well as saving the carpool to the parent's array of carpools!
    
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
        
    }
    
    func saveCarpool() {
        
    }
}

/*
 let daysOfWeek = ["Mon", "Tues", "Wed", "Thur", "Fri", "Sat", "Sun"]
 let hoursOfDay = ["1","2","3","4","5","6","7","8","9","10","11","12"]
 var minutesOfHour: [String] {
 var arrayOfMin: [String] = [""]
 
 for i in 1...60 {
 
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
 */

































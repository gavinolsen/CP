//
//  NotificationManager.swift
//  CP
//
//  Created by Gavin Olsen on 5/20/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import Foundation
import UserNotifications
import UserNotificationsUI

class NotificationManager {
    
    static let notificaionIdentifier = "from_carpool_app"
    
    static let shared = NotificationManager()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestNotificationAuthorization() {
        
        notificationCenter.requestAuthorization(options: .alert) { (granted, error) in
            if !granted || error != nil {
                print("something's wrong")
            }
        }
    }
    
    func makeNewNotificationWith(carpoolName: String, dayString: String, hourString: String, minuteString: String, isPm: Bool, completion: ((_ request: DateComponents) -> Void)) {
        
        let nc = UNMutableNotificationContent()
        nc.title = carpoolName
        nc.body = "Don't forget to take the kids to the activity"
        
        guard var hour = Int(hourString) else { return }
        guard let minute = Int(minuteString) else { return }
    
        if isPm {
            hour += 12
        }
        
        let day = getSelectedDay(day: dayString)
        let month = getMonth()
        let year = getYear()
        
        let weeklyComponents = DateComponents(calendar: nil, timeZone: nil, era: nil, year: year, month: month, day: day, hour: hour, minute: minute, second: nil, nanosecond: nil, weekday: day, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
    
        let weeklyTrigger = UNCalendarNotificationTrigger(dateMatching: weeklyComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: NotificationManager.notificaionIdentifier, content: nc, trigger: weeklyTrigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("error pushing notification:\(String(describing: error))")
        }}
        
        completion(weeklyComponents)
        
    }
    
    func getDayOfWeek()->Int {
        let todayDate = Date()
        let myCalendar = NSCalendar(calendarIdentifier: .gregorian)
        let myComponents = myCalendar?.components(.weekday, from: todayDate)
        let weekDay = myComponents?.weekday
        return weekDay ?? 0
    }
    
    func getYear() -> Int {
        
        let todayDate = Date()
        let myCalendar = NSCalendar(calendarIdentifier: .gregorian)
        let myComponents = myCalendar?.components(.year, from: todayDate)
        let year = myComponents?.year
        return year ?? 0
    }
    
    func getMonth() -> Int {
        
        let todayDate = Date()
        let myCalendar = NSCalendar(calendarIdentifier: .gregorian)
        let myComponents = myCalendar?.components(.month, from: todayDate)
        let month = myComponents?.month
        return month ?? 0
    }
    
    func getSelectedDay(day: String) -> Int {
        switch day {
        case "Sun":
            return 1
        case "Mon":
            return 2
        case "Tues":
            return 3
        case "Wed":
            return 4
        case "Thur":
            return 5
        case "Fri":
            return 6
        case "Sat":
            return 7
        default:
            return 0
        }
    }

}














//
//  NotificationManager.swift
//  CP
//
//  Created by Gavin Olsen on 5/20/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import Foundation
import EventKit
import UserNotifications
import UserNotificationsUI

class NotificationManager {
    
    static let notificaionIdentifier = "from_carpool_app"
    
    static let shared = NotificationManager()
    
    let eventStore = EKEventStore()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestNotificationAuthorization() {
        
        notificationCenter.requestAuthorization(options: .alert) { (granted, error) in
            if !granted || error != nil {
                print("something's wrong")
            }
        }
    }
    
    func requestReminderAuthorization() {
        eventStore.requestAccess(to: .reminder) { (granted, error) in
            if !granted || error != nil {
                print("access not granted to reminders, or error")
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
        
        let weekDay = getSelectedDay(day: dayString)
        let month = getMonth()
        let year = getYear()
        
        let weeklyComponents = DateComponents(calendar: nil, timeZone: nil, era: nil, year: year, month: month, day: weekDay, hour: hour, minute: minute, second: nil, nanosecond: nil, weekday: weekDay, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
    
        let weeklyTrigger = UNCalendarNotificationTrigger(dateMatching: weeklyComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: NotificationManager.notificaionIdentifier, content: nc, trigger: weeklyTrigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("error pushing notification:\(String(describing: error))")
        }}
        
        completion(weeklyComponents)
        
    }
    
    func loadCarpoolToReminders(carpool: Carpool) {
        
        let calendar = Calendar(identifier: .gregorian)
        
        for date in carpool.notificationComponents {
            
            let startTimeDate = DateComponents(calendar: nil, timeZone: nil, era: nil, year: date.year, month: date.month, day: getDay(), hour: date.hour, minute: date.minute, second: nil, nanosecond: nil, weekday: date.weekday, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)

            // i need to make the month 5 months farther ahead. so
            // if the month is 8 or higher, i need to subtract 12
            // from the month, and add one to the year
            
            guard var month = date.month else { return }
            guard var year = date.year else { return }
            
            month += 5
            
            if month > 12 {
                year += 1
                month -= 12
            }
            
            let endRecurrenceDate = DateComponents(calendar: nil, timeZone: nil, era: nil, year: year, month: month, day: date.day, hour: date.hour, minute: date.minute, second: nil, nanosecond: nil, weekday: date.weekday, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
            
            let reminder = EKReminder(eventStore: eventStore)
            
            //what day of the week to repeat
            guard let day = date.day else { return }
            guard let weekday = EKWeekday(rawValue: day) else { return }
            let eventDay = EKRecurrenceDayOfWeek(weekday)
            
            //what weeks of the year to repeat...
            //for now i'll just do for the next 6 months
            //from the start date of the carpool
            
            guard let eventStartTimeDate = calendar.date(from: startTimeDate) else { print("can't get the event date"); return }
            guard let eventEndRecurrenceDate = calendar.date(from: endRecurrenceDate) else { print("can't get the recurrence date"); return }
            
            //I have to put into this recurrence rule the date when
            //I want to set as the end of the recurrence... and i wasn't...
            
            let recurrenceEnd = EKRecurrenceEnd(end: eventEndRecurrenceDate)
            let rule = EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, daysOfTheWeek: [eventDay], daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: recurrenceEnd)
            
            reminder.title = carpool.eventName
            reminder.notes = carpool.eventName
            reminder.completionDate = eventStartTimeDate
            
            reminder.dueDateComponents = date
            
            reminder.calendar = eventStore.defaultCalendarForNewReminders()
            reminder.recurrenceRules = [rule]
            
            do {
                try eventStore.save(reminder, commit: true)
            } catch {
                print("error?: \(error)")
            }
        }
        
    }

    
    func getDay()->Int {
        let todayDate = Date()
        let myCalendar = NSCalendar(calendarIdentifier: .gregorian)
        let myComponents = myCalendar?.components(.day, from: todayDate)
        let weekDay = myComponents?.day
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














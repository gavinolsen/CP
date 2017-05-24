//
//  EventManager.swift
//  CP
//
//  Created by Gavin Olsen on 5/18/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import Foundation
import EventKit
import EventKitUI
import UserNotifications

class EventManager {
    
    //MARK: keys
    static let accessGrantedKey = "eventkit_events_access_granted"
    static let selectedCalendarKey = "eventkit_selected_calendar_identifier"
    static let carpoolAppCarpoolsKey = "getting_the_carpools_from_this_app"
    
    //MARK: properties
    static let shared = EventManager()
    let eventStore = EKEventStore()
    var accessGranted: Bool?
    var calendarArray: [EKCalendar] = []
    var calendarIdentifiers: [String] = []
    var selectedCalendarString: String = ""
    
    func getLocalCalendars() -> [EKCalendar] {
     
        let allCalendars = eventStore.calendars(for: .event)
        
        var localCalendars: [EKCalendar] = []
        
        for calendar in allCalendars {
            if calendar.type == .local {
                localCalendars.append(calendar)
            }
        }
        return localCalendars
    }
    
    func loadEventCalendars() {
        calendarArray = getLocalCalendars()
    }
    
    func setSelectedCalendarID(calID: String) {
        UserDefaults.standard.set(calID, forKey: EventManager.selectedCalendarKey)
    }

    func saveCalendarIdentifier(_ identifier: String) {
        calendarIdentifiers.append(identifier)
        
        UserDefaults.standard.set(calendarIdentifiers, forKey: EventManager.carpoolAppCarpoolsKey)
        
    }
    
    func loadCarpoolToCalendar(carpool: Carpool) {
        
        let calendar = Calendar(identifier: .gregorian)
        
        for date in carpool.notificationComponents {
            
            let startTimeDate = DateComponents(calendar: nil, timeZone: nil, era: nil, year: date.year, month: date.month, day: getDay(), hour: date.hour, minute: date.minute, second: nil, nanosecond: nil, weekday: date.weekday, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
            let endTimeDate = DateComponents(calendar: nil, timeZone: nil, era: nil, year: date.year, month: date.month, day: getDay(), hour: date.hour! + 1, minute: date.minute, second: nil, nanosecond: nil, weekday: date.weekday, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
            
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
            
            let event = EKEvent(eventStore: eventStore)
            
            //what day of the week to repeat
            guard let day = date.day else { return }
            guard let weekday = EKWeekday(rawValue: day) else { return }
            let eventDay = EKRecurrenceDayOfWeek(weekday)
            
            //what weeks of the year to repeat...
            //for now i'll just do for the next 6 months 
            //from the start date of the carpool
            
            guard let eventStartTimeDate = calendar.date(from: startTimeDate) else { print("can't get the event date"); return }
            guard let eventEndTimeDate = calendar.date(from: endTimeDate) else { print("can't get the event end date"); return }
            guard let eventEndRecurrenceDate = calendar.date(from: endRecurrenceDate) else { print("can't get the recurrence date"); return }
            
            //I have to put into this recurrence rule the date when 
            //I want to set as the end of the recurrence... and i wasn't...
            
            let recurrenceEnd = EKRecurrenceEnd(end: eventEndRecurrenceDate)
            let rule = EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, daysOfTheWeek: [eventDay], daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: recurrenceEnd)
            
            event.title = carpool.eventName
            event.notes = carpool.eventName
            event.startDate = eventStartTimeDate
            event.endDate = eventEndTimeDate
            event.calendar = eventStore.defaultCalendarForNewEvents
            event.recurrenceRules = [rule]
            
            do {
                try eventStore.save(event, span: .futureEvents, commit: true)
            } catch {
                print("error?: \(error)")
            }
        }
        
    }
    
    func requestEventAuthorization() {
        
        EventManager.shared.eventStore.requestAccess(to: EKEntityType.event) { (granted, error) in
            
            if error == nil {
                EventManager.shared.accessGranted = granted
            } else {
                NSLog("error: \(String(describing: error?.localizedDescription))")
            }
        }}
    
    func confirmDeletion(calendar: EKCalendar) {
        
        //go through our calendar identifier array and check if the identifier of the calendar is equal to th
        //identifier that was passed through to this function. (: make this function return a boolean...
    
        do {
            try eventStore.removeCalendar(calendar, commit: true)
            
            if calendarIdentifiers.contains(calendar.calendarIdentifier) {
                print("it's in here...")
            }
            
            //remove the identifier from our array of identifiers
            
        } catch {
            print(error.localizedDescription)
        }
        //catch the error
        
    }
    
    func getStringFrom(date: Date) -> String{
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale.current
        
        dateFormatter.dateFormat = "yyyy-MM-dd hh-mm"
        
        return ""
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
                                                                                            ///         /// these two are needed to make the reminder...
        let weeklyComponents = DateComponents(calendar: nil, timeZone: nil, era: nil, year: nil, month: nil, hour: hour, minute: minute, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        
        let weeklyTrigger = UNCalendarNotificationTrigger(dateMatching: weeklyComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: NotificationManager.notificaionIdentifier, content: nc, trigger: weeklyTrigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("error pushing notification:\(String(describing: error))")
            }}
        
        completion(weeklyComponents)
        
    }
    func getDay() -> Int {
        
        let todayDate = Date()
        let myCalendar = NSCalendar(calendarIdentifier: .gregorian)
        let myComponents = myCalendar?.components(.day, from: todayDate)
        let day = myComponents?.day
        return day ?? 0
    }

}
















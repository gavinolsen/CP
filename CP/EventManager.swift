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
    var nextMonth = NotificationManager.shared.getMonth()
    
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
            
            //I think the problem is when I am making the start date
            //and the end date. I'm taking the current day, instead of the day that it's supposed to reoccur
            
            //what i want to do is get the next day that falls on the weekday
            //that I want...
            
            let firstDay = calculateFirstDay(weekDay: date.day!)
            
            let startTimeDate = DateComponents(calendar: nil, timeZone: nil, era: nil, year: date.year, month: nextMonth, day: firstDay, hour: date.hour, minute: date.minute, second: nil, nanosecond: nil, weekday: date.weekday, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
            let endTimeDate = DateComponents(calendar: nil, timeZone: nil, era: nil, year: date.year, month: nextMonth, day: firstDay, hour: date.hour! + 1, minute: date.minute, second: nil, nanosecond: nil, weekday: date.weekday, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
            
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
    
    func getDaysInMonth(month: Int, year: Int) -> Int
    {
        let calendar = NSCalendar.current
        
        var startComps = DateComponents()
        startComps.day = 1
        startComps.month = month
        startComps.year = year
        
        var endComps = DateComponents()
        endComps.day = 1
        endComps.month = month == 12 ? 1 : month + 1
        endComps.year = month == 12 ? year + 1 : year
        
        guard let startDate = calendar.date(from: startComps) else { return 0}
        guard let endDate = calendar.date(from: endComps) else { return 0}
        
        let component: Set<Calendar.Component> = [Calendar.Component.day]
        
        let mydiff = calendar.dateComponents(component, from: startDate, to: endDate)
        
        return mydiff.day ?? 0
    }
    
    func calculateFirstDay(weekDay: Int) -> Int {
        
        let daysInMonth = getDaysInMonth(month: NotificationManager.shared.getMonth(), year: NotificationManager.shared.getYear())
        
        let daysRemainingInMonth = daysInMonth - getDay()
        
        nextMonth = NotificationManager.shared.getMonth()
        
        if daysRemainingInMonth < 7 {
            nextMonth += 1
            var firstWeekDay = getWeekDay()
            
            for i in 0...7 {
                if firstWeekDay == weekDay {
                    return i
                } else if firstWeekDay == 7 {
                    firstWeekDay = 1
                } else {
                    firstWeekDay += 1
                }
            }
        }
        return getDay()
    }
    
    
    
    func getWeekDay() -> Int {
        let todayDate = Date()
        let myCalendar = NSCalendar(calendarIdentifier: .gregorian)
        let components = myCalendar?.components(.weekday, from: todayDate)
        let weekday = components?.weekday
        return weekday ?? 0
    }

}



/*
 let nextDay = weekDay + daysRemainingInMonth
 
 var firstCalDay = 0
 //now i want to find the next sunday...
 //I need to find out what weekday it is
 //
 
 for i in 0...7 {
 if i == weekDay {
 
 }
 firstCalDay += 1
 }
 
 print(nextDay)
 */












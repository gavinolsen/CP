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
    
    init() {
        
        if let calendarsString = UserDefaults.standard.object(forKey: EventManager.selectedCalendarKey) as? String {
            self.selectedCalendarString = calendarsString
        }
        
        if let identifiers = UserDefaults.standard.object(forKey: EventManager.carpoolAppCarpoolsKey) as? [String] {
            self.calendarIdentifiers = identifiers
        }
        
        
    }
    
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
        
        guard let dateComponents = carpool.notificationComponents else { print("can't get the date components from the carpool");return }
        
        for date in dateComponents {
            
            let reminder = EKReminder(eventStore: eventStore)
            
            reminder.title = carpool.eventName
            
            //guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { print("can't get the app delegate");return }
        
            reminder.dueDateComponents = date
        }
        
    }
    
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
    

    
}
















//
//  Carpool.swift
//  CP
//
//  Created by Gavin Olsen on 5/8/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import Foundation
import CloudKit

class Carpool: CloudKitSync {
    
    //MARK: keys
    static let typeKey = "Carpool"
    static let nameKey = "carpoolName"
    static let dateKey = "dateKey"
    static let driverKey = "driverKey"
    static let leaderKey = "leaderKey"
    static let leaderNameKey = "leaderNameKey"
    static let kidKey = "kidKey"
    static let passkey = "passKey"
    static let daysKey = "daysKey"
    static let minutesKey = "minutesKey"
    static let hoursKey = "hoursKey"
    static let isPmArrayKey = "isPMKey"
    static let parentReferenceStringsKey = "parentReferenceStringsKey"
    
    //MARK: properties
    var eventName: String
    
    var notificationTimeStrings: [String]
    var notificationDays: [Int]
    var notificationHours: [Int]
    var notificationMinutes: [Int]
    var notificationComponents: [DateComponents] {
        var dateComponents: [DateComponents] = []
        
        for i in 0...notificationDays.count - 1 {
            let oneDateComponent = DateComponents(calendar: nil, timeZone: nil, era: nil, year: getYear(), month: getMonth(), day: notificationDays[i], hour: notificationHours[i], minute: notificationMinutes[i], second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
            dateComponents.append(oneDateComponent)
        }
        return dateComponents
    }
    var drivers: [Parent]?
    let leader: Parent?
    
    let leaderName: String?
    
    var kids: [Child]?
    var ckRecord: CKRecord?
    var ckRecordID: CKRecordID?
    var recordType: String { return Carpool.typeKey }
    
    let passkey: String?
    
    //dayString: day, hourString: hour, minuteString: minute, isPm: isPm,
    //these are the components that i need to make the notification
    
    //MARK: initilizers
    init(name: String, timeStrings: [String], days: [Int], hours: [Int], minutes: [Int], components: [DateComponents]? = nil, drivers: [Parent] = [], kids: [Child] = [], leader: Parent? = nil, passkey: String, leaderName: String) {
        
        self.eventName = name
        self.notificationTimeStrings = timeStrings
        self.notificationDays = days
        self.notificationHours = hours
        self.notificationMinutes = minutes
        self.drivers = drivers
        self.kids = kids
        self.leader = leader
        self.passkey = passkey
        self.leaderName = leaderName
        
    }
    
    convenience required init?(record: CKRecord) {
        guard let name = record[Carpool.nameKey] as? String, let time = record[Carpool.dateKey] as? [String], let days = record[Carpool.daysKey] as? [Int], let hours = record[Carpool.hoursKey] as? [Int], let minutes = record[Carpool.minutesKey] as? [Int], let passkey = record[Carpool.passkey] as? String, let leaderName = record[Carpool.leaderNameKey] as? String else { print("coudn't make carpool"); return nil }
        
        self.init(name: name, timeStrings: time, days: days, hours: hours, minutes: minutes, passkey: passkey, leaderName: leaderName)
        ckRecordID = record.recordID
    }
    
    func getTimeString() -> String {
        var timeString = ""
        for time in notificationTimeStrings {
            
            if time != notificationTimeStrings.first {
              timeString += ", " + time
            } else {
                timeString += time
            }
        }
        return timeString
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
    
}

extension Carpool: Hashable {
    var hashValue: Int {
        return eventName.hashValue
    }
    static func == (lsh: Carpool, rhs: Carpool) -> Bool {
        return lsh.ckRecordID == rhs.ckRecordID
    }
}

extension CKRecord {
    
    convenience init(_ carpool: Carpool) {
        
        let recordID = CKRecordID(recordName: UUID().uuidString)
        let parentRecordID = carpool.leader?.ckRecordID ?? CKRecord(carpool.leader!).recordID
        self.init(recordType: carpool.recordType, recordID: recordID)
        var driversReference: [CKReference] = []
        carpool.ckRecordID = recordID
        
        //MARK: revise this part
        
        if let carpoolDrivers = carpool.drivers {
            if carpoolDrivers.count > 0 {
                for driver in carpoolDrivers {
                    guard let driverID = driver.ckRecordID else { print("bad ckrecordid"); return }
                    driversReference.append(CKReference(recordID: driverID, action: .deleteSelf))
        }}}
        
        var kidReferences = [CKReference]()
        
        if let kidsInCarpool = carpool.kids {
            if kidsInCarpool.count > 0 {
                for kid in kidsInCarpool {
                    guard let kidID = kid.ckRecordID else { print("bad ckrecordID"); return }
                    kidReferences.append(CKReference(recordID: kidID, action: .deleteSelf))
        }}}
        
        
        
        self[Carpool.driverKey] = driversReference as CKRecordValue
        self[Carpool.kidKey] = kidReferences as CKRecordValue
        
        self[Carpool.nameKey] = carpool.eventName as CKRecordValue?
        self[Carpool.dateKey] = carpool.notificationTimeStrings as CKRecordValue?
        
        //I can't save a notification request... maybe I can save something else though...
        //can't save date components either... so I'll have to save all components seperately...
        self[Carpool.daysKey] = carpool.notificationDays as CKRecordValue?
        self[Carpool.hoursKey] = carpool.notificationHours as CKRecordValue?
        self[Carpool.minutesKey] = carpool.notificationMinutes as CKRecordValue?
        self[Carpool.leaderKey] = CKReference(recordID: parentRecordID, action: .deleteSelf)
        
        self[Carpool.leaderNameKey] = carpool.leaderName as CKRecordValue?
        
        self[Carpool.passkey] = carpool.passkey as CKRecordValue?
        
        
    }
}












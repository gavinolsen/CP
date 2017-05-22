//
//  Carpool.swift
//  CP
//
//  Created by Gavin Olsen on 5/8/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import Foundation
import CloudKit
import UserNotifications

class Carpool: CloudKitSync {
    
    //MARK: keys
    static let typeKey = "Carpool"
    static let nameKey = "carpoolName"
    static let dateKey = "dateKey"
    static let driverKey = "driverKey"
    static let leaderKey = "leaderKey"
    static let kidKey = "kidKey"
    static let requestsKey = "requestsKey"
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
    var notificationComponents: [DateComponents]?
    var drivers: [Parent]?
    let leader: Parent?
    var kids: [Child]?
    var ckRecordID: CKRecordID?
    var recordType: String { return Carpool.typeKey }
    
    //dayString: day, hourString: hour, minuteString: minute, isPm: isPm,
    //these are the components that i need to make the notification
    
    //MARK: initilizers
    init(name: String, timeStrings: [String], days: [Int], hours: [Int], minutes: [Int], components: [DateComponents]? = nil, drivers: [Parent] = [], kids: [Child] = [], leader: Parent? = nil) {
        
        self.eventName = name
        self.notificationTimeStrings = timeStrings
        self.notificationDays = days
        self.notificationHours = hours
        self.notificationMinutes = minutes
        self.notificationComponents = components
        self.drivers = drivers
        self.kids = kids
        self.leader = leader
    }
    
    convenience required init?(record: CKRecord) {
        guard let name = record[Carpool.nameKey] as? String, let time = record[Carpool.dateKey] as? [String], let days = record[Carpool.daysKey] as? [Int], let hours = record[Carpool.hoursKey] as? [Int], let minutes = record[Carpool.minutesKey] as? [Int] else { return nil }
        
        self.init(name: name, timeStrings: time, days: days, hours: hours, minutes: minutes)
        ckRecordID = record.recordID
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
        //MARK: FIXTHIS!!!!!!!!!!!!!!!A
        let parentRecordID = carpool.leader?.ckRecordID ?? CKRecord(carpool.leader!).recordID
        
        /*
         I'm not sure how to save the
         */
        
        var driversRecords: [String] = []
        
        self.init(recordType: carpool.recordType, recordID: recordID)
        
        carpool.ckRecordID = recordID
        
        if let carpoolDrivers = carpool.drivers {
            if carpoolDrivers.count > 0 {
                for driver in carpoolDrivers {
                    let driverString = String(describing: driver.ckRecordID)
                    driversRecords.append(driverString)
                }
                self[Carpool.driverKey] = driversRecords as CKRecordValue?
            }
        }
        
        self[Carpool.nameKey] = carpool.eventName as CKRecordValue?
        self[Carpool.dateKey] = carpool.notificationTimeStrings as CKRecordValue?
        
        //I can't save a notification request... maybe I can save something else though...
        //can't save date components either... so I'll have to save all components seperately...
        self[Carpool.daysKey] = carpool.notificationDays as CKRecordValue?
        self[Carpool.hoursKey] = carpool.notificationHours as CKRecordValue?
        self[Carpool.minutesKey] = carpool.notificationMinutes as CKRecordValue?
        self[Carpool.leaderKey] = CKReference(recordID: parentRecordID, action: .deleteSelf)
    }
    
}












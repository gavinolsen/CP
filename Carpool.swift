//
//  Carpool.swift
//  CP
//
//  Created by Gavin Olsen on 5/8/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import Foundation
import CloudKit
import EventKit

class Carpool: CloudKitSync {
    
    //MARK: keys
    static let typeKey = "Carpool"
    static let nameKey = "carpoolname"
    static let dateKey = "dateKey"
    static let driverKey = "driverKey"
    static let leaderKey = "leaderKey"
    static let kidKey = "kidKey"
    
    //MARK: properties
    var eventName: String
    
    let eventStore = EKEventStore()
    
    var eventTimes: [Date]
    var drivers: [Parent]?
    let leader: Parent
    var kids: [Child]?
    var ckRecordID: CKRecordID?
    var recordType: String { return Carpool.typeKey }
    
    //MARK: initilizers
    init(name: String, time: [Date], drivers: [Parent] = [], kids: [Child] = [], leader: Parent) {
        
        self.eventName = name
        self.eventTimes = time
        self.drivers = drivers
        self.kids = kids
        self.leader = leader
    }
    
    convenience required init?(record: CKRecord) {
        guard let name = record[Carpool.nameKey] as? String, let time = record[Carpool.dateKey] as? [Date],
            let drivers = record[Carpool.driverKey] as? [Parent], let kids = record[Carpool.kidKey] as? [Child], let leader = record[Carpool.leaderKey] as? Parent else { return nil }
        
        self.init(name: name, time: time, drivers: drivers, kids: kids, leader: leader)
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
        let parentRecordID = carpool.leader.ckRecordID ?? CKRecord(carpool.leader).recordID
        self.init(recordType: carpool.recordType, recordID: recordID)
        
        self[Carpool.nameKey] = carpool.eventName as CKRecordValue?
        self[Carpool.dateKey] = carpool.eventTimes as CKRecordValue?
        self[Carpool.leaderKey] = CKReference(recordID: parentRecordID, action: .deleteSelf)
    }
    
}












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
    static let typeKey = "carpoolType"
    static let nameKey = "carpoolname"
    static let dateKey = "dateKey"
    static let driverKey = "driverKey"
    static let kidKey = "kidKey"
    
    //MARK: properties
    var eventName: String
    var eventTime: Date
    var drivers: [Parent]
    let kids: [Child]
    var ckRecordID: CKRecordID?
    var recordType: String { return Carpool.typeKey }
    
    //MARK: initilizers
    init(name: String, time: Date, drivers: [Parent] = [], kids: [Child] = []) {
        
        self.eventName = name
        self.eventTime = time
        self.drivers = drivers
        self.kids = kids
    }
    
    convenience required init?(record: CKRecord) {
        guard let name = record[Carpool.nameKey] as? String, let time = record[Carpool.dateKey] as? Date,
            let drivers = record[Carpool.driverKey] as? [Parent], let kids = record[Carpool.kidKey] as? [Child] else { return nil }
        
        /////////////
        // I might have to add in here
        // to check if there's kids or not.
        // so that i can call the right init
        /////////////
        self.init(name: name, time: time, drivers: drivers, kids: kids)
        ckRecordID = record.recordID
    }
    
    
}

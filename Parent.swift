//
//  User.swift
//  CP
//
//  Created by Gavin Olsen on 5/8/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

/*****************************************
 the user needs an array of children, and an 
 array of carpools.
 This will be comparable to teh
 *****************************************/

import Foundation
import CloudKit

class Parent: CloudKitSync {
    
    //MARK: keys
    static let typeKey = "Parent"
    static let nameKey = "nameKey"
    static let kidKey = "kidKey"
    static let carpoolKey = "carpoolkey"
    static let carpoolDictKey = "carpoolDictKey"
    static let isLeaderKey = "leader????"
    static let userRecordIDKey = "userRecordIDKey"
    
    //MARK: properties
    var name: String
    var kids: [Child] = []
    var carpools: [Carpool] = []
    var isLeader: Bool
    var recordType: String { return Parent.typeKey }
    var ckRecordID: CKRecordID?
    
    var userRecordID: CKRecordID?
    
    let ckManager = CloudKitManager()
    
    //MARK: initilizers
    init(name: String, kids: [Child] = [], carpools: [Carpool] = [], isLeader: Bool = false, userRecordID: CKRecordID? = nil) {
        self.name = name
        self.carpools = carpools
        
       
        
        self.kids = kids
        self.isLeader = isLeader
        self.userRecordID = userRecordID
        
        /*
         this is just for practice to try
         to get things running
//         */
//        let firstKid = Child(name: "", age: 0, details: "", parent: self)
//        self.kids.append(firstKid)
        
        let firstCarpool = Carpool(name: "", time: [], drivers: [], kids: [], leader: self)
        self.carpools.append(firstCarpool)
    }
    
    convenience required init?(record: CKRecord) {
        guard let name = record[Parent.nameKey] as? String
            //let userID = record[Parent.userRecordIDKey] as? CKRecordID?
            else { print("one of the values from the required init came back as nil"); return nil }
        //, let carpools = record[Parent.carpoolKey] as? [Carpool]
        //, let kids = record[Parent.kidKey] as? [Child]
        self.init(name: name, userRecordID: nil)
        ckRecordID = record.recordID
    }
    
}

//MARK: extensions
extension Parent: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        return name.contains(searchTerm)
    }
}

extension CKRecord {
    convenience init(_ parent: Parent) {
        let record = CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: parent.recordType, recordID: record)
        
        self[Parent.nameKey] = parent.name as CKRecordValue?
        self[Parent.userRecordIDKey] = parent.userRecordID?.recordName as CKRecordValue?
//        self[Parent.kidKey] = parent.kids as CKRecordValue?
//        self[Parent.carpoolKey] = parent.carpools as CKRecordValue?
    }
}






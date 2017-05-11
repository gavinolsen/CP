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
    static let nameKey = "namekey"
    static let kidKey = "kidkey"
    static let carpoolKey = "carpoolkey"
    static let carpoolDictKey = "carpoolDictKey"
    static let isLeaderKey = "leader????"
    static let userRecordIDKey = "userRecordIDKey"
    
    //MARK: properties
    var name: String
    var kids: [Child]
    var carpools: [Carpool]
    var isLeader: Bool
    var recordType: String { return Parent.typeKey }
    var ckRecordID: CKRecordID?
    
    var userRecordID: CKRecordID?
    
    let ckManager = CloudKitManager()
    
    //MARK: initilizers
    init(name: String, kids: [Child] = [], carpools: [Carpool] = [], isLeader: Bool = false, userRecordID: CKRecordID?) {
        self.name = name
        self.carpools = carpools
        self.kids = kids
        self.isLeader = isLeader
        self.userRecordID = userRecordID
    }
    
    convenience required init?(record: CKRecord) {
        guard let name = record[Parent.nameKey] as? String, let carpools = record[Parent.carpoolKey] as? [Carpool], let userID = record[Parent.userRecordIDKey] as? CKRecordID else { return nil }
        self.init(name: name, carpools: carpools, userRecordID: userID)
        ckRecordID = record.recordID
    }
    
    //cloud kit functions
    
    func getUserRecord() {
        ckManager.fetchLoggedInUserRecord { (record, error) in
            guard let record = record else { return }
            self.userRecordID = record.recordID
    }}
    
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
        self[Parent.userRecordIDKey] = parent.ckRecordID as? CKRecordValue
        self[Parent.kidKey] = parent.kids as CKRecordValue?
        self[Parent.carpoolKey] = parent.carpools as CKRecordValue?
    }
}






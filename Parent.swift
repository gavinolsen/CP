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
    static let typeKey = "parenttype"
    static let nameKey = "namekey"
    static let kidKey = "kidkey"
    static let carpoolKey = "carpoolkey"
    static let carpoolDictKey = "carpoolDictKey"
    static let isLeaderKey = "leader????"
    
    //MARK: properties
    let name: String
    var kids: [Child] = []
    var carpools: [Carpool]
    var isLeader: Bool
    var recordType: String { return Parent.typeKey }
    var ckRecordID: CKRecordID?
    
    //MARK: initilizers
    init(name: String, kids: [Child] = [], carpools: [Carpool] = [], isLeader: Bool = false) {
        self.name = name
        self.carpools = carpools
        self.isLeader = isLeader
    }
    
    convenience required init?(record: CKRecord) {
        guard let name = record[Parent.nameKey] as? String, let carpools = record[Parent.carpoolKey] as? [Carpool], let isLeader = record[Parent.isLeaderKey] as? Bool else { return nil }
        self.init(name: name, carpools: carpools, isLeader: isLeader)
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
    }
}






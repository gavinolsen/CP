//
//  Child.swift
//  CP
//
//  Created by Gavin Olsen on 5/8/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import Foundation
import CloudKit

class Child: CloudKitSync {
    
    //MARK: keys
    static let typeKey = "Child"
    static let nameKey = "nameKey"
    static let parentKey = "parentKey"
    static let detailsKey = "detailsKey"
    static let ageKey = "ageKey"
    static let carpoolKey = "carpoolKey"
    static let ckRecordKey = "ckRecordIDkey"
    
    //MARK: properties
    var name: String
    var age: Int
    var ckReference: CKReference?
    var parent: Parent?
    var carpools: [Carpool] = []
    var details: String
    var ckRecordID: CKRecordID?
    var recordType: String { return Child.typeKey }
    
    //MARK: initilizers
    init(name: String, age: Int, details: String, parent: Parent? = nil, carpools: [Carpool] = [], ckReference: CKReference? = nil) {
        self.name = name
        self.age = age
        self.details = details
        self.parent = parent
        self.carpools = carpools
        self.ckReference = ckReference
    }
    
    /*
     I can't properly delete the methods that haven't been saved yet
     because they don't have a record id yet. so i'll just save them
     and pull them back out for my data model...
     */
    
    convenience required init?(record: CKRecord) {
        guard let name = record[Child.nameKey] as? String, let age = record[Child.ageKey] as? Int, let details = record[Child.detailsKey] as? String, let parent = record[Child.parentKey] as? CKReference else { return nil }
        self.init(name: name, age: age, details: details, ckReference: parent)
        ckRecordID = record.recordID
    }
}

//MARK: extensions
extension Child: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        return name.contains(searchTerm)
    }
}

extension CKRecord {
    
    convenience init?(_ kid: Child) {
        
        guard let parent = kid.parent else { NSLog("child doesn't have parent relationship"); return nil }
        let parentRecordID = parent.ckRecordID ?? CKRecord(parent).recordID
        let recordID = CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: kid.recordType, recordID: recordID)
        
        self[Child.parentKey] = CKReference(recordID: parentRecordID, action: .deleteSelf)
        self[Child.ageKey] = kid.age as CKRecordValue?
        self[Child.nameKey] = kid.name as CKRecordValue?
        self[Child.detailsKey] = kid.details as CKRecordValue?
        self[Child.ckRecordKey] = recordID as? CKRecordValue

    }
    
}

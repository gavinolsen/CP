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
    static let typeKey = "child"
    static let nameKey = "nameKey"
    static let parentKey = "parentKey"
    static let detailsKey = "detailsKey"
    static let ageKey = "ageKey"
    static let carpoolKey = "carpoolKey"
    
    //MARK: properties
    let name: String
    var age: Int
    let parent: Parent
    var carpools: [Carpool]
    var details: String
    var ckRecordID: CKRecordID?
    var recordType: String { return Child.typeKey }
    
    //MARK: initilizers
    init(name: String, age: Int, details: String, parent: Parent, carpools: [Carpool]) {
        self.name = name
        self.age = age
        self.details = details
        self.parent = parent
        self.carpools = carpools
    }
    
    convenience required init?(record: CKRecord) {
        guard let name = record[Child.nameKey] as? String, let age = record[Child.ageKey] as? Int, let details = record[Child.detailsKey] as? String, let parent = record[Child.parentKey] as? Parent, let carpools = record[Child.carpoolKey] as? [Carpool] else { return nil }
        self.init(name: name, age: age, details: details, parent: parent, carpools: carpools)
        ckRecordID = record.recordID
    }
}

extension Child: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        return name.contains(searchTerm)
    }
}

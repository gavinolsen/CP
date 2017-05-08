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
    
    //MARK: properties
    let name: String
    let parent: Parent
    var ckRecordID: CKRecordID?
    var recordType: String { return Child.typeKey }
    
    //MARK: initilizers
    init(name: String, parent: Parent) {
        self.name = name
        self.parent = parent
    }
    
    convenience required init?(record: CKRecord) {
        guard let name = record[Child.nameKey] as? String, let parent = record[Child.parentKey] as? Parent else { return nil }
        self.init(name: name, parent: parent)
        ckRecordID = record.recordID
    }
}



extension Child: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        return name.contains(searchTerm)
    }
}

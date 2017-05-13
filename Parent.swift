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
    var kids: [Child] = [] {
        
        didSet {
            DispatchQueue.main.async {
                let nc = NotificationCenter.default
                nc.post(name: ParentController.ParentNameChangedNotification, object: self)
            }}
        
    }
    var carpools: [Carpool] = []
    var isLeader: Bool
    var recordType: String { return Parent.typeKey }
    var ckRecordID: CKRecordID?
    
    let ckManager = CloudKitManager()
    
    //MARK: initilizers
    init(name: String, kids: [Child] = [], carpools: [Carpool] = [], isLeader: Bool = false, userRecordID: CKRecordID? = nil) {
        self.name = name
        self.carpools = carpools
    
        self.kids = kids
        self.isLeader = isLeader

    }
    
    convenience required init?(record: CKRecord) {
        guard let name = record[Parent.nameKey] as? String else { print("one of the values from the required init came back as nil"); return nil }
        
        self.init(name: name, userRecordID: nil)
        ckRecordID = record.recordID
        fetchKids()
    }
    
    func fetchKids() {
        
        CloudKitManager.shared.fetchRecordsForChildren(ckRecordID: ckRecordID) { (records, error) in
            
            print("in the completion")
            
        }
        
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






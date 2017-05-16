//
//  ParentController.swift
//  CP
//
//  Created by Gavin Olsen on 5/10/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import Foundation
import CloudKit

extension ParentController {
    static let ParentNameChangedNotification = Notification.Name("ParentNameChangedNotification")
    static let ChildArrayNotification = Notification.Name("ChildArrayNotification")
}

class ParentController {
    
    static let shared = ParentController()
    
    var kidPredicate: NSPredicate?
    
    var kids: [Child] = [] {
        didSet {
            DispatchQueue.main.async {
                let nc = NotificationCenter.default
                nc.post(name: ParentController.ChildArrayNotification, object: self)
        }}}
    
    var parentName: String? {
        didSet {
            DispatchQueue.main.async {
                let nc = NotificationCenter.default
                nc.post(name: ParentController.ParentNameChangedNotification, object: self)
    }}}
    
    var parent: Parent? {
        didSet {
            DispatchQueue.main.async {
                let nc = NotificationCenter.default
                nc.post(name: ParentController.ParentNameChangedNotification, object: self)
    }}}
    
    var parentRecord: CKRecord?
    
    func getParentInfo() {

        CloudKitManager.shared.fetchCurrentUserRecords(Parent.typeKey) { (records, error, firstName, iCloudUserRecordID) in
            
            if let error = error {
                print("There was an error fetching current User record: \(error.localizedDescription)")
                return
            }
            
            guard let name = firstName, let recordID = iCloudUserRecordID else { return }
            self.parentName = name
            
            if let record = records?.first {
                self.setParentWithRecord(record: record)
                
                let reference = CKReference(recordID: record.recordID, action: .none)
                let predicate = NSPredicate(format: "%K == %@", Child.parentKey, reference)
                self.kidPredicate = predicate
                
                self.fetchKidsFromParent()
                
            } else {
                self.makeNewParent(name: name, recordID: recordID)
            }
        }
    }
    
    //crud functions
    //create
    func makeNewParent(name: String, recordID: CKRecordID) {
        let newParent = Parent(name: name, userRecordID: recordID)
        parent = newParent
        save(parent: newParent)
    }
    
    func setParentWithRecord(record: CKRecord) {
        let savedParent = Parent(record: record)
        parent = savedParent
        parentRecord = record
    }
    
    //retreiving
    
    func fetchKidsFromParent() {
        
        kids = []
        guard let predicate = kidPredicate else { print("bad predicate"); return }
        CloudKitManager.shared.fetchRecordsWithType(Child.typeKey, predicate: predicate, recordFetchedBlock: nil) { (records, error) in
            if error != nil {
                print("there's an error: \(String(describing: error))")
            }
            
            guard let records = records else { return }
            
            for record in records {
                
                guard let myChild = Child(record: record) else { print("I couldn't get the child back with the record provided"); return }
                
                self.setParentWith(kid: myChild)
            }
        }
    }
    
    
    func setParentWith(kid: Child) {
        kids.append(kid)
    }
    
    func addChildToParent(kid: Child) {
        let newChild = Child(name: kid.name, age: kid.age, details: kid.details, parent: parent)
        print(newChild.name)
    }
    
    func makeCarpoolWithLeader(name: String, times: [Date]) {
        guard let parent = parent else { return }
        let newCarpool = Carpool(name: name, time: times, leader: parent)
        parent.carpools.append(newCarpool)
        save(parent: parent)
    }
    
    func addCarpoolToParent(carpool: Carpool) {
        parent?.carpools.append(carpool)
    }
    
    func removeCarpoolFromParent(carpool: Carpool) {
    }
    
    //MARK: saving + modifying
    
    func save(parent: Parent) {
        CloudKitManager.shared.saveRecord(CKRecord(parent)) { (record, error) in
            
            guard record != nil else {
                if let error = error {
                    NSLog("Error saving to CloudKit from ParentController: \(error)")
                    return
                }
                return
            }}}
    
    func modify(parent: Parent) {

        guard let record = parentRecord else { return }
        
        CloudKitManager.shared.modifyRecords([record], perRecordCompletion: { (record, error) in
            
            if error != nil || record == nil {
                print("there was an error, or there wasn't a record")
            }
        }) { (records, error) in
            if error != nil || records == nil {
                print("there was an error, or there wasn't a record")
            }
        }
    }
}
























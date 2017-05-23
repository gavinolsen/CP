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
    static let NameNeededNotification = Notification.Name("WeNeedToGetANameForTheUser")
    static let ChildArrayNotification = Notification.Name("ChildArrayNotification")
    static let CarpoolArrayNotification = Notification.Name("CarpoolArrayNotification")
    static let allParentsArrayNotification = Notification.Name("donefetchingalloftheparents")
}

class ParentController {
    
    static let shared = ParentController()
    
    var kidPredicate: NSPredicate?
    var userRecordID: CKRecordID?
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
            
            guard let recordID = iCloudUserRecordID else { return }
            self.userRecordID = recordID
            
            //if the first name comes back as nil, i'll have to get it from them somehow...
            //probably an alert that prompts them to enter their name
            
            if self.parentName == nil && records?.count == 0 {
                if firstName != nil {
                    self.parentName = firstName!
                } else {
                    self.parentName = ""
                    return
                }
            }
            
            if firstName == nil && records?.first != nil {
                
                guard let parentWithoutName = Parent(record: (records?.first)!) else { print("bad first record"); return }
                
                self.parent = parentWithoutName
                self.parentName = parentWithoutName.name
                
                guard let record = records?.first else { print("bad first record"); return }
                
                let parentReference = CKReference(recordID: record.recordID, action: .none)
                self.fetchKidsFromParent(reference: parentReference)
                self.fetchCarpoolsFromParent(reference: parentReference)
                
                return
            }
            
            self.parent?.name = (firstName)!
            self.parentName = firstName!
            
            if let record = records?.first {
                self.setParentWithRecord(record: record)
                
                let parentReference = CKReference(recordID: record.recordID, action: .none)
                self.fetchKidsFromParent(reference: parentReference)
                self.fetchCarpoolsFromParent(reference: parentReference)
                
            } else {
                self.makeNewParent(nameString: self.parentName, recordID: recordID)
            }
        }
    }
    
    //crud functions
    //create
    func makeNewParent(nameString: String?, recordID: CKRecordID) {
        guard let name = nameString else { return }
        

        let newParent = Parent(name: name, userRecordID: recordID)
        
        //what do i want it do do if there is already a parent??
        
        parent = newParent
        save(parent: newParent)
        userRecordID = newParent.ckRecordID
        print(newParent.ckRecordID ?? "nothing in here")
        userRecordID = newParent.ckRecordID
        getParentInfo()
    }
    
    func setParentWithRecord(record: CKRecord) {
        let savedParent = Parent(record: record)
        parent = savedParent
        parentRecord = record
        
        guard let ckRecordID = savedParent?.ckRecordID else { return }
        userRecordID = ckRecordID
    }
    
    func makeParentWithName(name: String) {
        parentName = name
        guard let recordID = userRecordID else { return }
        makeNewParent(nameString: name, recordID: recordID)
    }
    
    //retreiving kids and carpools
    
    func fetchKidsFromParent(reference: CKReference) {
        
        //guard let predicate = kidPredicate else { return }
        
        let predicate = NSPredicate(format: "%K == %@", Child.parentKey, reference)
        
        parent?.kids = []
        
        CloudKitManager.shared.fetchRecordsWithType(Child.typeKey, predicate: predicate) { (records, error) in
            if error != nil {
                print("there's an error: \(String(describing: error))")
            }
            
            guard let records = records else { return }
            
            for record in records {
                guard let myChild = Child(record: record) else { print("I couldn't get the child back with the record provided"); return }
                self.setParentWith(kid: myChild)
    }}}
    
    func fetchCarpoolsFromParent(reference: CKReference) {
        
        let predicate = NSPredicate(format: "%K == %@", Carpool.leaderKey, reference)
        
        parent?.carpools = []
        
        CloudKitManager.shared.fetchRecordsWithType(Carpool.typeKey, predicate: predicate) { (records, error) in
            
            guard let records = records else { print("couldn't get the records for the carpools");return }
            
            for record in records {
                guard let myCarpool = Carpool(record: record) else { print("can't make carpool from record"); return }
                self.addCarpoolToParent(carpool: myCarpool)
    }}}
    
    func fetchParents(completion: ((_ parents: [Parent]?) -> Void)?) {
        
        var allParents: [Parent] = []
        
        CloudKitManager.shared.fetchRecordsWithType(Parent.typeKey) { (records, error) in
            
            if records == nil || error != nil {
                
                print("there's a problem with the records or the error: \(String(describing: error?.localizedDescription))")
            }
            guard let records = records else { return }
            
            for record in records {
                guard let parent = Parent(record: record) else { return }
                allParents.append(parent)
            }
            completion?(allParents)
        }
    }
    
    
    func setParentWith(kid: Child) {
        parent?.kids.append(kid)
    }
    
    func addChildToParent(kid: Child) {
        let newChild = Child(name: kid.name, age: kid.age, details: kid.details, parent: parent)
        print(newChild.name)
    }
    
    func makeCarpoolWithLeader(newCarpool: Carpool) {
        guard let parent = parent else { return }
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
























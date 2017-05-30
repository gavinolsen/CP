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
    var parentRecord: CKRecord?
    
    var parentsCarpoolsRecords: [CKRecord] = []
    
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
                self.fetchCarpoolsFromParentAsLeader(reference: parentReference)
                return
            }
            
            self.parent?.name = (firstName)!
            self.parentName = firstName!
            
            if let record = records?.first {
                self.setParentWithRecord(record: record)
                
                let parentReference = CKReference(recordID: record.recordID, action: .none)
                self.fetchKidsFromParent(reference: parentReference)
                self.fetchCarpoolsFromParent(reference: parentReference)
                self.fetchCarpoolsFromParentAsLeader(reference: parentReference)
            } else {
                self.makeNewParent(nameString: self.parentName, recordID: recordID)
            }
        }
    }
    
    //what i want to do, is search for the record of the current user... if there
    //isn't a record with
    
    func changeParent(name: String) {
        guard let parentID = userRecordID else { return }
        CloudKitManager.shared.modify(parentID: parentID, newName: name)
        parentName = name
        parent?.name = name
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
    
    //these two must be called in the order they're written
    //because the parent?.carpools = [] will reset the carpool
    //of the parent, so that it dosn't get overloaded
    
    func fetchCarpoolsFromParentAsLeader(reference: CKReference) {
        parent?.carpools = []
        let predicate = NSPredicate(format: "%K == %@", Carpool.leaderKey, reference)
        CloudKitManager.shared.fetchRecordsWithType(Carpool.typeKey, predicate: predicate) { (records, error) in
            guard let records = records else { print("couldn't get the records for the carpools");return }
            for record in records {
                self.setLeaderdCarpools(record: record)
    }}}
    
    func fetchCarpoolsFromParent(reference: CKReference) {
        
        parent?.carpools = []
        
        guard let parentID = parent?.ckRecordID else { return }
        let parentReference = CKReference(recordID: parentID, action: .deleteSelf)
        
        let predicate = NSPredicate(format: "%K CONTAINS %@", Carpool.driverKey, parentReference)
        CloudKitManager.shared.fetchRecordsWithType(Carpool.typeKey, predicate: predicate) { (records, error) in
            guard let records = records else { print("couldn't get the records for the carpools");return }
            if error != nil {
                print("error fetching parent as driver from carpool")
                return
            }
            for record in records {
                self.addCarpoolToParent(record: record)
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
    
    func fetchCarpoolsForKid(kid: Child) {
    
        guard let kidID = kid.ckRecordID else { return }
        
        let ckref = CKReference(recordID: kidID, action: .deleteSelf)
        
        let predicate = NSPredicate(format: "%K CONTAINS %@", Carpool.kidKey, ckref)
        
        CloudKitManager.shared.fetchRecordsWithType(Carpool.typeKey, predicate: predicate) { (records, error) in
            
            guard let records = records else { print("couldn't get the records for the carpools");return }
            if error != nil {
                print("error fetching parent as driver from carpool")
                return
            }
            
            for record in records {
                guard let carpool = Carpool(record: record) else { return }
                kid.carpools.append(carpool)
            }
        }
    }
    
    //end of fetching and retrieving.
    
    func setParentWith(kid: Child) {
        
        //here's where I want to get the 
        //carpools for each kid....
        print(kid.ckRecordID?.recordName ?? "0")
        DispatchQueue.main.async {
            self.fetchCarpoolsForKid(kid: kid)
            self.parent?.kids.append(kid)
        }
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
    
    func addCarpoolToParent(record: CKRecord) {
        guard let myCarpool = Carpool(record: record) else { print("can't make carpool from record"); return }
        
        CarpoolController.shared.parentsCarpools.append(myCarpool)
        parentsCarpoolsRecords.append(record)
        parent?.carpools.append(myCarpool)
    }
    
    func setLeaderdCarpools(record: CKRecord) {
        guard let leaderedCarpool = Carpool(record: record) else { print("can't make carpool from record"); return }
        parent?.leaderdCarpools.append(leaderedCarpool)
        //parentsCarpoolsRecords.append(record)
    }
    
    func joinCarpool(record: CKRecord) {
        guard let parent = parent else {return}
        CloudKitManager.shared.modify(record, with: parent)
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
    }}}
}
























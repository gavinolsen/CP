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
    static let ParentChangedNotification = Notification.Name("ParentChangedNotification")
}

class ParentController {
    
    static let shared = ParentController()
    
    var parent: Parent?
    var parentName: String? {
        didSet {
            DispatchQueue.main.async {
                let nc = NotificationCenter.default
                nc.post(name: ParentController.ParentChangedNotification, object: self)
            }
        }
    }
    
    var parentRecordID: CKRecordID?
    
    //Mark: see if the user has cloud kit, ask for permissions, and get name
    func getParentInfo() {
        
        //right here i'll need to search through my database and
        //see if there's any records matching. I need to call this
        //function to get the logged in users record, then fetch that
        //record from my database

        CloudKitManager.shared.fetchCurrentUserRecords(Parent.typeKey) { (records, error, firstName, iCloudUserRecordID) in
            
            if let error = error {
                print("There was an error fetching current User record: \(error.localizedDescription)")
                return
            }
            
            if let record = records?.first {
                
                let parent = Parent(record: record)
                self.parent = parent
            } else {
                guard let firstName = firstName, let recordID = iCloudUserRecordID else { return }
                self.makeNewParent(name: firstName, recordID: recordID)
            }
            
        }
        
    }
    
    //MARK: get parent info!!!
    func getParent() {
        
        //now that i set the parentRecordID, i can run it through my database
        //to find the right parent object that matches this recordID
        guard let parentID = parentRecordID else { return }
        CloudKitManager.shared.fetchRecord(withID: parentID) { (record, error) in
            
            guard let parentRecord = record else { return }
            
            let thisParent = Parent(record: parentRecord)
            
            if thisParent == nil {
                
                repeat {
                    sleep(1)
                } while (self.parentName == nil)
                
                guard let name = self.parentName else { return }
                self.makeNewParent(name: name, recordID: parentRecord.recordID)
            } else {
                self.parent = thisParent
            }
        }
    }
    
    //MARK: get the username
    func fetchFirstName() {
        guard let parentID = parentRecordID else { return }
        CloudKitManager.shared.fetchUsername(for: parentID) { (firstName, lastName) in
            self.parentName = firstName
        }
    }
    
    //crud functions
    //create
    func makeNewParent(name: String, recordID: CKRecordID){
        
        let newParent = Parent(name: name, userRecordID: recordID)
        parent = newParent
        save(parent: newParent)
        print("made new parent")
    }
    
    //updating and editing the parent object
    func addChildToParent(name: String, age: Int, details: String) {
        guard let parent = parent else { return }
        let newChild = Child(name: name, age: age, details: details, parent: parent)
        parent.kids.append(newChild)
    }
    
    func makeCarpoolWithLeader(name: String, times: [Date]) {
        guard let parent = parent else { return }
        let newCarpool = Carpool(name: name, time: times, leader: parent)
        parent.carpools.append(newCarpool)
    }
    
    func addCarpoolToParent(carpool: Carpool) {
        parent?.carpools.append(carpool)
    }
    
    func removeCarpoolFromParent(carpool: Carpool) {
    }
    
    //MARK: saving
    
    func save(parent: Parent) {
        CloudKitManager.shared.saveRecord(CKRecord(parent)) { (record, error) in
            
            guard record != nil else {
                if let error = error {
                    NSLog("Error saving to CloudKit from ParentController: \(error)")
                    return
                }
                return
            }}}
}
























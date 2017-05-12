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
}

class ParentController {
    
    static let shared = ParentController()
    
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
            
            guard let name = firstName, let recordID = iCloudUserRecordID else { return }
            self.parentName = name
            
            if let record = records?.first {
                self.setParentWithRecord(record: record)
            } else {
                self.makeNewParent(name: name, recordID: recordID)
            }
        }
    }
    
    //crud functions
    //create
    func makeNewParent(name: String, recordID: CKRecordID){
        
        let newParent = Parent(name: name, userRecordID: recordID)
        parent = newParent
        save(parent: newParent)
    }
    
    func setParentWithRecord(record: CKRecord) {
        let savedParent = Parent(record: record)
        parent = savedParent
        parentRecord = record
    }
    
    func addChildToParent(kid: Child) {
        guard let parent = kid.parent else { print("bad parent"); return }
        let newChild = Child(name: kid.name, age: kid.age, details: kid.details, parent: parent)
        parent.kids.append(newChild)
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
























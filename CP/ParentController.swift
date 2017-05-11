//
//  ParentController.swift
//  CP
//
//  Created by Gavin Olsen on 5/10/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import Foundation
import CloudKit

class ParentController {
    
    static let shared = ParentController()
    
    let ckManager: CloudKitManager
    var parent: Parent?
    var parentName: String?
    var parentRecordID: CKRecordID?
    
    init() {
        self.ckManager = CloudKitManager()
        
    }
    
    //Mark: see if the user has cloud kit
    func getParentInfo() {
        
        //right here i'll need to search through my database and
        //see if there's any records matching. I need to call this
        //function to get the logged in users record, then fetch that 
        //record from my database
        
        ckManager.fetchLoggedInUserRecord { (record, error) in
            
            if let recordID = record?.recordID {
                
                if error != nil || record == nil {
                    print("there was an error fetching the loggedin user record")
                }
                
                self.ckManager.fetchRecord(withID: recordID, completion: { (record, error) in
                    
                    if error != nil || record == nil {
                        print("there was an error fetching the loggedin user record")
                    } else if error == nil && record == nil {
                        print("this user hasn't been created in the database")
                    } else {
                        self.fetchFirstName()
                    }
                })
            }
        }
    }
    
    //MARK: get the username
    func fetchFirstName() {
        
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            if error != nil {
                print("Something broke")
            
            }
        }
    }
    
    //crud functions
    //create
    func makeNewParent(name: String) -> Parent {
        
        var userID: CKRecordID?
        
        ckManager.fetchLoggedInUserRecord { (record, error) in
            guard let record = record else { return }
            userID = record.recordID
        }
        
        let newParent = Parent(name: name, userRecordID: userID)
        parent = newParent
        save(parent: newParent)
        return newParent
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
        ckManager.saveRecord(CKRecord(parent)) { (record, error) in
            
            guard record != nil else {
                if let error = error {
                    NSLog("Error saving to CloudKit from ParentController: \(error)")
                    return
                }
            return
    }}}
}
    //MARK: fetching
    
//    func fetchRecordsOf(type: String, completion: @escaping (() -> Void) = { _ in }) {
//        
//        var excludedReferences = [CKReference]()
//        var predicate: NSPredicate!
//        
//        
//    }

























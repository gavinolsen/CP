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
    
    init() {
        self.ckManager = CloudKitManager()
        
    }
    
    //MARK: get the username
    func fetchFirstName() {
        
        ckManager.fetchLoggedInUserRecord { (record, error) in
            
            guard let record = record else { NSLog("bad recored"); return }
            if error != nil { NSLog("there's an error retreiving the users") }
            
            self.ckManager.fetchUsername(for: record.recordID, completion: { (firstName, lastName) in
                guard let firstName = firstName else { NSLog("bad first name"); return }
                self.parent?.name = firstName
            })
        }
    }
    
    //crud functions
    //create
    func makeNewParent(name: String, completion: ((Parent) -> Void)?) {
        let newParent = Parent(name: name)
        parent = newParent
        save(parent: newParent)
        completion?(newParent)
        return
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
        ckManager.saveRecord(record: CKRecord(parent)) { (record, error) in
            
            guard record != nil else {
                if let error = error {
                    NSLog("Error saving to CloudKit from ParentController: \(error)")
                    return
                }
            return
    }}}
    
    //MARK: fetching
    
//    func fetchRecordsOf(type: String, completion: @escaping (() -> Void) = { _ in }) {
//        
//        var excludedReferences = [CKReference]()
//        var predicate: NSPredicate!
//        
//        
//    }
}
























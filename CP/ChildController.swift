//
//  ChildController.swift
//  CP
//
//  Created by Gavin Olsen on 5/10/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import Foundation
import CloudKit

extension ChildController {
    
     static let ChildrenInCarpoolChangedNotification = Notification.Name("ChildrenInCarpoolChangedNotification")
}

class ChildController {
    
    static let shared = ChildController()
    
    //this variable is used to track the kids of other
    //carpools and other parents
    
    var kids: [Child] = [] {
        didSet {
            DispatchQueue.main.async {
                let nc = NotificationCenter.default
                nc.post(name: ChildController.ChildrenInCarpoolChangedNotification, object: self)
        }}}
    
    var kidRecords: [CKRecord] = []
    
    //adding carpool to the kid
    
    //fetching the kids that are in the carpool
    func getKidsIn(carpool: Carpool) {
      
        kids = []
        guard let recordID = carpool.ckRecordID else { return }
        CloudKitManager.shared.fetchRecord(withID: recordID) { (record, error) in
            
            guard let kidReferences = record?[Carpool.kidKey] as? [CKReference] else { return }
            
            for reference in kidReferences {
                CloudKitManager.shared.fetchRecord(withID: reference.recordID, completion: { (record, error) in
                    guard let record = record else { return }
                    guard let kid = Child(record: record) else { print("bad record"); return }
                    self.kids.append(kid)
                    self.kidRecords.append(record)
                })
    }}}
    
    //MARK: saving + modifying
    func save(kid: Child) {
        guard let record = CKRecord(kid) else { return }
        CloudKitManager.shared.saveRecord(record) { (record, error) in
            
            guard record != nil else {
                if let error = error {
                    NSLog("Error saving to CloudKit from ParentController: \(error)")
                    return
                }
                return
    }}}
    
    func modifyChild(kid: Child) {
        
        guard let record = CKRecord(kid) else { return }
        CloudKitManager.shared.modifyRecords([record], perRecordCompletion: { (record, error) in
            
            guard record != nil else {
                if let error = error {
                    NSLog("Error saving to CloudKit from ParentController: \(error)")
                    return
                }
                return
        }})
    }

    func deleteChild(kid: Child) {
        
        guard let recordID = kid.ckRecordID else { print("bad record id from kid"); return }
        
        CloudKitManager.shared.deleteRecordWithID(recordID) { (recordID, error) in
            
            if error != nil {
                print("there was an error deleting the kid")
            }
            return
        }}
}

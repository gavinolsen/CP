//
//  ChildController.swift
//  CP
//
//  Created by Gavin Olsen on 5/10/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import Foundation
import CloudKit

class ChildController {
    
    static let shared = ChildController()
    
    //adding carpool to the kid
    
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
            }
            
        })
        
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

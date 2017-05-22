//
//  CarpoolController.swift
//  CP
//
//  Created by Gavin Olsen on 5/10/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import Foundation
import CloudKit

class CarpoolController {
    
    var carpools: [Carpool]?
    var carpoolRecords: [CKRecord]?
    
    static let shared = CarpoolController()
    let ckManager: CloudKitManager
    
    init() {
        self.ckManager = CloudKitManager()
    }
    
    //MARK: adding objects to carpool
    
    func fetchCarpoolsForParent(reference: CKReference) {
        
        let predicate = NSPredicate(format: "%K == %@", Carpool.leaderKey, reference)
        
        CloudKitManager.shared.fetchRecordsWithType(Carpool.typeKey, predicate: predicate) { (records, error) in
            
            guard let records = records else { print("couldn't get the records for the carpools");return }
            
            for record in records {
                self.carpoolRecords?.append(record)
                guard let newCarpool = Carpool(record: record) else { print("badrecord"); return }
                self.carpools?.append(newCarpool)
    }}}
    
    //MARK: save
    
    func save(_ carpool: Carpool) {
        
        ckManager.saveRecord(CKRecord(carpool)) { (record, error) in
            
            guard record != nil else {
                if let error = error {
                    NSLog("Error saving to CloudKit from ParentController: \(error)")
                    return
                }
                return
    }}}
    
    func modify(_ carpool: Carpool, withRecord record: CKRecord) {
        
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

//
//  CarpoolController.swift
//  CP
//
//  Created by Gavin Olsen on 5/10/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import Foundation
import CloudKit

extension CarpoolController {
    static let OtherParentsCarpoolArrayNotification = Notification.Name("CarpoolArrayOfAnotherParentNotification")
}

class CarpoolController {
    
    var carpools: [Carpool] = [] {
        didSet{
            DispatchQueue.main.async {
                let nc = NotificationCenter.default
                nc.post(name: CarpoolController.OtherParentsCarpoolArrayNotification, object: self)
        }}}
    
    var carpoolRecords: [CKRecord] = []
    
    static let shared = CarpoolController()
    let ckManager: CloudKitManager
    
    init() {
        self.ckManager = CloudKitManager()
    }
    
    //MARK: adding objects to carpool
    
    func getCarpoolsFromParent(parent: Parent) {
        
        guard let reference = parent.ckReference else { print("bad reference from parent");return }
        
        fetchCarpoolsForParent(reference: reference)
    }
    
    func fetchCarpoolsForParent(reference: CKReference?) {
        
        guard let reference = reference else { print("bad reference"); return }
        let predicate = NSPredicate(format: "%K == %@", Carpool.leaderKey, reference)
        
        CloudKitManager.shared.fetchRecordsWithType(Carpool.typeKey, predicate: predicate) { (records, error) in
            
            guard let records = records else { print("couldn't get the records for the carpools");return }
            
            for record in records {
                self.carpoolRecords.append(record)
                guard let newCarpool = Carpool(record: record) else { print("badrecord"); return }
                self.carpools.append(newCarpool)
                
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
    
    func modify(_ record: CKRecord) {
     
        guard let parent = ParentController.shared.parent else { return }
        
        CloudKitManager.shared.modify(record, with: parent)
        
    }
}


















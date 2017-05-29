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
    static let ParentsCarpoolArrayNotification = Notification.Name("CarpoolArrayOfParentNotification")
}

class CarpoolController {
    
    var carpools: [Carpool] = [] {
        didSet{
            DispatchQueue.main.async {
                let nc = NotificationCenter.default
                nc.post(name: CarpoolController.OtherParentsCarpoolArrayNotification, object: self)
        }}}
    
    var parentsCarpools: [Carpool] = [] {
        didSet{
            DispatchQueue.main.async {
                let nc = NotificationCenter.default
                nc.post(name: CarpoolController.ParentsCarpoolArrayNotification, object: self)
            }}
    }
    
    //used for modifying records
    var carpoolRecords: [CKRecord] = []
    
    static let shared = CarpoolController()
    let ckManager: CloudKitManager
    
    init() {
        self.ckManager = CloudKitManager()
    }
    
    func makeNewCarpool(name: String, timeStrings: [String], days: [Int], hours: [Int], minutes: [Int], components: [DateComponents], kids: [Child], leader: Parent, driver: Parent, completion: ((_ passowrd: String?) -> Void)? = { _ in}) -> Carpool? {
        
        //now i want to make the password.
        //i'll probabaly pass it back
        //through a completion and alert
        //the leader of the carpool
        //what the key is...
        
        guard let passkey = UUID().uuidString.components(separatedBy: "-").first else { return nil}
        completion?(passkey)
        let newCarpool = Carpool(name: name, timeStrings: timeStrings, days: days, hours: hours, minutes: minutes, components: components, drivers: [driver], kids: kids, leader: leader, passkey: passkey)
        save(newCarpool)
        
        return newCarpool
    }
    
    //MARK: adding objects to carpool
    
    func getCarpoolsFromParent(parent: Parent) {
        
        guard let reference = parent.ckReference else { print("bad reference from parent");return }
        
        fetchCarpoolsForParent(reference: reference)
    }
    
    func fetchCarpoolsForParent(reference: CKReference) {
        
        carpoolRecords = []
        
        let predicate = NSPredicate(format: "%K == %@", Carpool.leaderKey, reference)
        
        CloudKitManager.shared.fetchRecordsWithType(Carpool.typeKey, predicate: predicate) { (records, error) in
            
            guard let records = records else { print("couldn't get the records for the carpools");return }
            
            for record in records {
                self.carpoolRecords.append(record)
                guard let newCarpool = Carpool(record: record) else { print("badrecord"); return }
                self.carpools.append(newCarpool)
    }}}
    
    //MARK: save
    
    func fetchCarpoolWithKey(passKey: String, completion: @escaping ((_ carpool: Carpool?) -> Void)) {
        
        let predicate = NSPredicate(format: "%K == %@", Carpool.passkey, passKey)
        
        carpoolRecords = []
        
        CloudKitManager.shared.fetchRecordsWithType(Carpool.typeKey, predicate: predicate, recordFetchedBlock: { (record) in
            guard let carpool = Carpool(record: record) else { return }
            self.carpoolRecords.append(record)
            completion(carpool)
        }, completion: nil)
    }
    
    func save(_ carpool: Carpool) {
        
        ckManager.saveRecord(CKRecord(carpool)) { (record, error) in
            
            guard record != nil else {
                if let error = error {
                    NSLog("Error saving to CloudKit from ParentController: \(error)")
                    return
                }
                return
    }}}
    
    func modifyParent(_ record: CKRecord) {
        guard let parent = ParentController.shared.parent else { return }
        CloudKitManager.shared.modify(record, with: parent)
    }
    
    func modify(carpoolRecord: CKRecord, with kid: Child) {
        CloudKitManager.shared.modify(carpoolRecord, with: kid)
    }
    
    func deleteCarpool(_ record: CKRecord) {
        CloudKitManager.shared.deleteRecordWithID(record.recordID) { (recordID, error) in
            
        }
    }
}


















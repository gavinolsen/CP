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
    
    var carpool: Carpool?
    
    static let shared = CarpoolController()
    let ckManager: CloudKitManager
    
    init() {
        self.ckManager = CloudKitManager()
    }
    
    //MARK: adding objects to carpool
    func addParentToCarpool(parent: Parent) {
        carpool?.drivers?.append(parent)
    }
    
    func addChildToCarpool(kid: Child) {
        carpool?.kids?.append(kid)
    }
    
    func setTimeOfCarpool(times: [Date]) {
        
        carpool?.eventTimes = times
        
        //this is where i'll be managing all of the push notifications
        
        
    }
    
    //MARK: save
    
    func save() {
        guard let carpool = carpool else { return }
        ckManager.saveRecord(CKRecord(carpool)) { (record, error) in
            
            guard record != nil else {
                if let error = error {
                    NSLog("Error saving to CloudKit from ParentController: \(error)")
                    return
                }
                return
    }}}
    
}

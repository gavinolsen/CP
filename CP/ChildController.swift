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
  
    var kid: Child?
    
    static let shared = ChildController()
    
    //adding carpool to the kid
    func addCarpoolToKid(carpool: Carpool) {
        kid?.carpools.append(carpool)
    }
    
    
    //MARK: saving
    
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
}

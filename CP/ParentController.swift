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
    
    var kids: [Child]? {
        guard let parent = parent else { return nil }
        return parent.kids
    }
    
    init() {
        self.ckManager = CloudKitManager()
    }
    
    //crud functions
    //create
    func makeNewParent(name: String, completion: ((Parent) -> Void)?) {
        let newParent = Parent(name: name)
        parent = newParent
        
       ckManager.saveRecord(record: CKRecord(newParent)) { (record, error) in

            guard record != nil else {
                if let error = error {
                    NSLog("Error saving new parent to CloudKit: \(error)")
                    return
                }
                return
            }
        }
    }
    
    //updating and editing
    func addChildToParent(name: String, age: Int, details: String) {
        guard let parent = parent else { return }
        let newChild = Child(name: name, age: age, details: details, parent: parent)
        parent.kids.append(newChild)
    }
    
    func makeCarpool(name: String, times: [Date]) {
        guard let parent = parent else { return }
        let newCarpool = Carpool(name: name, time: times, leader: parent)
        parent.carpools.append(newCarpool)
    }
    
    func addCarpoolToParent(carpool: Carpool) {
        parent?.carpools.append(carpool)
    }
    
    func removeCarpoolFromParent(carpool: Carpool) {
    }
}

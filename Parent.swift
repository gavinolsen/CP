//
//  User.swift
//  CP
//
//  Created by Gavin Olsen on 5/8/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

/*****************************************
 the user needs an array of children, and an 
 array of carpools.
 *****************************************/

import Foundation
import CloudKit

class Parent: CloudKitSync {
    
    /////////////
    // KEYS
    static let typeKey = "parenttype"
    static let nameKey = "namekey"
    static let kidKey = "kidkey"
    static let carpoolKey = "carpoolkey"
    ////////////
    
    ////////////
    //properties
    ////////////
    
    var name: String = ""
    var kids: [Child] = []
    var carpools: [Carpool] = []
    var recordType: String { return Parent.typeKey }
    var ckRecordID: CKRecordID?
    
    /////////////
    //initilizers
    /////////////
    
    init(name: String, kids: [Child], carpools: [Carpool]) {
        
        self.name = name
        self.kids = kids
        self.carpools = carpools
    }
    
    convenience required init?(record: CKRecord) {
        
        guard let name = record[Parent.nameKey] as? String, let kids = record[Parent.kidKey] as? [Child], let carpools = record[Parent.carpoolKey] as? [Carpool] else { return nil }
        self.init(name: name, kids: kids, carpools: carpools)
        ckRecordID = record.recordID
    }
    
}

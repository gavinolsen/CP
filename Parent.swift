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
 This will be comparable to teh
 *****************************************/

import Foundation
import CloudKit

class Parent: CloudKitSync {
    
    //MARK: keys
    static let typeKey = "parenttype"
    static let nameKey = "namekey"
    static let kidKey = "kidkey"
    static let carpoolKey = "carpoolkey"
    static let carpoolDictKey = "carpoolDictKey"
    
    /****************************************
     
     i'm thinking about making a dictionary of type
     [Carpool: Bool]
     where the boolean would indicate if the parent
     is the leader of that carpool ( when a carpool is the whole schedule)
     this means that i would have to conform to the 
     hashable protocol, and i'd have to implement 
     
     -------------------------------------------
     extension GridPoint: Hashable {
     var hashValue: Int {
     return x.hashValue ^ y.hashValue
     }
     
     static func == (lhs: GridPoint, rhs: GridPoint) -> Bool {
     return lhs.x == rhs.x && lhs.y == rhs.y
     }
     }
     -------------------------------------------
     
     this functionality
     
    *****************************************/
    
    static let isLeaderKey = "leader????"
    
    //MARK: properties
    let name: String
    var kids: [Child]
    var carpools: [Carpool]
    var isLeader: Bool
    
    var recordType: String { return Parent.typeKey }
    var ckRecordID: CKRecordID?
    
    //MARK: initilizers
    init(name: String, kids: [Child] = [], carpools: [Carpool] = [], isLeader: Bool) {
        self.name = name
        self.kids = kids
        self.carpools = carpools
        self.isLeader = isLeader
    }
    
    convenience required init?(record: CKRecord) {
        guard let name = record[Parent.nameKey] as? String, let kids = record[Parent.kidKey] as? [Child], let carpools = record[Parent.carpoolKey] as? [Carpool], let isLeader = record[Parent.isLeaderKey] as? Bool else { return nil }
        self.init(name: name, kids: kids, carpools: carpools, isLeader: isLeader)
        ckRecordID = record.recordID
    }
    
}

extension Parent: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        return name.contains(searchTerm)
    }
}






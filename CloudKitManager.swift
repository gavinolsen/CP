//
//  CloudKitManager.swift
//  CP
//
//  Created by Gavin Olsen on 5/8/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    func fetchUserRecord(_ completion: ((_ record: CKRecord?, _ error: Error?) -> Void)?) {
        
    }
    
    func fetchUsername(recordID: CKRecordID, completion: @escaping ((_ givenName: String?, _ familyName: String?) -> Void) = { _,_ in }) {
        
    }
    
    
}

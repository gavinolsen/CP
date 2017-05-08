//
//  CloudKitSync.swift
//  CP
//
//  Created by Gavin Olsen on 5/8/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import Foundation
import CloudKit

protocol CloudKitSync {
    
    init?(record: CKRecord)
    
    var ckRecordID: CKRecordID? { get set }
    var recordType: String { get }
}

extension CloudKitSync {
    
    var isSynced: Bool {
        return ckRecordID != nil
    }
    
    var ckReference: CKReference? {
        
        guard let recordID = ckRecordID else { return nil }
        
        return CKReference(recordID: recordID, action: .none)
    }
}

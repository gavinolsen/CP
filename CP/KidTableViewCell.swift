//
//  KidTableViewCell.swift
//  CP
//
//  Created by Gavin Olsen on 5/13/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import UIKit

class KidTableViewCell: UITableViewCell {

    @IBOutlet weak var kidNameLabel: UILabel!
    @IBOutlet weak var kidCarpoolDetails: UILabel!
    
    func setViewWith(kid: Child) {
        
        kidNameLabel.text = kid.name
        kidCarpoolDetails.text = kid.details
        
    }

}

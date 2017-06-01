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
        kidCarpoolDetails.text = getCarpoolsText(kid: kid)
        
        kidNameLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
    }
    
    func getCarpoolsText(kid: Child) -> String {
        
        if kid.carpools.count == 0 {
            return "0 carpools"
        } else if kid.carpools.count == 1 {
            return "1 carpool"
        } else {
            return "\(kid.carpools.count) carpools"
        }
    }

}

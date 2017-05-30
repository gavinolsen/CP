//
//  Theme.swift
//  CP
//
//  Created by Gavin Olsen on 5/28/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import Foundation
import UIKit

enum Theme {
    
    static func configAppearance() {
        
        UINavigationBar.appearance().barTintColor = .timePurple
        
        
        UITabBar.appearance().backgroundColor = .timePurple
        UITabBar.appearance().barTintColor = .timePurple
        
//        let theme: UIColor = .timeLightOrange
//        
//        UITableView.appearance().backgroundColor = theme
//        UITableViewCell.appearance().backgroundColor = theme
//        
//        //UIView.appearance().backgroundColor = theme
//        
//        UIPickerView.appearance().backgroundColor = theme
//        
//        UITableViewCell.appearance().textLabel?.textColor = theme
    }
    
}


/*
 
 static var timePurple: UIColor {
 return UIColor(red: 51.0/255.0, green: 37.0/255.0, blue: 50.0/255.0, alpha: 1.0)
 }
 
 static var timeLightPurple: UIColor {
 return UIColor(red: 101.0/255.0, green: 77.0/255.0, blue: 82.0/255.0, alpha: 1.0)
 }
 
 static var timeOrange: UIColor {
 return UIColor(red: 249.0/255.0, green: 122.0/255.0, blue: 76.0/255.0, alpha: 1.0)
 }
 
 static var timeLightOrange: UIColor {
 return UIColor(red: 255.0/255.0, green: 151.0/255.0, blue: 70.0/255.0, alpha: 1.0)
 }
 
 static var timeGrey: UIColor {
 return UIColor(red: 164.0/255.0, green: 154.0/255.0, blue: 134.0/255.0, alpha: 1.0)
 }

 */

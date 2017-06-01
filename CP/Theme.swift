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
        
        UINavigationBar.appearance().barTintColor = .carpoolPurple
        
        //I want to round the
        UINavigationBar.appearance().layer.cornerRadius = 20
        
        UIView.appearance().layer.cornerRadius = 100
        
        UITabBar.appearance().backgroundColor = .carpoolPurple
        UITabBar.appearance().barTintColor = .carpoolPurple
        
        UITabBar.appearance().tintColor = .timeLightOrange
        
        UINavigationBar.appearance().tintColor = .timeLightOrange
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        UITableViewCell().textLabel?.font = UIFont(name: "GillSans-UltraBold", size: 30)
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

extension UIView {
    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 3.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}







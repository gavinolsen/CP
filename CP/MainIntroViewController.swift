//
//  MainIntroViewController.swift
//  CP
//
//  Created by Gavin Olsen on 5/31/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import UIKit

class MainIntroViewController: UIViewController {
    
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    let doneButton = UIButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupContstraints()
    }
    
    func segue() {
        performSegue(withIdentifier: "secondMainINtro", sender: nil)
    }

    func setupView() {
        
        titleLabel.text = "Welcome to CP!"
        detailLabel.text = "Your app will load on the main page, where you can view your schedule for the next few days"
        
        doneButton.setTitle("Next", for: .normal)
        
        let font = UIFont(name: "AppleSDGothicNeo-Thin", size: 25)
        let bigFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        
        titleLabel.font = bigFont
        detailLabel.font = font
        
        
        titleLabel.numberOfLines = 0
        detailLabel.numberOfLines = 0
        
        doneButton.layer.cornerRadius = 50
        
        titleLabel.textColor = .timeLightOrange
        detailLabel.textColor = .timeLightOrange
        doneButton.titleLabel?.textColor = .carpoolPurple
        doneButton.backgroundColor = .timeLightOrange
        
        doneButton.addTarget(self, action: #selector(segue), for: .touchUpInside)
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(detailLabel)
        self.view.addSubview(doneButton)
        
    }
   
    func setupContstraints() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        let topTitle = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 75)
        let leadTitle = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20)
        let trailTitle = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -20)
        
        self.view.addConstraints([topTitle, leadTitle, trailTitle])
        
        let topDetail = NSLayoutConstraint(item: detailLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 40)
        let leadDetail = NSLayoutConstraint(item: detailLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20)
        let trailDetail = NSLayoutConstraint(item: detailLabel, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -20)
        
        self.view.addConstraints([topDetail, leadDetail, trailDetail])
        
        let topButton = NSLayoutConstraint(item: doneButton, attribute: .top, relatedBy: .equal, toItem: detailLabel, attribute: .bottom, multiplier: 1, constant: 100)
        let leadButton = NSLayoutConstraint(item: doneButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let trailButton = NSLayoutConstraint(item: doneButton, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        
        self.view.addConstraints([topButton, leadButton, trailButton])
        
    }
    
}


















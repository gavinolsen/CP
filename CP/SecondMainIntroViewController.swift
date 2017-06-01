//
//  2MainIntroViewController.swift
//  CP
//
//  Created by Gavin Olsen on 6/1/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import UIKit

class SecondMainIntroViewController: UIViewController {

    let titleLabel = UILabel()
    let detailLabel = UILabel()
    let doneButton = UIButton()
    let familyImageView = UIImageView(image: #imageLiteral(resourceName: "family_icon_32"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupContstraints()
    }
    
    func segue() {
        performSegue(withIdentifier: "thirdMainIntro", sender: nil)
    }
    
    func setupView() {
        
        titleLabel.text = "The first thing you need to do is enter all your kids"
        detailLabel.text = "You can add as many kids as you like from the family tab on the tab bar from the home screen"
        
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
        familyImageView.backgroundColor = .timeLightOrange
        
        doneButton.addTarget(self, action: #selector(segue), for: .touchUpInside)
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(detailLabel)
        self.view.addSubview(doneButton)
        self.view.addSubview(familyImageView)
        
    }
    
    func setupContstraints() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        familyImageView.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        let bottomFam = NSLayoutConstraint(item: familyImageView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -20)
        let widthFam = NSLayoutConstraint(item: familyImageView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: (1/8), constant: 0)
        let heightFam = NSLayoutConstraint(item: familyImageView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1/12, constant: 0)
        let trailFam = NSLayoutConstraint(item: familyImageView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -125)
        
        self.view.addConstraints([bottomFam, widthFam, heightFam, trailFam])
        
    }


}








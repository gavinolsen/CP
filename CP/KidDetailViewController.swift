//
//  KidDetailViewController.swift
//  CP
//
//  Created by Gavin Olsen on 5/11/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import UIKit

class KidDetailViewController: UIViewController {
    
    var kid: Child?

    let nameLabel = UILabel()
    let childNameTextField = UITextField()
    let childAgeLabel = UILabel()
    let agePicker = UIPickerView()
    let detailLabel = UILabel()
    let detailTextView = UITextView()
    
    var possibleAges: [String] {
        var array: [String] = []
        
        for i in 1...18 {
            let min = "\(i)"
            array.append(min)
        }
        return array
    }
    
    var pickerData: [[String]] = [[]]
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerData = [possibleAges]
        
        self.agePicker.delegate = self
        self.agePicker.dataSource = self
        
        setupViews()
        setupConstraints()
        
        if let kid = kid {
            setViewFor(child: kid)
        }
        
    }

    @IBAction func saveChild(_ sender: Any) {
        
        
        if kid == nil {
            makeNewChild()
            let nc = navigationController
            nc?.popViewController(animated: true)
        } else {
            guard let kid = kid else {return}
            setChildFromView()
            ChildController.shared.modifyChild(kid: kid)
        }
        
    }
    
    func makeNewChild() {
        
        let selectedAge = agePicker.selectedRow(inComponent: 0)
        guard let age = Int(possibleAges[selectedAge]) else { print("bad age"); return}
        
        guard let name = childNameTextField.text, let details = detailTextView.text else { return }
        guard let parent = ParentController.shared.parent else { print("the parent in the parent controller is null"); return }
        let newChild = Child(name: name, age: age, details: details, parent: parent)
        
        ParentController.shared.parent?.kids.append(newChild)
        ChildController.shared.save(kid: newChild)
        //ParentController.shared.fetchKidsFromParent()
    }
    
    func setChildFromView() {
        
        let selectedAge = agePicker.selectedRow(inComponent: 0)
        guard let age = Int(possibleAges[selectedAge]) else { print("bad age"); return}
        
        guard let name = childNameTextField.text, let details = detailTextView.text else { return }

        guard let kid = kid else { return }
        
        kid.age = age
        kid.name = name
        kid.details = details
        
    }
    
    func setViewFor(child: Child) {
        childNameTextField.text = child.name
        detailTextView.text = child.details
        
        agePicker.selectRow((child.age - 1), inComponent: 0, animated: true)
    }

    
}

extension KidDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return pickerData.count }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return pickerData[component].count}
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return pickerData[component][row] }
    
    func setupViews() {
        
        nameLabel.text = "Child's name:"
        childNameTextField.placeholder = "name"
        childAgeLabel.text = "Child's age:"
        
        detailLabel.text = "Details & emergency info:"
        detailTextView.isEditable = true
        
        self.view.addSubview(nameLabel)
        self.view.addSubview(childNameTextField)
        self.view.addSubview(childAgeLabel)
        self.view.addSubview(agePicker)
        self.view.addSubview(detailLabel)
        self.view.addSubview(detailTextView)
        
    }
    
    func setupConstraints() {
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        childNameTextField.translatesAutoresizingMaskIntoConstraints = false
        childAgeLabel.translatesAutoresizingMaskIntoConstraints = false
        agePicker.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabelTop = NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 75)
        let nameLabelLead = NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let nameLabelTrail = NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        let nameLabelHeight = NSLayoutConstraint(item: nameLabel, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1/10, constant: 0)
        let nameLabelWidth = NSLayoutConstraint(item: nameLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0)
        
        self.view.addConstraints([nameLabelTop, nameLabelLead, nameLabelTrail, nameLabelWidth, nameLabelHeight])
        
        let nameTextTop = NSLayoutConstraint(item: childNameTextField, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 0)
        let nameTextLead = NSLayoutConstraint(item: childNameTextField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let nameTextTrail = NSLayoutConstraint(item: childNameTextField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        
        self.view.addConstraints([nameTextTop, nameTextLead, nameTextTrail])
        
        let ageLabelTop = NSLayoutConstraint(item: childAgeLabel, attribute: .top, relatedBy: .equal, toItem: childNameTextField, attribute: .bottom, multiplier: 1, constant: 0)
        let ageLabelLead = NSLayoutConstraint(item: childAgeLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let ageLabelTrail = NSLayoutConstraint(item: childAgeLabel, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        
        self.view.addConstraints([ageLabelTop, ageLabelLead, ageLabelTrail])
        
        let pickerTop = NSLayoutConstraint(item: agePicker, attribute: .top, relatedBy: .equal, toItem: childAgeLabel, attribute: .bottom, multiplier: 1, constant: 0)
        let pickerLead = NSLayoutConstraint(item: agePicker, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let pickerTrail = NSLayoutConstraint(item: agePicker, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        
        self.view.addConstraints([pickerTop, pickerLead, pickerTrail])
        
        let detailLabelTop = NSLayoutConstraint(item: detailLabel, attribute: .top, relatedBy: .equal, toItem: agePicker, attribute: .bottom, multiplier: 1, constant: 0)
        let detailLabelLead = NSLayoutConstraint(item: detailLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let detailLabelTrail = NSLayoutConstraint(item: detailLabel, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        
        self.view.addConstraints([detailLabelTop, detailLabelLead, detailLabelTrail])
        
        let textViewTop = NSLayoutConstraint(item: detailTextView, attribute: .top, relatedBy: .equal, toItem: detailLabel, attribute: .bottom, multiplier: 1, constant: 0)
        let textViewLeading = NSLayoutConstraint(item: detailTextView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let textViewTrailing = NSLayoutConstraint(item: detailTextView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        let textViewHeight = NSLayoutConstraint(item: detailTextView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1/5, constant: 0)
        let textViewWidth = NSLayoutConstraint(item: detailTextView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0)
        
        self.view.addConstraints([textViewTop, textViewLeading, textViewTrailing, textViewHeight, textViewWidth])
        
    }
}










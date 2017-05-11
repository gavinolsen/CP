//
//  KidDetailViewController.swift
//  CP
//
//  Created by Gavin Olsen on 5/11/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import UIKit

class KidDetailViewController: UIViewController {

    @IBOutlet weak var childNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func saveChild(_ sender: Any) {
        
        makeNewChild()
        
        print("child saved")
        let nc = navigationController
        nc?.popViewController(animated: true)
    }
    
    func makeNewChild() {
        
        guard let name = childNameTextField.text else { return }
        guard let parent = ParentController.shared.parent else { return }
        let newChild = Child(name: name, age: 5, details: "", parent: parent)
        ChildController.shared.save(kid: newChild)
    }
}

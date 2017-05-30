//
//  ChangeNameViewController.swift
//  CP
//
//  Created by Gavin Olsen on 5/29/17.
//  Copyright © 2017 Gavin Olsen. All rights reserved.
//

import UIKit

class ChangeNameViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeUsersName(_ sender: Any) {
        
        if nameTextField.text == nil || nameTextField.text == "" {
            
            enterValidNameAlert()
            return
        }
        
        ParentController.shared.changeParent(name: nameTextField.text ?? "default name")
        let nc = navigationController
        nc?.popViewController(animated: true)
    }
    
    func enterValidNameAlert() {
        let alertCon = UIAlertController(title: "no can do", message: "you have to enter a good name buddy", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertCon.addAction(alertAction)
        present(alertCon, animated: true, completion: nil)
    }
    
}

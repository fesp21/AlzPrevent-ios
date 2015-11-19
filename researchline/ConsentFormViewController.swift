//
//  ConsentFormViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit

class ConsentFormViewController: UIViewController {

    @IBOutlet weak var firstNameTextLabel: UITextField!
    @IBOutlet weak var lastNameTextLabel: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func editingChangedTextLabel(sender: AnyObject) {
        let firstName = firstNameTextLabel.text ?? ""
        let lastName = lastNameTextLabel.text ?? ""
        
        nextButton.enabled = !firstName.isEmpty && !lastName.isEmpty
    }
    
    @IBAction func touchUpInsideNextButton(sender: UIButton) {
        let firstName = firstNameTextLabel.text
        let lastName = lastNameTextLabel.text
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(firstName, forKey: "firstName")
        userDefaults.setObject(lastName, forKey: "lastName")
    }
}
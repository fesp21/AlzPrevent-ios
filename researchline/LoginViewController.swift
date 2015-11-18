//
//  LoginViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = false
    }
    
    @IBAction func touchUpInsideDoneBarButtonItem(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()!
        
        presentViewController(controller, animated: true, completion: nil)
    }
}
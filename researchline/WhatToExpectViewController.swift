//
//  WhatToExpectViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit
import HealthKit

class WhatToExpectViewController: UIViewController {
    
    @IBAction func touchUpInsideGotItButton(sender: UIButton) {
        HealthManager.requestAuthorizationToShareTypes { (success, unavailables: [String]) -> Void in
            if success {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let storyboard = UIStoryboard(name: "Session", bundle: nil)
                    let controller = storyboard.instantiateInitialViewController()!
                    
                    self.navigationController?.pushViewController(controller, animated: true)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    UIAlertView(title: "Please...", message: String("You must %s authorize all types.", unavailables.joinWithSeparator(", ")), delegate: nil, cancelButtonTitle: "Okay").show()
                })
            }
        }
    }
}
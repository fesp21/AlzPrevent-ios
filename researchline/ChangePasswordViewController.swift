//
//  ChangePasswordViewController.swift
//  researchline
//
//  Created by Leo Kang on 11/22/15.
//  Copyright © 2015 bbb. All rights reserved.
//

import UIKit
import Alamofire

class ChangePasswordViewController: UIViewController {

    @IBAction func clickYesButton(sender: AnyObject) {
        
        Alamofire.request(.POST, Constants.findPassword,
            parameters: [
                "email": Constants.email()
            ])
            .responseString { (response: Response) -> Void in
                
                debugPrint(response)
                    
                let alert = UIAlertController(title: "Alert", message: "Send a email for changing password. Please check your email.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion:{ () -> Void in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
        }
    }

    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
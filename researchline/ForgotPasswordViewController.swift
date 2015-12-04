//
//  ForgotPasswordViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit
import Alamofire

class ForgotPasswordViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var emailText: UITextField!
    
    @IBAction func clickSubmit(sender: AnyObject) {
        let email = emailText.text!
        
        Alamofire.request(.POST, Constants.findPassword,
            parameters: [
                "email": email
            ])
            .responseString { (response: Response) -> Void in
                
                debugPrint(response)
                
                func completionHandler(action: UIAlertAction) {
                    self.navigationController?.popViewControllerAnimated(true)
                }
                
                let alert = UIAlertController(title: "Alert", message: "Send a email for changing password. Please check your email.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: completionHandler))
                self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
//
//  EmailVerificationViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit
import Alamofire

class EmailVerificationViewController: UIViewController {

    @IBOutlet weak var emailText: UILabel!
    
    @IBAction func clickContinue(sender: AnyObject) {
        let email = Constants.userDefaults.stringForKey("email")
        
        Alamofire.request(.GET, Constants.checkVerifyingEmail,
            parameters: [
                "email": email!
            ])
            .responseJSON { (response: Response) -> Void in
                
                switch response.result {
                case.Success:
                    debugPrint(response)
                    
                    let storyboard = UIStoryboard(name: "Session", bundle: nil)
                    let controller = storyboard.instantiateViewControllerWithIdentifier("AllSetViewController")
                    self.presentViewController(controller, animated: true, completion: nil)
                    
                    break
                case .Failure:
                    debugPrint(response)
                    
                    let alert = UIAlertController(title: "Alert", message: "Fail to email verification. Please verify email.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                    break
                }
                
        }
        
    }
    
    
    @IBAction func resendVerificationEmail(sender: AnyObject) {
        verifyingEmail()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Constants.userDefaults.setObject(Constants.STEP_EMAIL_VERIFICATION, forKey: "registerStep")
        
        verifyingEmail()
    }
    
    override func viewDidAppear(animated: Bool) {
        let email = Constants.userDefaults.stringForKey("email")
        if(email == nil){
            return
        }
        self.emailText.text = email
    }

    internal func verifyingEmail(){
        let email = Constants.userDefaults.stringForKey("email")
        if(email == nil){
            return
        }
        self.emailText.text = email
        
        // Do any additional setup after loading the view.

        Alamofire.request(.GET, Constants.requestVerifyingEmail,
            parameters: [
                "email": email!
            ])
            .responseJSON { (response: Response) -> Void in
                    
                switch response.result {
                case.Success:
                    debugPrint(response)
                    print("Success sending verification email.")
                    
                    break
                case .Failure:
                    debugPrint(response)
                    print("Fail sending verification email.")
                    
                    break
                }
          
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

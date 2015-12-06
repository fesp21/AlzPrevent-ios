//
//  ChangeEmailViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit
import Alamofire

class ChangeEmailViewController: UIViewController {

    @IBOutlet weak var emailLabel: UITextField!
    
    
    @IBAction func done(sender: AnyObject) {
        let originalEmail = Constants.userDefaults.stringForKey("email")!
        let newEmail = emailLabel.text!
        debugPrint("Original : \(originalEmail), New : \(newEmail)")
        
        Alamofire.request(.GET, Constants.changeEmail,
            parameters: [
                "originalEmail": originalEmail,
                "newEmail": newEmail
            ],
            headers: [
                "deviceKey": Constants.deviceKey,
                "deviceType": Constants.deviceType
            ])
            .responseJSON { (response: Response) -> Void in
                debugPrint(response)
                
                switch response.result {
                case .Success:
                    Constants.userDefaults.setObject(newEmail, forKey: "email")
                    self.navigationController!.popViewControllerAnimated(true)

                    break
                case .Failure:
                    
                    let alert = UIAlertController(title: "Alert", message: "Fail to change email address. New address is using now.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    break
                }
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

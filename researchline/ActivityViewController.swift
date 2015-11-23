//
//  ActivityViewController.swift
//  researchline
//
//  Created by Leo Kang on 11/22/15.
//  Copyright © 2015 bbb. All rights reserved.
//

import UIKit
import Alamofire

class ActivityViewController: UIViewController {

    @IBOutlet weak var usernameTextView: UITextField!
    
    @IBOutlet weak var passwordTextView: UITextField!
    
    @IBOutlet weak var loginButtonView: UIButton!
    
    @IBAction func loginButtonClickEvent(sender: AnyObject) {
        
        let email = usernameTextView.text
        let password = passwordTextView.text
        
        Alamofire.request(.POST, Constants.glucoseLogin, headers: [
            "deviceKey": Constants.deviceKey,
            "deviceType": Constants.deviceType,
            "signKey": ""],
            parameters:[
                "email": email!,
                "password": password!
            ]) // TODO: should add new signKey
            .responseJSON { (response: Response) -> Void in
                switch response.result{
                case.Success(let json):
                    if(json["success"] as? Int > 0){
                        let alert = UIAlertController(title: "Alert", message: "Success to glucose login.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        self.navigationController?.popToRootViewControllerAnimated(true)
                        self.navigationController?.popViewControllerAnimated(true)
                    }else{
                        let alert = UIAlertController(title: "Alert", message: "Fail to glucose login.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    debugPrint(json)
                    break
                case.Failure(let error):
                    debugPrint(error)
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

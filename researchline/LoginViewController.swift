//
//  LoginViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = false
    }
    
    // MARK: IBAction Methods
    
    @IBAction func editChangedTextField(sender: UITextField) {
        doneBarButtonItem.enabled = !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty
    }
    
    @IBAction func touchUpInsideDoneBarButtonItem(sender: UIBarButtonItem) {
        sender.enabled = false
        Alamofire.request(.POST, Constants.login,
            parameters: [
                "email": emailTextField.text ?? "",
                "password": passwordTextField.text ?? ""
            ],
            headers: [
                "deviceKey": Constants.deviceKey,
                "deviceType": Constants.deviceType
            ])
            .responseJSON { (response: Response) -> Void in
                debugPrint(response)
                sender.enabled = true
                
                switch response.result {
                case .Success:
                    switch response.response!.statusCode {
                    case 200:
                        // save the sign key
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        userDefaults.setObject(response.result.value!["signKey"]!, forKey: "signKey")
                        
                        // shows tab bar
                        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                        let controller = storyboard.instantiateInitialViewController()!
                        self.presentViewController(controller, animated: true, completion: nil)
                        break
                    default:
                        let alertView = UIAlertView(title: nil, message: response.result.value!["message"] as? String, delegate: nil, cancelButtonTitle: "Okay")
                        alertView.show()
                        break
                    }
                    break
                case .Failure:
                    let alertView = UIAlertView(title: "Server Error", message: nil, delegate: nil, cancelButtonTitle: "Okay")
                    alertView.show()
                    break
                }
        }
    }
}
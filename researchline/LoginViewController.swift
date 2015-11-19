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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = false
    }
    
    @IBAction func touchUpInsideDoneBarButtonItem(sender: UIBarButtonItem) {
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
                switch response.response!.statusCode {
                case 200:
                    // signKey를 저장한다.
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setObject(response.result.value!["signKey"]!, forKey: "signKey")
                    
                    // 탭바를 실행한다.
                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                    let controller = storyboard.instantiateInitialViewController()!
                    self.presentViewController(controller, animated: true, completion: nil)
                    break
                default:
                    debugPrint(response)
                    let alertView = UIAlertView(title: nil, message: response.result.value!["message"] as? String, delegate: nil, cancelButtonTitle: "Okay")
                    alertView.show()
                    break
                }
        }
    }
}
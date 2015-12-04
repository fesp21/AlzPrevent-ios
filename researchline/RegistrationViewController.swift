//
//  RegistrationViewController.swift
//  researchline
//
//  Created by Leo Kang on 11/20/15.
//  Copyright © 2015 bbb. All rights reserved.
//

import UIKit
import Alamofire

class RegistrationViewController: UIViewController {
    
    var signFileData: UIImage?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var realNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var joinBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var sexSegmentedControl: UISegmentedControl!

    @IBAction func editChangedTextField(sender: UITextField) {
        if(!emailTextField.text!.isEmpty && !realNameTextField.text!.isEmpty && !passwordTextField.text!.isEmpty){
            joinBarButtonItem.enabled = true
            
            let data = self.signFileData!
            Constants.signFileData = data
            
            let sex = sexSegmentedControl.selectedSegmentIndex == 0 ? "male" : "female"
            Constants.userDefaults.setObject(sex, forKey: "sex")
            let email = self.emailTextField.text ?? ""
            Constants.userDefaults.setObject(email, forKey: "email")
            let realName = self.realNameTextField.text ?? ""
            Constants.userDefaults.setObject(realName, forKey: "realName")
            let password = self.passwordTextField.text ?? ""
            Constants.userDefaults.setObject(password, forKey: "password")
            
        }

    }
    
    
    
    @IBAction func touchUpInsideNextBarButtonItem(sender: UIBarButtonItem) {
        
        let email = Constants.userDefaults.stringForKey("email")!
        let realName = Constants.userDefaults.stringForKey("realName")!
        let password = Constants.userDefaults.stringForKey("password")!
        let sex = Constants.userDefaults.stringForKey("sex")!
        let data = UIImagePNGRepresentation(Constants.signFileData!)!
        
        
        Alamofire.upload(.POST, Constants.register, multipartFormData: { (formData: MultipartFormData) -> Void in
            formData.appendBodyPart(data: data, name: "file", fileName: "file.jpg", mimeType: "image/png")
            formData.appendBodyPart(data: email.dataUsingEncoding(NSUTF8StringEncoding)!, name: "email")
            formData.appendBodyPart(data: realName.dataUsingEncoding(NSUTF8StringEncoding)!, name: "realName")
            formData.appendBodyPart(data: password.dataUsingEncoding(NSUTF8StringEncoding)!, name: "password")
            formData.appendBodyPart(data: Constants.deviceKey.dataUsingEncoding(NSUTF8StringEncoding)!, name: "deviceKey")
            formData.appendBodyPart(data: Constants.deviceType.dataUsingEncoding(NSUTF8StringEncoding)!, name: "deviceType")
            formData.appendBodyPart(data: (Constants.firstName() ?? "").dataUsingEncoding(NSUTF8StringEncoding)!, name: "firstName")
            formData.appendBodyPart(data: (Constants.lastName() ?? "").dataUsingEncoding(NSUTF8StringEncoding)!, name: "lastName")
            formData.appendBodyPart(data: sex.dataUsingEncoding(NSUTF8StringEncoding)!, name: "sex")
            formData.appendBodyPart(data: (Constants.studyName).dataUsingEncoding(NSUTF8StringEncoding)!, name: "studyName")
            }, encodingCompletion: { (result: Manager.MultipartFormDataEncodingResult) -> Void in
                switch result {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        if let _response = response.response {
                            if _response.statusCode < 300 {
                                let userDefaults = NSUserDefaults.standardUserDefaults()
                                let signKey = response.result.value!["data"]!!["signKey"]
                                if signKey != nil {
                                    userDefaults.setObject(response.result.value!["data"]!!["signKey"], forKey: "signKey")
                                    
                                    Constants.userDefaults.setObject(Constants.STEP_REGISTER, forKey: "registerStep")
                                    
                                    let storyboard = UIStoryboard(name: "Session", bundle: nil)
                                    let controller = storyboard.instantiateViewControllerWithIdentifier("AdditionInfoViewController")
                                    self.navigationController?.pushViewController(controller, animated: true)
                                    
                                } else {
                                    print("no signKey")
                                }
                            }else if(_response.statusCode == 406){
                                let alert = UIAlertController(title: "Alert", message: "Fail to join. Please check the email address that used.", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
                            }else{
                                let alert = UIAlertController(title: "Alert", message: "Error was happen when sending registration request.", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                        }
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                } // result
        }) // upload
        
    }
}
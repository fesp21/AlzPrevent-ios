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
        joinBarButtonItem.enabled = !emailTextField.text!.isEmpty && !realNameTextField.text!.isEmpty && !passwordTextField.text!.isEmpty
    }
    
    @IBAction func touchUpInsideNextBarButtonItem(sender: UIBarButtonItem) {
        let data = UIImagePNGRepresentation(self.signFileData!)!
        let sex = sexSegmentedControl.selectedSegmentIndex == 0 ? "male" : "female"
        Alamofire.upload(.POST, Constants.register, multipartFormData: { (formData: MultipartFormData) -> Void in
            formData.appendBodyPart(data: data, name: "file", fileName: "file.jpg", mimeType: "image/png")
            formData.appendBodyPart(data: (self.emailTextField.text ?? "").dataUsingEncoding(NSUTF8StringEncoding)!, name: "email")
            formData.appendBodyPart(data: (self.realNameTextField.text ?? "").dataUsingEncoding(NSUTF8StringEncoding)!, name: "realName")
            formData.appendBodyPart(data: (self.passwordTextField.text ?? "").dataUsingEncoding(NSUTF8StringEncoding)!, name: "password")
            formData.appendBodyPart(data: Constants.deviceKey.dataUsingEncoding(NSUTF8StringEncoding)!, name: "deviceKey")
            formData.appendBodyPart(data: Constants.deviceType.dataUsingEncoding(NSUTF8StringEncoding)!, name: "deviceType")
            formData.appendBodyPart(data: (Constants.firstName ?? "").dataUsingEncoding(NSUTF8StringEncoding)!, name: "firstName")
            formData.appendBodyPart(data: (Constants.lastName ?? "").dataUsingEncoding(NSUTF8StringEncoding)!, name: "lastName")
            formData.appendBodyPart(data: sex.dataUsingEncoding(NSUTF8StringEncoding)!, name: "sex")
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
                                    
                                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                                    let controller = storyboard.instantiateInitialViewController()!
                                    self.presentViewController(controller, animated: true, completion: nil)
                                } else {
                                    print("no signKey")
                                }
                            }
                        }
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
        })
    }
}
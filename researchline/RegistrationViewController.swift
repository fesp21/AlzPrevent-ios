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
    
    @IBAction func touchUpInsideNextBarButtonItem(sender: UIBarButtonItem) {
        let data = UIImagePNGRepresentation(self.signFileData!)!
        Alamofire.upload(.POST, Constants.register, multipartFormData: { (formData: MultipartFormData) -> Void in
            formData.appendBodyPart(data: data, name: "file", fileName: "file.jpg", mimeType: "image/png")
            formData.appendBodyPart(data: (self.emailTextField.text ?? "").dataUsingEncoding(NSUTF8StringEncoding)!, name: "email")
            formData.appendBodyPart(data: (self.realNameTextField.text ?? "").dataUsingEncoding(NSUTF8StringEncoding)!, name: "realName")
            formData.appendBodyPart(data: (self.passwordTextField.text ?? "").dataUsingEncoding(NSUTF8StringEncoding)!, name: "password")
            formData.appendBodyPart(data: Constants.deviceKey.dataUsingEncoding(NSUTF8StringEncoding)!, name: "deviceKey")
            formData.appendBodyPart(data: Constants.deviceType.dataUsingEncoding(NSUTF8StringEncoding)!, name: "deviceType")
            formData.appendBodyPart(data: (Constants.firstName ?? "").dataUsingEncoding(NSUTF8StringEncoding)!, name: "firstName")
            formData.appendBodyPart(data: (Constants.lastName ?? "").dataUsingEncoding(NSUTF8StringEncoding)!, name: "lastName")
            formData.appendBodyPart(data: "male".dataUsingEncoding(NSUTF8StringEncoding)!, name: "sex")
            }, encodingCompletion: { (result: Manager.MultipartFormDataEncodingResult) -> Void in
                switch result {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        userDefaults.setObject(response.result.value!["signKey"], forKey: "signKey")
                        
                        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                        let controller = storyboard.instantiateInitialViewController()!
                        self.presentViewController(controller, animated: true, completion: nil)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
        })
    }
}
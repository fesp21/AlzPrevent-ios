//
//  EmailConsentDocumentViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit
import MessageUI
import Alamofire

class EmailConsentDocumentViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var addressForm: UITextField!
    @IBOutlet weak var ccAddressForm: UITextField!
    @IBOutlet weak var subject: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.navigationBarHidden = false
    }
    
    @IBAction func send(sender: AnyObject) {
        Alamofire.request(.GET, Constants.sendConsentEmail,
            parameters: [
                "subject": subject.text ?? "",
                "to": addressForm.text ?? "",
                "cc": ccAddressForm.text ?? ""
            ],
            headers: [
                "deviceKey": Constants.deviceKey,
                "deviceType": Constants.deviceType
            ])
            .responseJSON { (response: Response) -> Void in
                debugPrint(response)
                
                
                switch response.result {
                case .Success:
                    switch response.response!.statusCode {
                    case 200:
                        self.navigationController?.popViewControllerAnimated(true)
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
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
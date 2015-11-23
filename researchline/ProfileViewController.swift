//
//  ProfileViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UITableViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(.GET, Constants.profile,
            headers: [
                "deviceKey": Constants.deviceKey,
                "deviceType": Constants.deviceType,
                "signKey": Constants.signKey!
            ]).responseJSON { (response:Response) -> Void in
                debugPrint(response)
                switch response.result{
                case.Success(let json):
                    Constants.userDefaults.setValue(json["data"]!!["firstName"]!, forKey: "firstName")
                    Constants.userDefaults.setValue(json["data"]!!["lastName"]!, forKey: "lastName")
                    self.usernameLabel.text = Constants.username
                    self.emailLabel.text = Constants.email
                    break
                default:
                    self.usernameLabel.text = Constants.username
                    self.emailLabel.text = Constants.email
                    break
                }
            }
        }
}

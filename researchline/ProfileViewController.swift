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
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(animated: Bool) {
        self.refreshData()
    }
    
    internal func refreshData(){
        var changed = false
        self.usernameLabel.text = Constants.username()
        self.emailLabel.text = Constants.email()
        let sexValue = Constants.userDefaults.stringForKey("sex")
        if(self.sexLabel.text != sexValue){
            changed = true
        }
        self.sexLabel.text = sexValue
        let heightValue = "\(Constants.userDefaults.integerForKey("height")) cm"
        if(self.heightLabel.text != heightValue){
            changed = true
        }
        self.heightLabel.text = heightValue
        let weightValue = "\(Constants.userDefaults.integerForKey("weight")) kg"
        if(self.weightLabel.text != weightValue){
            changed = true
        }
        self.weightLabel.text = weightValue
        let birthValue = Constants.userDefaults.stringForKey("birth")
        if(self.birthLabel.text != birthValue){
            changed = true
        }
        self.birthLabel.text = birthValue
        
        if(changed){
            Alamofire.request(.POST, Constants.profile,
                headers: [
                    "deviceKey": Constants.deviceKey,
                    "deviceType": Constants.deviceType,
                    "signKey": Constants.signKey()
                ], parameters:[
                    "firstName": Constants.userDefaults.stringForKey("firstName")!,
                    "lastName": Constants.userDefaults.stringForKey("lastName")!,
                    "height": Constants.userDefaults.stringForKey("height")!,
                    "weight": Constants.userDefaults.stringForKey("weight")!,
                    "sex": Constants.userDefaults.stringForKey("sex")!,
                    "birth": Constants.userDefaults.stringForKey("birth")!
                ]).responseJSON { (response:Response) -> Void in
                    debugPrint(response)
                    switch response.result{
                    case.Success(let json):
                        if(json["success"] as? Int == 0){
                            break
                        }else{
                            debugPrint("Success for profile update")
                        }
                        break
                    default:
                        break
                    }
            }
        }
    }
}

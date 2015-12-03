//
//  AllSetViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit
import Alamofire

class AllSetViewController: UIViewController {

  @IBAction func touchUpInsideLetsBeginButton(sender: UIButton) {
    
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
                    
                    Constants.userDefaults.setObject(Constants.STEP_FINISHED, forKey: "registerStep")
                    
                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                    let controller = storyboard.instantiateInitialViewController()
                    self.presentViewController(controller!, animated: true, completion: nil)
                }
                break
            default:
                break
            }
    }
    
    
    } // touchUpInsideLetsBeginButton
} // AllSetViewController
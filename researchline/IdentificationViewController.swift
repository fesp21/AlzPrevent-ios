//
//  EnterPasswordViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit

class IdentificationViewController: UIViewController {

    
    var passcode = ""
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    @IBAction func passwordChange(sender: AnyObject) {
        let sizeOfCode = password.text!.characters.count

        let passwordText: String = password.text!
        let toNumber = Int(passwordText)
        if(passwordText == ""){
            return
        }else if((toNumber == nil)){
            password.text = self.passcode
        }
        
        if(sizeOfCode > 4){
            password.text = self.passcode
        }else{
            self.passcode = password.text!
        }
        
        if(sizeOfCode == 4){
            nextButton.enabled = true
            Constants.userDefaults.setObject(self.passcode, forKey: "passcode")
        }else{
            nextButton.enabled = false
            Constants.userDefaults.removeObjectForKey("passcode")
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

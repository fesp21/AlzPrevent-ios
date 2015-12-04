//
//  PasscodeViewController.swift
//  researchline
//
//  Created by jknam on 2015. 12. 1..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit

class PasscodeViewController: UIViewController {

    
    @IBOutlet weak var passcodeText: UITextField!
    
    @IBOutlet weak var alertText: UITextView!

    @IBOutlet weak var startButton: UIButton!
    
    var answer: String? = nil;
    var passcode = "";
    
    @IBAction func clickStartButton(sender: AnyObject) {
        if(answer == nil){
            Constants.userDefaults.setObject(passcodeText.text!, forKey: "passcode")
        }
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("RootTabBarController")
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func passcodeChanged(sender: AnyObject) {
        var sizeOfCode = passcodeText.text!.characters.count
        
        let passwordText: String = passcodeText.text!
        let toNumber = Int(passwordText)
        if(passwordText == ""){
            return
        }else if((toNumber == nil)){
            passcodeText.text = self.passcode
        }
        
        if(sizeOfCode > 4){
            passcodeText.text = self.passcode
            sizeOfCode = 4
        }else{
            self.passcode = passcodeText.text!
        }
        
        if(sizeOfCode == 4){
            if(answer == nil){
                startButton.enabled = true
                alertText.hidden = true
            }else if(answer == self.passcode){
                startButton.enabled = true
                alertText.hidden = true
            }else{
                startButton.enabled = false
                alertText.hidden = false
            }
        }else{
            startButton.enabled = false
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertText.hidden = true
        startButton.enabled = false
        
        answer = Constants.userDefaults.stringForKey("passcode")
        if(answer == nil){
            startButton.setTitle("Setup", forState: UIControlState.Normal)
        }
        
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

//
//  GlucoseSuccessViewController.swift
//  researchline
//
//  Created by jknam on 2015. 11. 30..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit

class GlucoseSuccessViewController: UIViewController {

    var success = false
    var score: String = ""
    
    @IBOutlet weak var failureLabel: UILabel!
    @IBOutlet weak var successLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(success){
            failureLabel.hidden = true
            successLabel.hidden = false
            successLabel.text = "Glucose level : \(score)"
            
            HealthManager.requestSavingGlucoseSample(Double(score)!, date: NSDate())
        }else{
            failureLabel.hidden = false
            successLabel.hidden = true
            
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

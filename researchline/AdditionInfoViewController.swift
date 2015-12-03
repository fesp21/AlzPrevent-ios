//
//  AdditionInfoViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit
import Alamofire

class AdditionInfoViewController: UIViewController {

    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    
    var ok = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.backBarButtonItem?.enabled = false
        self.navigationItem.hidesBackButton = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let height = Constants.userDefaults.integerForKey("height")
        let weight = Constants.userDefaults.integerForKey("weight")
        let birth = Constants.userDefaults.stringForKey("birth")
        debugPrint(height, weight)
        if(height > 0 && weight > 0 && birth != nil){
            nextButton.enabled = true
        }
        
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

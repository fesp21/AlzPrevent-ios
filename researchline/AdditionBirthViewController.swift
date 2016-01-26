//
//  AdditionBirthViewController.swift
//
//  Created by jknam on 2015. 11. 30..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit

class AdditionBirthViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let formatter = NSDateFormatter()
    
    @IBAction func valueChanged(sender: AnyObject) {
        let dateString = self.formatter.stringFromDate(datePicker.date)
        Constants.userDefaults.setObject(dateString, forKey: "birth")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "MM/dd/yyyy"
        
        let userDateString = Constants.userDefaults.stringForKey("birth")
        
        
        let userDate = formatter.dateFromString(userDateString!)
        
        datePicker.setDate(userDate!, animated: false)
        
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

//
//  EligibilitySurbeyViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit

class EligibilitySurveyViewController: UITableViewController {
    
    @IBOutlet weak var surveyOneYesButton: UIButton!
    @IBOutlet weak var surveyOneNoButton: UIButton!
    
    @IBOutlet weak var surveyTwoYesButton: UIButton!
    @IBOutlet weak var surveyTwoNoButton: UIButton!
    
    @IBOutlet weak var surveyThreeYesButton: UIButton!
    @IBOutlet weak var surveyThreeNoButton: UIButton!
    
    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
    
    var canMoveToNext = false
    var isAvailabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as! EligibilityResultViewController
        controller.isAvailabled = isAvailabled
    }
    
    // MARK: IBAction Methods
    
    @IBAction func touchUpInsideServeyButton(sender: UIButton) {
        if sender.tag == 10 || sender.tag == 11 {
            surveyOneYesButton.selected = false
            surveyOneNoButton.selected = false
        }
        
        if sender.tag == 20 || sender.tag == 21 {
            surveyTwoYesButton.selected = false
            surveyTwoNoButton.selected = false
        }
        
        if sender.tag == 30 || sender.tag == 31 {
            surveyThreeYesButton.selected = false
            surveyThreeNoButton.selected = false
        }
        
        sender.selected = !sender.selected
        nextBarButtonItem.enabled = true
        isAvailabled = surveyOneYesButton.selected && !surveyTwoYesButton.selected && surveyThreeYesButton.selected
    }
}
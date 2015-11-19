//
//  ActivitiesViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit

class ActivitiesViewController: UITableViewController {

    @IBAction func touchUpInsideMemoryButton(sender: UIButton) {
        let storybard = UIStoryboard(name: "MemoryActivity", bundle: nil)
        let controller = storybard.instantiateInitialViewController()!
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func touchUpInsideItemSpanBackwardButton(sender: UIButton) {
        let storybard = UIStoryboard(name: "ItemSpanBackwardActivity", bundle: nil)
        let controller = storybard.instantiateInitialViewController()!
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func touchUpInsideVisualActivityButton(sender: UIButton) {
        let storybard = UIStoryboard(name: "VisualActivity", bundle: nil)
        let controller = storybard.instantiateInitialViewController()!
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func touchUpInsideFastCountingButton(sender: UIButton) {
        let storybard = UIStoryboard(name: "FastCountingActivity", bundle: nil)
        let controller = storybard.instantiateInitialViewController()!
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func touchUpInsideColorReadingButton(sender: UIButton) {
        let storybard = UIStoryboard(name: "ColorReadingActivity", bundle: nil)
        let controller = storybard.instantiateInitialViewController()!
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func touchUpInsideItemSpanForwardButton(sender: UIButton) {
        let storybard = UIStoryboard(name: "ItemSpanForwardActivity", bundle: nil)
        let controller = storybard.instantiateInitialViewController()!
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
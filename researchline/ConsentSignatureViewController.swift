//
//  ConsentSignatureViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit

class ConsentSignatureViewController: UIViewController {

    @IBOutlet weak var drawImageView: DrawImageView!
    
    @IBAction func touchUpInsideClearSignatureButton(sender: UIButton) {
        drawImageView.signed = false
        drawImageView.image = UIImage()
    }
    
    @IBAction func touchUpInsideDoneButton(sender: UIButton) {
        if drawImageView.signed {
            let storyboard = UIStoryboard(name: "Consent", bundle: nil)
            let controller = storyboard.instantiateViewControllerWithIdentifier("WhatToExpectViewController") as! WhatToExpectViewController
            controller.signFileData = drawImageView.image
            
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let alertView = UIAlertView(title: "Sign please!", message: nil, delegate: nil, cancelButtonTitle: "Okay")
            alertView.show()
        }
    }
}
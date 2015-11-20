//
//  ItemSpanBackwardViewController.swift
//  researchline
//
//  Created by Leo Kang on 11/20/15.
//  Copyright © 2015 bbb. All rights reserved.
//

import UIKit

class ItemSpanBackwardActivityViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var correctTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var failureLabel: UILabel!
    
    var timer: NSTimer?
    var repeatCount = 0
    var successCount = 0
    var failureCount = 0
    var correct = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "suffle", userInfo: nil, repeats: false)
    }
    
    // MARK: Behavior Methods
    
    internal func suffle() {
        if repeatCount < 3 {
            numberLabel.hidden = false
            enterButton.hidden = true
            correctTextField.hidden = true
            let number = String(Int(arc4random_uniform(UInt32(8))) + 1)
            correct += number
            numberLabel.text = number
            debugPrint(correct)
            
            repeatCount++
            timer?.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "suffle", userInfo: nil, repeats: false)
        } else {
            showsCorrectTextField()
        }
    }
    
    internal func reset() {
        repeatCount = 0
        correct = ""
        correctTextField.text = ""
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "suffle", userInfo: nil, repeats: false)
    }
    
    @IBAction func touchUpInsideEnterButton(sender: UIButton) {
        if correctTextField.text == correct {
            successCount++
        } else {
            failureCount++
        }
        
        print(successCount, failureCount)
        successLabel.text = "Success: \(successCount)"
        failureLabel.text = "Failure: \(failureCount)"
        
        reset()
    }
    
    internal func showsCorrectTextField() {
        timer?.invalidate()
        repeatCount = 0
        numberLabel.hidden = true
        enterButton.hidden = false
        correctTextField.hidden = false
        correctTextField.becomeFirstResponder()
    }

}

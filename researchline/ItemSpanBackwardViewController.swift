//
//  ItemSpanBackwardViewController.swift
//  researchline
//
//  Created by Leo Kang on 11/20/15.
//  Copyright © 2015 bbb. All rights reserved.
//

import UIKit
import Alamofire

class ItemSpanBackwardActivityViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var correctTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var failureLabel: UILabel!
    
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var startButton: UIButton!
    @IBAction func clickStartButton(sender: AnyObject) {
        numberLabel.hidden = false
        enterButton.hidden = false
        startButton.hidden = true
        descriptionText.hidden = true
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "suffle", userInfo: nil, repeats: false)
        startFlag = true
    }
    
    var timer: NSTimer?
    var repeatCount = 0
    var successCount = 0
    var failureCount = 0
    var correct = ""
    var trial = 0
    
    var resultTimeMap = [Int: NSTimeInterval]()
    var resultTrials = [Bool]()
    let taskName = "Item Span Backward"
    var activityId: String? = nil
    var start: NSDate? = nil
    var startFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberLabel.hidden = true
        enterButton.hidden = true
        
        let activityKey = "id_\(self.taskName)"
        debugPrint(activityKey)
        self.activityId = Constants.userDefaults.stringForKey(activityKey)
        debugPrint(activityId)
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
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "suffle", userInfo: nil, repeats: false)
        } else {
            showsCorrectTextField()
        }
    }
    
    internal func reset() {
        if(trial > 4){
            finish()
            return
        }
        repeatCount = 0
        correct = ""
        correctTextField.text = ""
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "suffle", userInfo: nil, repeats: false)
    }
    
    @IBAction func touchUpInsideEnterButton(sender: UIButton) {
        var reverse = ""
        for character in correct.characters {
            let asString = "\(character)"
            reverse = asString + reverse
        }
        correct = reverse
        
        if correctTextField.text == correct {
            successCount++
            resultTrials.append(true)
        } else {
            failureCount++
            resultTrials.append(false)
        }
        
        print(successCount, failureCount)
        successLabel.text = "Success: \(successCount)"
        failureLabel.text = "Failure: \(failureCount)"
        
        let interval = NSDate().timeIntervalSinceDate(start!)
        resultTimeMap[trial] = interval
        
        trial += 1
        debugPrint("\(trial)th trial result is success while \(interval)")
        
        reset()
    }
    
    internal func showsCorrectTextField() {
        timer?.invalidate()
        start = NSDate()
        repeatCount = 0
        numberLabel.hidden = true
        enterButton.hidden = false
        correctTextField.hidden = false
        correctTextField.becomeFirstResponder()
    }
    
    internal func finish(){
        descriptionText.text = "Test is finished. Your success score is \(successCount)."
        descriptionText.hidden = false
        numberLabel.hidden = true
        enterButton.hidden = true
        correctTextField.hidden = true
        startFlag = false
        
        var jsonResult = ""
        for i in 0...(resultTimeMap.count-1) {
            let timestamp = resultTimeMap[i]
            let correct: String = String.init(resultTrials[i])
            
            let trialJson = "{\"name\":\"\(taskName)\",\"timestamp\":\"\(timestamp!)\",\"correct\":\"\(correct)\",\"trial\":\"\(i)\"}";
            if(i == 0){
                jsonResult = "[\(trialJson)"
            }else{
                jsonResult = "\(jsonResult),\(trialJson)"
            }
        }
        jsonResult += "]"
        debugPrint(jsonResult)
        
        Alamofire.request(.POST, Constants.activity, headers: [
            "deviceKey": Constants.deviceKey,
            "deviceType": Constants.deviceType,
            "signKey": Constants.signKey!], parameters: [
                "value": jsonResult,
                "activityId": activityId!
            ])
            .responseJSON { (response: Response) -> Void in
                switch response.result{
                case.Success(let json):
                    debugPrint(json)
                    if(json["success"] as? Int == 0){
                        break
                    }
                    break
                default:
                    break
                }
                
        }
    }

}

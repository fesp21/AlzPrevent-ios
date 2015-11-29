//
//  ColorReadingViewController.swift
//  researchline
//
//  Created by Leo Kang on 11/20/15.
//  Copyright © 2015 bbb. All rights reserved.
//

import UIKit
import Alamofire

class ColorReadingActivityViewController: UIViewController {
    
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var orangeView: UIView!
    @IBOutlet weak var yellowView: UIView!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var purpleView: UIView!
    @IBOutlet weak var renderedWord: UITextField!
    @IBOutlet weak var resultView: UIImageView!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var failureLabel: UILabel!
    
    
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var startButton: UIButton!
    
    var resultCorrectMap = [Int: Int]()
    var resultTimeMap = [Int: NSTimeInterval]()
    var resultTrials = [Bool]()
    var resultFailImage: UIImage = UIImage(named: "X")!
    var resultSuccessImage: UIImage = UIImage(named: "O")!

    var taskName = "Color Reading"
    var activityId: String? = ""
    
    @IBAction func clickStartButton(sender: AnyObject) {
        suffleTimer = NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: "suffle", userInfo: nil, repeats: false)
        descriptionText.hidden = true
        startButton.hidden = true
        startFlag = true
    }
    
    
    @IBAction func clickBlue(sender: AnyObject) {
        processClick(0)
    }
    
    @IBAction func clickGreen(sender: AnyObject) {
        processClick(1)
    }
    
    @IBAction func clickOrange(sender: AnyObject) {
        processClick(2)
    }

    @IBAction func clickPurple(sender: AnyObject) {
        processClick(3)
    }
    
    @IBAction func clickRed(sender: AnyObject) {
        processClick(4)
    }
    
    @IBAction func clickYellow(sender: AnyObject) {
        processClick(5)
    }
    
    internal func processClick(number: Int){
        if(answerFlag || !startFlag){
            return
        }
        answerFlag = true
        resultView.hidden = false
        let interval = NSDate().timeIntervalSinceDate(start!)
        resultTimeMap[trial] = interval
        var result = ""
        if(answer == number){
            resultView.image = resultSuccessImage
            resultCorrectMap[1]? += 1
            successLabel.text = "Success: \(resultCorrectMap[1]!)"
            result = "correct"
            resultTrials.append(true)
        }else{
            resultView.image = resultFailImage
            resultCorrectMap[0]? += 1
            failureLabel.text = "Failure: \(resultCorrectMap[0]!)"
            result = "fail"
            resultTrials.append(false)
        }
        
        trial += 1
        
        debugPrint("\(trial)th trial result is \(result) while \(interval)")
        suffleTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target:self, selector: "suffle", userInfo: nil, repeats: false)
    }
    


    var suffleTimer: NSTimer? = nil
    var resultHideTimer: NSTimer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let activityKey = "id_\(self.taskName)"
        debugPrint(activityKey)
        self.activityId = Constants.userDefaults.stringForKey(activityKey)
        debugPrint(activityId)
        
        renderedWord.hidden = true
        resultView.hidden = true
        successLabel.hidden = true
        failureLabel.hidden = true
        
        resultCorrectMap[0] = 0
        resultCorrectMap[1] = 0
        
        redView.layer.cornerRadius = 5
        redView.layer.borderWidth = 1
        redView.layer.borderColor = UIColor.blackColor().CGColor
        orangeView.layer.cornerRadius = 5
        orangeView.layer.borderWidth = 1
        orangeView.layer.borderColor = UIColor.blackColor().CGColor
        yellowView.layer.cornerRadius = 5
        yellowView.layer.borderWidth = 1
        yellowView.layer.borderColor = UIColor.blackColor().CGColor
        greenView.layer.cornerRadius = 5
        greenView.layer.borderWidth = 1
        greenView.layer.borderColor = UIColor.blackColor().CGColor
        blueView.layer.cornerRadius = 5
        blueView.layer.borderWidth = 1
        blueView.layer.borderColor = UIColor.blackColor().CGColor
        purpleView.layer.cornerRadius = 5
        purpleView.layer.borderWidth = 1
        purpleView.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    
    var answerFlag = false
    var startFlag = false
    var value = 0
    var answer = 0
    var color = 0
    var trial = 0
    var start: NSDate? = nil
    internal func suffle(){
        suffleTimer?.invalidate()
        
        if(trial >= 5){
            finish()
            return
        }
        
        renderedWord.hidden = false
        resultView.hidden = true
        answerFlag = false
        value = Int.init(arc4random_uniform(UInt32(36)))
        color = value / 6
        answer = value % 6
        if(color == 0){
            renderedWord.text = "Blue"
        }else if(color == 1){
            renderedWord.text = "Green"
        }else if(color == 2){
            renderedWord.text = "Orange"
        }else if(color == 3){
            renderedWord.text = "Purple"
        }else if(color == 4){
            renderedWord.text = "Red"
        }else if(color == 5){
            renderedWord.text = "Yellow"
        }
        
        if(answer == 0){
            renderedWord.textColor = UIColor.blueColor();
        }else if(answer == 1){
            renderedWord.textColor = UIColor.greenColor();
        }else if(answer == 2){
            renderedWord.textColor = UIColor.orangeColor();
        }else if(answer == 3){
            renderedWord.textColor = UIColor.purpleColor();
        }else if(answer == 4){
            renderedWord.textColor = UIColor.redColor();
        }else if(answer == 5){
            renderedWord.textColor = UIColor.yellowColor();
        }
        start = NSDate()
    }
    
    internal func hideResult(){
        resultView.hidden = true
    }
    
    internal func finish(){
        descriptionText.text = "Test is finished. Your success score is \(resultCorrectMap[1]!)."
        descriptionText.hidden = false
        renderedWord.hidden = true
        resultView.hidden = true
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
            "signKey": Constants.signKey()], parameters: [
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

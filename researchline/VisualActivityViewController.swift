//
//  VisualActivityViewController.swift
//  researchline
//
//  Created by Leo Kang on 11/20/15.
//  Copyright © 2015 bbb. All rights reserved.
//

import UIKit
import Alamofire

class VisualActivityViewController: UIViewController {

    @IBOutlet weak var reactionImageView: UIButton!
    @IBOutlet weak var failTextView: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var failureLabel: UILabel!
    
    @IBAction func clickStartButton(sender: AnyObject) {
        reactionImageView.hidden = false
        descriptionText.hidden = true
        startButton.hidden = true
        finishReaction()
        startFlag = true
    }
    
    var reactionImage: UIImage = UIImage(named: "reaction")!
    var reactionImageReady: UIImage = UIImage(named: "reaction_ready")!
    var reactionTimer: NSTimer? = nil
    var finishReactionTimer: NSTimer? = nil
    
    var resultTimeMap = [Int: NSTimeInterval]()
    var resultTrials = [Bool]()
    let taskName = "Visual Activity"
    var activityId: String? = nil
    var start: NSDate? = nil
    var startFlag = false
    
    var isStart = 0 // 0 is ready, 1 is testing, 2 is fail
    var trial = 0
    var startDate: NSDate? = nil
    var successCount = 0
    var failureCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activityKey = "id_\(self.taskName)"
        debugPrint(activityKey)
        self.activityId = Constants.userDefaults.stringForKey(activityKey)
        debugPrint(activityId)
        
        failTextView.hidden = true
        failTextView.borderStyle = UITextBorderStyle.None
    }
    
    internal func startReaction(){
        reactionTimer?.invalidate()
        startDate = NSDate()
        reactionImageView.setImage(reactionImage, forState: .Normal)
        isStart = 1
        startFlag = true
    }
    
    internal func finishReaction(){
        finishReactionTimer?.invalidate()
        isStart = 0
        failTextView.hidden = true
        reactionImageView.hidden = false
        reactionImageView.setImage(reactionImageReady, forState: .Normal)
        
        let random = Float.init(arc4random_uniform(UInt32(500)))
        
        let randomSecond = 1.0 + (random / 500)
        
        // next reaction
        if(trial < 5){
            reactionTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(randomSecond), target:self, selector: "startReaction", userInfo: nil, repeats: false)
        }else{
            startFlag = false
            finish()
        }
        
        successLabel.text = "Success: \(successCount)"
        failureLabel.text = "Failure: \(failureCount)"
    }
    
    @IBAction func click(sender: AnyObject) {
        if(!startFlag){
            return
        }
        if(isStart == 1){
            isStart = 2
            let interval = NSDate().timeIntervalSinceDate(startDate!)
            resultTimeMap[trial] = interval
            
            trial += 1
            debugPrint("\(trial)th trial result is success while \(interval)")
            resultTrials.append(true)
            successCount += 1
            finishReaction()
        }else if(isStart == 0){
            isStart = 2
            reactionImageView.hidden = true
            failTextView.hidden = false
            resultTimeMap[trial] = 0
            
            debugPrint("\(trial)th trial result is fail")
            resultTrials.append(false)
            failureCount += 1
            finishReactionTimer = NSTimer.scheduledTimerWithTimeInterval(3, target:self, selector: "finishReaction", userInfo: nil, repeats: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func finish(){
        descriptionText.text = "Test is finished. Your success score is \(successCount)."
        descriptionText.hidden = false
        reactionImageView.hidden = true
        failTextView.hidden = true
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

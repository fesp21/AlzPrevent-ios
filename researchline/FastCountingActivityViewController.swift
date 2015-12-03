//
//  FastCountingViewController.swift
//  researchline
//
//  Created by Leo Kang on 11/20/15.
//  Copyright © 2015 bbb. All rights reserved.
//

import UIKit
import Alamofire

class FastCountingActivityViewController: UIViewController {
    
    var usedTops: [UInt32] = []
    var usedLeadings: [UInt32] = []
    
    @IBOutlet weak var point1View: UIView!
    @IBOutlet weak var point2View: UIView!
    @IBOutlet weak var point3View: UIView!
    @IBOutlet weak var point4View: UIView!
    @IBOutlet weak var point5View: UIView!
    @IBOutlet weak var point6View: UIView!
    @IBOutlet weak var point7View: UIView!
    
    @IBOutlet weak var point1ViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var point1ViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var point2ViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var point2ViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var point3ViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var point3ViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var point4ViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var point4ViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var point5ViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var point5ViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var point6ViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var point6ViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var point7ViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var point7ViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var failureLabel: UILabel!
    
    var timer1: NSTimer?
    var timer2: NSTimer?
    var pointCount: Int?
    var successCount = 0;
    var failureCount = 0;
    var trial = 0
    let totalTrial = 5
    var startFlag = false
    
    var resultTimeMap = [Int: NSTimeInterval]()
    var resultTrials = [Bool]()
    let taskName = "Fast Counting"
    var activityId: String? = nil
    var start: NSDate? = nil
    
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func clickStartButton(sender: AnyObject) {
        
        startButton.hidden = true
        descriptionText.hidden = true
        containerView.hidden = false
        successLabel.hidden = false
        failureLabel.hidden = false
        
        startFlag = true
        
        timer2?.invalidate()
        timer1 = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "suffle", userInfo: nil, repeats: false)
    }
    
    internal func finish(){
        descriptionText.text = "Test is finished. Your success score is \(successCount)."
        descriptionText.hidden = false
//        renderedWord.hidden = true
//        resultView.hidden = true
        containerView.hidden = true
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let activityKey = "id_\(self.taskName)"
        debugPrint(activityKey)
        self.activityId = Constants.userDefaults.stringForKey(activityKey)
        debugPrint(activityId)
        
        successLabel.hidden = true
        failureLabel.hidden = true
        containerView.hidden = true
        
        point1View.hidden = true
        point2View.hidden = true
        point3View.hidden = true
        point4View.hidden = true
        point5View.hidden = true
        point6View.hidden = true
        point7View.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        timer1?.invalidate()
        timer2?.invalidate()
    }
    
    var touchUpFlag = false
    @IBAction func touchUpInsideNumberButton(sender: UIButton) {
        timer2?.invalidate()
        
        if !startFlag {
            return
        }
        if touchUpFlag {
            return
        }
        
        self.touchUpFlag = true
    
        var result = ""
        if sender.tag == pointCount {
            successCount++
            result = "correct"
            resultTrials.append(true)
        } else {
            failureCount++
            result = "fail"
            resultTrials.append(false)
        }
        
        successLabel.text = "Success: \(successCount)"
        failureLabel.text = "Failure: \(failureCount)"
        
        let interval = NSDate().timeIntervalSinceDate(start!)
        resultTimeMap[trial] = interval
        
        debugPrint("\(trial)th trial result is \(result) while \(interval)")
        
        trial += 1
        
        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "suffle", userInfo: nil, repeats: false)
    }

    // MARK: Behavior Methods
    
    internal func suffle() {
        if trial >= totalTrial {
            finish()
            return
        }
        touchUpFlag = false
        descriptionText.hidden = true
        usedTops.removeAll()
        usedLeadings.removeAll()
        pointCount = Int.init(arc4random_uniform(4)) + 4
        
        point1View.hidden = true
        point2View.hidden = true
        point3View.hidden = true
        point4View.hidden = true
        point5View.hidden = true
        point6View.hidden = true
        point7View.hidden = true
        
        if(pointCount > 3){
            point1ViewTopConstraint.constant = getRandomTop()
            point1ViewLeadingConstraint.constant = getRandomLeading()
            point1View.hidden = false
            point1View.layer.cornerRadius = point1View.frame.size.width/2
            point1View.clipsToBounds = true
            
            point2ViewTopConstraint.constant = getRandomTop()
            point2ViewLeadingConstraint.constant = getRandomLeading()
            point2View.hidden = false
            point2View.layer.cornerRadius = point2View.frame.size.width/2
            point2View.clipsToBounds = true
            
            point3ViewTopConstraint.constant = getRandomTop()
            point3ViewLeadingConstraint.constant = getRandomLeading()
            point3View.hidden = false
            point3View.layer.cornerRadius = point3View.frame.size.width/2
            point3View.clipsToBounds = true
            
            point4ViewTopConstraint.constant = getRandomTop()
            point4ViewLeadingConstraint.constant = getRandomLeading()
            point4View.hidden = false
            point4View.layer.cornerRadius = point4View.frame.size.width/2
            point4View.clipsToBounds = true
        }
        if(pointCount > 4){
            point5ViewTopConstraint.constant = getRandomTop()
            point5ViewLeadingConstraint.constant = getRandomLeading()
            point5View.hidden = false
            point5View.layer.cornerRadius = point5View.frame.size.width/2
            point5View.clipsToBounds = true
        }
        if(pointCount > 5){
            point6ViewTopConstraint.constant = getRandomTop()
            point6ViewLeadingConstraint.constant = getRandomLeading()
            point6View.hidden = false
            point6View.layer.cornerRadius = point6View.frame.size.width/2
            point6View.clipsToBounds = true
        }
        if(pointCount > 6){
            point7ViewTopConstraint.constant = getRandomTop()
            point7ViewLeadingConstraint.constant = getRandomLeading()
            point7View.hidden = false
            point7View.layer.cornerRadius = point7View.frame.size.width/2
            point7View.clipsToBounds = true
        }
        
        
        start = NSDate()
        
        timer1?.invalidate()
        timer2 = NSTimer.scheduledTimerWithTimeInterval(4.5, target: self, selector: "timeout", userInfo: nil, repeats: false)
    }
    
    internal func timeout() {
        timer2?.invalidate()
        descriptionText.text = "This trial was timeout!."
        descriptionText.hidden = false
        
        point1View.hidden = true
        point2View.hidden = true
        point3View.hidden = true
        point4View.hidden = true
        point5View.hidden = true
        point6View.hidden = true
        point7View.hidden = true
        
        var result = ""
    
        failureCount++
        result = "fail"
        resultTrials.append(false)
        
        successLabel.text = "Success: \(successCount)"
        failureLabel.text = "Failure: \(failureCount)"
        
        let interval = NSDate().timeIntervalSinceDate(start!)
        resultTimeMap[trial] = interval
        
        debugPrint("\(trial)th trial result is \(result) while \(interval)")
        
        trial += 1
        
        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "suffle", userInfo: nil, repeats: false)
    }
    
    internal func getRandomTop() -> CGFloat {
        
        var value: CGFloat? = nil
        var intValue: UInt32? = 0
        repeat {
            intValue = arc4random_uniform(UInt32(containerView.bounds.height - 24)) + UInt32(1)
        } while(usedTops.contains(intValue! / 36))
        
        value = CGFloat(intValue!)
        usedTops.append(intValue! / 36)
        
        return value!
    }
    
    internal func getRandomLeading() -> CGFloat {
        
        var value: CGFloat? = nil
        var intValue: UInt32? = 0
        repeat {
            intValue = arc4random_uniform(UInt32(view.bounds.width - 24)) + UInt32(1)
        } while(usedLeadings.contains(intValue! / 36))
        
        value = CGFloat(intValue!)
        usedLeadings.append(intValue! / 36)
        
        return value!
    }
}
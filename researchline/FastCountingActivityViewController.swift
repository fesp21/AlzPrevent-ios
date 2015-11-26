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
    
    var usedTops: [CGFloat] = []
    var usedLeadings: [CGFloat] = []
    
    @IBOutlet weak var point1View: UIView!
    @IBOutlet weak var point2View: UIView!
    @IBOutlet weak var point3View: UIView!
    @IBOutlet weak var point4View: UIView!
    @IBOutlet weak var point5View: UIView!
    @IBOutlet weak var point6View: UIView!
    @IBOutlet weak var point7View: UIView!
    @IBOutlet weak var point8View: UIView!
    
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
    
    @IBOutlet weak var point8ViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var point8ViewLeadingConstraint: NSLayoutConstraint!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let activityKey = "id_\(self.taskName)"
        debugPrint(activityKey)
        self.activityId = Constants.userDefaults.stringForKey(activityKey)
        debugPrint(activityId)
        
        successLabel.hidden = true
        failureLabel.hidden = true
        containerView.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        timer1?.invalidate()
        timer2?.invalidate()
    }
    
    @IBAction func touchUpInsideNumberButton(sender: UIButton) {
        
        if !startFlag {
            return
        }
        
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
    }

    // MARK: Behavior Methods
    
    internal func suffle() {
        if trial >= totalTrial {
            finish()
            return
        }
        
        usedTops.removeAll()
        usedLeadings.removeAll()
        pointCount = 0
        
        point1ViewTopConstraint.constant = getRandomTop()
        point1ViewLeadingConstraint.constant = getRandomLeading()
        let point1ViewVisible = arc4random_uniform(2) == 1
        pointCount! += Int(point1ViewVisible)
        point1View.hidden = point1ViewVisible
        
        point2ViewTopConstraint.constant = getRandomTop()
        point2ViewLeadingConstraint.constant = getRandomLeading()
        let point2ViewVisible = arc4random_uniform(2) == 1
        pointCount! += Int(point2ViewVisible)
        point2View.hidden = point2ViewVisible
        
        point3ViewTopConstraint.constant = getRandomTop()
        point3ViewLeadingConstraint.constant = getRandomLeading()
        let point3ViewVisible = arc4random_uniform(2) == 1
        pointCount! += Int(point3ViewVisible)
        point3View.hidden = point3ViewVisible
        
        point4ViewTopConstraint.constant = getRandomTop()
        point4ViewLeadingConstraint.constant = getRandomLeading()
        let point4ViewVisible = arc4random_uniform(2) == 1
        pointCount! += Int(point4ViewVisible)
        point4View.hidden = point4ViewVisible
        
        point5ViewTopConstraint.constant = getRandomTop()
        point5ViewLeadingConstraint.constant = getRandomLeading()
        let point5ViewVisible = arc4random_uniform(2) == 1
        pointCount! += Int(point5ViewVisible)
        point5View.hidden = point5ViewVisible
        
        point6ViewTopConstraint.constant = getRandomTop()
        point6ViewLeadingConstraint.constant = getRandomLeading()
        let point6ViewVisible = arc4random_uniform(2) == 1
        pointCount! += Int(point6ViewVisible)
        point6View.hidden = point6ViewVisible
        
        point7ViewTopConstraint.constant = getRandomTop()
        point7ViewLeadingConstraint.constant = getRandomLeading()
        let point7ViewVisible = arc4random_uniform(2) == 1
        pointCount! += Int(point7ViewVisible)
        point7View.hidden = point7ViewVisible
        
        point8ViewTopConstraint.constant = getRandomTop()
        point8ViewLeadingConstraint.constant = getRandomLeading()
        let point8ViewVisible = arc4random_uniform(2) == 1
        pointCount! += Int(point8ViewVisible)
        point8View.hidden = point8ViewVisible
        
        start = NSDate()
        
        timer1?.invalidate()
        timer2 = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "showsSelectNumber", userInfo: nil, repeats: false)
    }
    
    internal func showsSelectNumber() {
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "suffle", userInfo: nil, repeats: false)
    }
    
    internal func getRandomTop() -> CGFloat {
        var value = CGFloat(arc4random_uniform(UInt32(containerView.bounds.height - 24)) + UInt32(1))
        while usedTops.contains(value) {
            value = CGFloat(arc4random_uniform(UInt32(containerView.bounds.height - 24)) + UInt32(1))
        }
        
        usedTops.append(value)
        
        return value
    }
    
    internal func getRandomLeading() -> CGFloat {
        var value = CGFloat(arc4random_uniform(UInt32(view.bounds.width - 24)) + UInt32(1))
        while usedLeadings.contains(value) {
            value = CGFloat(arc4random_uniform(UInt32(view.bounds.width - 24)) + UInt32(1))
        }
        
        usedLeadings.append(value)
        
        return value
    }
}
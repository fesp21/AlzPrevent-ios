//
//  MemoryTestViewController.swift
//  researchline
//
//  Created by Leo Kang on 11/20/15.
//  Copyright © 2015 bbb. All rights reserved.
//

import UIKit
import Alamofire

class MemoryActivityViewController: UIViewController {
    
    @IBOutlet weak var resultUIImageView: UIImageView!
    @IBOutlet weak var CheckButton: UIButton!
    
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var failureLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBAction func clickStartButton(sender: AnyObject) {
        suffleTimer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: "suffle", userInfo: nil, repeats: false)
        
        self.startButton.hidden = true
        self.descriptionText.hidden = true
        self.successLabel.hidden = false
        self.failureLabel.hidden = false
    }
    
    var taskName = "Memory"
    
    var renderingImageMap = [Int: UIImage]()
    
    var resultCorrectMap = [Int: Int]()
    var resultTimeMap = [Int: NSTimeInterval]()
    var resultFailImage: UIImage = UIImage(named: "X")!
    var resultSuccessImage: UIImage = UIImage(named: "O")!
    
    var suffleTimer: NSTimer? = nil
    var resultHideTimer: NSTimer? = nil
    var timeoutTimer: NSTimer? = nil
    
    var finished: Int = 0
    
    var answerOrder = [Int]()
    
    var activityId: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let activityKey = "id_\(self.taskName)"
        debugPrint(activityKey)
        self.activityId = Constants.userDefaults.stringForKey(activityKey)
        debugPrint(activityId)
        
        // The images that pre-defined 11 kind
        let baseballImage: UIImage = UIImage(named: "baseball")!
        let bookImage: UIImage = UIImage(named: "book")!
        let cakeImage: UIImage = UIImage(named: "cake")!
        let carImage: UIImage = UIImage(named: "car")!
        let catImage: UIImage = UIImage(named: "cat")!
        let fishImage: UIImage = UIImage(named: "fish")!
        let heartImage: UIImage = UIImage(named: "heart")!
        let pencilImage: UIImage = UIImage(named: "pencil")!
        let shoesImage: UIImage = UIImage(named: "shoes")!
        let spoonImage: UIImage = UIImage(named: "spoon")!
        
        // Add all images to image map for use with index
        renderingImageMap[0] = baseballImage
        renderingImageMap[1] = bookImage
        renderingImageMap[2] = cakeImage
        renderingImageMap[3] = carImage
        renderingImageMap[4] = catImage
        renderingImageMap[5] = fishImage
        renderingImageMap[6] = heartImage
        renderingImageMap[7] = pencilImage
        renderingImageMap[8] = shoesImage
        renderingImageMap[9] = spoonImage
        
        // Success and Failure counting map
        resultCorrectMap[0] = 0
        resultCorrectMap[1] = 0
        
        CheckButton.hidden = true
        resultUIImageView.hidden = true
        successLabel.hidden = true
        failureLabel.hidden = true
        
        generateAnswerOrder()
        
    }
    
    /**
     * When This activity start, all order of images are pre-defined.
     * This function generate order and store that index to answerOrder list object in this class.
     */
    internal func generateAnswerOrder(){
        var answerPosition = [Bool]()
        
        for _ in 0...9{
            answerPosition.append(false)
            answerOrder.append(-1)
        }
        
        var count = 0;
        while true {
            let random = Int.init(arc4random_uniform(UInt32(8))) + 2
            
            if(!answerPosition[random]){
                count += 1
                answerPosition[random] = true
                debugPrint("Answer position is \(random)")
            }
            
            if(count > 2){
                break
            }
        }
        
        for i in 0...9{
            while true{
                let value = Int.init(arc4random_uniform(UInt32(renderingImageMap.count)))
                if(i > 1){
                    if(answerPosition[i]){
                        if(value == answerOrder[i-2]){
                            // is answer
                            self.answerOrder[i] = value
                            debugPrint("\(i)'s picture is \(value)")
                            break
                        }else{
                            // is not answer
                            continue
                        }
                    }else{
                        if(value != answerOrder[i-2]){
                            // is answer
                            self.answerOrder[i] = value
                            debugPrint("\(i)'s picture is \(value)")
                            break
                        }else{
                            // is not answer
                            continue
                        }
                    }
                }else{
                    answerOrder[i] = value
                    debugPrint("\(i)'s picture is \(value)")
                    break
                }
            }
        }
        debugPrint(answerOrder)
    }
    

    let totalCount = 10
    var isImage = 1;
    var value = 0;
    var trial = 0;
    var clicked = 0;
    var start: NSDate? = nil
    // Location is the order of image on each states.
    // Every suffle time, location is increase by 1.
    var location = 0;
    
    internal func suffle(){
        if finished > 0{
            return
        }
        // Checking finish status only if all of order was finished or all answers was found.
        let sumOfResults = resultCorrectMap[0]! + resultCorrectMap[1]!
        if(location >= totalCount || sumOfResults >= 3){
            self.finish()
            return
        }
        suffleTimer?.invalidate()
        
        clicked = 0
        resultUIImageView.hidden = true
        CheckButton.hidden = false
        value = answerOrder[location]
        CheckButton.setImage(renderingImageMap[value], forState: .Normal)
        
        if(location > 1){
            debugPrint("Answer is \(answerOrder[location - 2]) and Now is \(value)")
        }else{
            debugPrint("Start state : Now is \(value)")
        }
        
        start = NSDate()
        
        if(location >= 2 && answerOrder[location-2] == value){
            timeoutTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target:self, selector: "timeout", userInfo: nil, repeats: false)
        }else{
            resultHideTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target:self, selector: "resultHide", userInfo: nil, repeats: false)
        }
    }
    
    // Timeout Fail
    internal func timeout(){
        if finished > 0 || location >= totalCount{
            return
        }
        
        timeoutTimer?.invalidate()
        clicked = 1
        CheckButton.hidden = true
        resultUIImageView.image = resultFailImage
        resultUIImageView.hidden = false
        
        resultCorrectMap[0]! += 1
        failureLabel.text = "Failure: \(resultCorrectMap[0]!)"
        
        resultTimeMap[trial] = 0
        
        trial += 1
        
        debugPrint("\(trial)th trial result is failure by timeout")
        
        resultHideTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target:self, selector: "resultHide", userInfo: nil, repeats: false)
        
    }
    
    // After all of checking is finished on each step, this function should be called.
    internal func resultHide(){
        if finished > 0 || location >= totalCount{
            return
        }
        resultHideTimer?.invalidate()
        CheckButton.hidden = true
        resultUIImageView.hidden = true
        
        location += 1
        
        suffleTimer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: "suffle", userInfo: nil, repeats: false)
    }
    
    @IBAction func check(sender: AnyObject) {
        if(clicked == 1 || location >= totalCount || location < 2){
            return
        }
        clicked = 1
        let interval = NSDate().timeIntervalSinceDate(start!)
        resultHideTimer?.invalidate()
        timeoutTimer?.invalidate()
        
        var result = ""
        resultUIImageView.hidden = false
        if(answerOrder[location-2] == value){
            resultUIImageView.image = resultSuccessImage
            resultCorrectMap[1]! += 1
            successLabel.text = "Success: \(resultCorrectMap[1]!)"
            result = "success"
        }else{
            resultUIImageView.image = resultFailImage
            resultCorrectMap[0]! += 1
            failureLabel.text = "Failure: \(resultCorrectMap[0]!)"
            result = "failure"
        }
        resultTimeMap[trial] = interval
        
        trial += 1
        debugPrint("\(trial)th trial result is \(result) while \(interval)")
        resultHideTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target:self, selector: "resultHide", userInfo: nil, repeats: false)
    }
    
    internal func finish(){
        descriptionText.text = "Test is finished. Your success score is \(resultCorrectMap[1]!)."
        descriptionText.hidden = false
        finished = 1
        var jsonResult = ""
        for i in 0...(resultTimeMap.count-1) {
            let timestamp = resultTimeMap[i]
            var correct: String = "false"
            if(timestamp > 0){
                correct = "true"
            }
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
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.suffleTimer?.invalidate()
        self.resultHideTimer?.invalidate()
        self.timeoutTimer?.invalidate()
        self.finished = 1
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

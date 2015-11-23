//
//  MemoryTestViewController.swift
//  researchline
//
//  Created by Leo Kang on 11/20/15.
//  Copyright © 2015 bbb. All rights reserved.
//

import UIKit

class MemoryActivityViewController: UIViewController {
    
    @IBOutlet weak var resultUIImageView: UIImageView!
    @IBOutlet weak var CheckButton: UIButton!
    
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var failureLabel: UILabel!
    

    var renderingImageMap = [Int: UIImage]()
    
    var resultCorrectMap = [Int: Int]()
    var resultTimeMap = [Int: NSTimeInterval]()
    var resultFailImage: UIImage = UIImage(named: "X")!
    var resultSuccessImage: UIImage = UIImage(named: "O")!
    
    var suffleTimer: NSTimer? = nil
    var resultHideTimer: NSTimer? = nil
    var timeoutTimer: NSTimer? = nil
    
    var finished: Int = 0
    
    var answer: Int = -1
    var answerNext: Int = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        resultCorrectMap[0] = 0
        resultCorrectMap[1] = 0
        
        CheckButton.hidden = true
        resultUIImageView.hidden = true
        
        suffleTimer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: "suffle", userInfo: nil, repeats: false)
        // Do any additional setup after loading the view.
        
    }
    

    
    var isImage = 1;
    var value = 0;
    var trial = 0;
    var clicked = 0;
    var start: NSDate? = nil
    
    internal func suffle(){
        if finished > 0{
            return
        }
        suffleTimer?.invalidate()
        
        clicked = 0
        resultUIImageView.hidden = true
        CheckButton.hidden = false
        value = Int.init(arc4random_uniform(UInt32(renderingImageMap.count)))
        CheckButton.setImage(renderingImageMap[value], forState: .Normal)

 

        
        resultHideTimer = NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: "resultHide", userInfo: nil, repeats: false)
        
        debugPrint("Answer is \(answer) and Now is \(value)")
        
        
        start = NSDate()
        
        if(answer == value){
            timeoutTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target:self, selector: "timeout", userInfo: nil, repeats: false)
        }else{
            resultHideTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target:self, selector: "resultHide", userInfo: nil, repeats: false)
        }
    }
    
    // Timeout Fail
    internal func timeout(){
        if finished > 0{
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
    
    internal func resultHide(){
        if finished > 0{
            return
        }
        resultHideTimer?.invalidate()
        CheckButton.hidden = true
        resultUIImageView.hidden = true
        
        suffleTimer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: "suffle", userInfo: nil, repeats: false)
        answer = answerNext
        answerNext = value
    }
    
    @IBAction func check(sender: AnyObject) {
        if(clicked == 1){
            return
        }
        clicked = 1
        let interval = NSDate().timeIntervalSinceDate(start!)
        resultHideTimer?.invalidate()
        timeoutTimer?.invalidate()
        
        var result = ""
        resultUIImageView.hidden = false
        if(answer < 0 || answerNext < 0){
            return
        }else if(answer == value){
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

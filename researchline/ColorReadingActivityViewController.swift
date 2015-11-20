//
//  ColorReadingViewController.swift
//  researchline
//
//  Created by Leo Kang on 11/20/15.
//  Copyright © 2015 bbb. All rights reserved.
//

import UIKit

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
    
    var resultCorrectMap = [Int: Int]()
    var resultTimeMap = [Int: NSTimeInterval]()
    var resultFailImage: UIImage = UIImage(named: "X")!
    var resultSuccessImage: UIImage = UIImage(named: "O")!

    
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
        if(answerFlag){
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
        }else{
            resultView.image = resultFailImage
            resultCorrectMap[0]? += 1
            failureLabel.text = "Failure: \(resultCorrectMap[0]!)"
            result = "fail"
        }
        
        trial += 1
        
        debugPrint("\(trial)th trial result is \(result) while \(interval)")
        suffleTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target:self, selector: "suffle", userInfo: nil, repeats: false)
    }
    


    var suffleTimer: NSTimer? = nil
    var resultHideTimer: NSTimer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderedWord.hidden = true
        resultView.hidden = true
        resultCorrectMap[0] = 0
        resultCorrectMap[1] = 0
        suffleTimer = NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: "suffle", userInfo: nil, repeats: false)
    }
    
    
    var answerFlag = false
    var value = 0
    var answer = 0
    var color = 0
    var trial = 0
    var start: NSDate? = nil
    internal func suffle(){
        suffleTimer?.invalidate()
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

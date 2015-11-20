//
//  VisualActivityViewController.swift
//  researchline
//
//  Created by Leo Kang on 11/20/15.
//  Copyright © 2015 bbb. All rights reserved.
//

import UIKit

class VisualActivityViewController: UIViewController {

    @IBOutlet weak var reactionImageView: UIButton!
    @IBOutlet weak var failTextView: UITextField!
    
    var reactionImage: UIImage = UIImage(named: "reaction")!
    var reactionImageReady: UIImage = UIImage(named: "reaction_ready")!
    var reactionTimer: NSTimer? = nil
    var finishReactionTimer: NSTimer? = nil
    
    var resultTimeMap = [Int: NSTimeInterval]()
    
    var isStart = 0 // 0 is ready, 1 is testing, 2 is fail
    var trial = 0
    var startDate: NSDate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        failTextView.hidden = true
        failTextView.borderStyle = UITextBorderStyle.None
        finishReaction()
    }
    
    internal func startReaction(){
        reactionTimer?.invalidate()
        startDate = NSDate()
        reactionImageView.setImage(reactionImage, forState: .Normal)
        isStart = 1
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
        }
    }
    
    @IBAction func click(sender: AnyObject) {
        if(isStart == 1){
            isStart = 2
            let interval = NSDate().timeIntervalSinceDate(startDate!)
            resultTimeMap[trial] = interval
            
            trial += 1
            debugPrint("\(trial)th trial result is success while \(interval)")
            
            finishReaction()
        }else if(isStart == 0){
            isStart = 2
            reactionImageView.hidden = true
            failTextView.hidden = false
            
            debugPrint("\(trial)th trial result is fail")
            
            finishReactionTimer = NSTimer.scheduledTimerWithTimeInterval(3, target:self, selector: "finishReaction", userInfo: nil, repeats: false)
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

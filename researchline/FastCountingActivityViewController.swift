//
//  FastCountingViewController.swift
//  researchline
//
//  Created by Leo Kang on 11/20/15.
//  Copyright © 2015 bbb. All rights reserved.
//

import UIKit

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
    
    
    override func viewDidLoad() {
        timer2?.invalidate()
        timer1 = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "suffle", userInfo: nil, repeats: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        timer1?.invalidate()
        timer2?.invalidate()
    }
    
    @IBAction func touchUpInsideNumberButton(sender: UIButton) {
        if sender.tag == pointCount {
            successCount++
        } else {
            failureCount++
        }
        
        successLabel.text = "Success: \(successCount)"
        failureLabel.text = "Failure: \(failureCount)"
    }

    // MARK: Behavior Methods
    
    internal func suffle() {
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
        
        timer1?.invalidate()
        timer2 = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "showsSelectNumber", userInfo: nil, repeats: false)
    }
    
    internal func showsSelectNumber() {
        NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "suffle", userInfo: nil, repeats: false)
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
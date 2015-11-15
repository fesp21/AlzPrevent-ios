//
//  SignatureView.swift
//  researchline
//
//  Created by Leo Kang on 11/15/15.
//  Copyright © 2015 bbb. All rights reserved.
//

import UIKit

class DrawImageView: UIImageView {
    
    var swiped = false
    var lastPoint = CGPoint.zero
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        // 1
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()
        image?.drawInRect(bounds)
        
        // 2
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        // 3
        CGContextSetLineCap(context, CGLineCap.Square)
        CGContextSetLineWidth(context, 1)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        // 4
        CGContextStrokePath(context)
        
        // 5
        image = UIGraphicsGetImageFromCurrentImageContext()
        alpha = 1
        UIGraphicsEndImageContext()
        
    }
    
    // MARK: UIResponder Methods
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.locationInView(self)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.locationInView(self)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
}
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
    
    var renderingCountMap = [Int: Int]()
    
    
    var renderingImageMap = [Int: UIImage]()
    
    var resultCorrectMap = [Int: Int]()
    var resultFailImage: UIImage = UIImage(named: "X")!
    var resultSuccessImage: UIImage = UIImage(named: "O")!
    
    var suffleTimer: NSTimer? = nil
    var resultHideTimer: NSTimer? = nil
    
    
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
        
        for i in 0...9 {
            renderingCountMap[i] = 0
        }
        resultCorrectMap[0] = 0
        resultCorrectMap[1] = 0
        
        CheckButton.hidden = true
        resultUIImageView.hidden = true
        
        suffleTimer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: "suffle", userInfo: nil, repeats: false)
        // Do any additional setup after loading the view.
        
    }
    

    
    var isImage = 1;
    var value = 0;
    
    internal func suffle(){
        suffleTimer?.invalidate()
        if(isImage == 1){
            CheckButton.hidden = false;
            value = Int.init(arc4random_uniform(UInt32(renderingImageMap.count)))
            CheckButton.setImage(renderingImageMap[value], forState: .Normal)
            renderingCountMap[value]! += 1

            isImage = 0
        }else{
            CheckButton.hidden = true;
            
            debugPrint("\(value)'s count is \(renderingCountMap[value])")
            
            if(renderingCountMap[value] > 1){
                resultUIImageView.image = resultFailImage
                resultUIImageView.hidden = false

                resultCorrectMap[0]! += 1
                
                resultHideTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target:self, selector: "resultHide", userInfo: nil, repeats: false)
                
                renderingCountMap[value] = 0
            }
            
            isImage = 1
        }
        suffleTimer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: "suffle", userInfo: nil, repeats: false)
    }
    
    internal func resultHide(){
        resultHideTimer?.invalidate()
        resultUIImageView.hidden = true
    }
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    @IBAction func check(sender: AnyObject) {
        if(isImage == 1){
            return
        }
        resultUIImageView.hidden = false
        if(renderingCountMap[value] > 1){
            resultUIImageView.image = resultSuccessImage
            resultCorrectMap[1]! += 1
        }else{
            resultUIImageView.image = resultFailImage
            resultCorrectMap[0]! += 1
        }
        renderingCountMap[value] = 0
        resultHideTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target:self, selector: "resultHide", userInfo: nil, repeats: false)
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

//
//  DashboardTableViewCell.swift
//  researchline
//
//  Created by Leo Kang on 11/22/15.
//  Copyright © 2015 bbb. All rights reserved.
//

import UIKit
import BEMSimpleLineGraph
import Alamofire

class DashboardTableViewCell: UITableViewCell, BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate {
    
    @IBOutlet weak var contentGraphView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let maximum = 5
    var data = []
    var scale = 0.0
    var count = 0
    var name: String = ""
    var myGraph: BEMSimpleLineGraphView? = nil
    
    func drawGraph(){
        if(self.myGraph != nil){
            self.contentGraphView.subviews.forEach({ $0.removeFromSuperview() })
        }
        let frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width - 40, height: 200)
        self.myGraph = BEMSimpleLineGraphView(frame: frame)
        self.myGraph!.dataSource = self
        self.myGraph!.delegate = self
        self.myGraph!.enableBezierCurve = true;
        self.myGraph!.colorTop = UIColor.clearColor()
        self.myGraph!.colorBottom = UIColor.clearColor()
        self.myGraph!.colorPoint = UIColor.blackColor()
        self.myGraph!.colorLine = UIColor.grayColor()
        self.myGraph!.enableYAxisLabel = true
        self.myGraph!.enableTouchReport = true
        self.myGraph!.enablePopUpReport = true
        self.myGraph!.autoScaleYAxis = true
        self.myGraph!.alwaysDisplayDots = false
        self.myGraph!.enableReferenceYAxisLines = true
        self.myGraph!.enableReferenceXAxisLines = true
        self.myGraph!.enableReferenceAxisFrame = true
        if scale < 10 {
            self.myGraph!.formatStringForValues = "%.2f"
        }

        self.contentGraphView.addSubview(self.myGraph!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // request to server about statistic information
    }
    
    // MARK: Simple Line Graph View
    
    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        self.count = self.data.count
        if(maximum < self.data.count){
            self.count = maximum
        }
        return self.count
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        let dataItem = self.data[self.count - index - 1]["data"]!! as? [String: AnyObject]
        if dataItem!.keys.contains(name){
            let valueStr = dataItem![name] as! String
            if scale < 3 {
                let value = String(format:"%.2f", Double(valueStr)!)
                debugPrint(value)
                return CGFloat(Double(valueStr)!)
            }else{
                let value = NSNumberFormatter().numberFromString(valueStr)
                return CGFloat(value!)
            }
        }else{
            return CGFloat(0.0)
        }
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, labelOnXAxisForIndex index: Int) -> String {
        let minusDate = self.count - index
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateByAddingUnit(.Day, value: -minusDate, toDate: NSDate(), options: [])
        let components = calendar.components(.Day, fromDate: date!)
        return String(components.day)
    }
    
    func incrementValueForYAxisOnLineGraph(graph: BEMSimpleLineGraphView) -> CGFloat {
        if scale < 3 {
            return 0.1
        }
        return 1
    }
    
    func maxValueForLineGraph(graph: BEMSimpleLineGraphView) -> CGFloat {
        return CGFloat(scale)
    }
    
    func minValueForLineGraph(graph: BEMSimpleLineGraphView) -> CGFloat {
        return CGFloat(0)
    }
    
    func yAxisSuffixOnLineGraph(graph: BEMSimpleLineGraphView) -> String {
        if scale < 3 {
            return ""
        }else{
            return "  "
        }
    }
    
    func yAxisPrefixOnLineGraph(graph: BEMSimpleLineGraphView) -> String {
        if scale < 3 {
            return ""
        }else{
            return ""
        }
    }
    
    
}
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
    var count = 0
    var name: String = ""
    
    func drawGraph(){
        let frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width - 40, height: 200)
        let myGraph = BEMSimpleLineGraphView(frame: frame)
        myGraph.dataSource = self
        myGraph.delegate = self
        myGraph.enableBezierCurve = false;
        myGraph.colorTop = UIColor.clearColor()
        myGraph.colorBottom = UIColor.clearColor()
        myGraph.colorPoint = UIColor.blackColor()
        myGraph.colorLine = UIColor.grayColor()
        myGraph.enableYAxisLabel = true
        self.contentGraphView.addSubview(myGraph)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.drawGraph()
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
            let value = NSNumberFormatter().numberFromString(valueStr)
            return CGFloat(value!)
        }else{
            return 0
        }
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, labelOnXAxisForIndex index: Int) -> String {
        let minusDate = self.count - index
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateByAddingUnit(.Day, value: -minusDate, toDate: NSDate(), options: [])
        let components = calendar.components(.Day, fromDate: date!)
        return String(components.day)
    }
    
}
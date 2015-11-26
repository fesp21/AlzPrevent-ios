//
//  DashboardTableViewCell.swift
//  researchline
//
//  Created by Leo Kang on 11/22/15.
//  Copyright © 2015 bbb. All rights reserved.
//

import UIKit
import BEMSimpleLineGraph

class DashboardTableViewCell: UITableViewCell, BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: bounds.height)
        let myGraph = BEMSimpleLineGraphView(frame: frame)
        myGraph.dataSource = self
        myGraph.delegate = self
        myGraph.enableBezierCurve = true;
        myGraph.colorTop = UIColor.clearColor()
        myGraph.colorBottom = UIColor.clearColor()
        myGraph.colorPoint = UIColor.blackColor()
        myGraph.colorLine = UIColor.grayColor()
        myGraph.enableYAxisLabel = true
        self.addSubview(myGraph)
    }
    
    // MARK: Simple Line Graph View
    
    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return 5
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        switch index {
        case 1:
            return 5
        case 2:
            return 10
        default:
            return 0
        }
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, labelOnXAxisForIndex index: Int) -> String {
        let result: String? = "test"
        return result!
    }
}
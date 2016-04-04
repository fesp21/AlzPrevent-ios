//
//  PieChartViewDataSource.swift
//  researchline
//
//  Created by jknam on 2016. 2. 8..
//  Copyright © 2016년 bbb. All rights reserved.
//

import ResearchKit

class PieChartViewDataSource: NSObject, ORKPieChartViewDataSource {
    var label = ["To Do", "Done"]
    
    let colors = [
        UIColor(red: 217/225, green: 217/255, blue: 217/225, alpha: 1),
//        UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1),
        UIColor(red: 244/255, green: 190/255, blue: 74/255, alpha: 1)
    ]
    var values = [10.0, 25.0]
    
    func numberOfSegmentsInPieChartView(pieChartView: ORKPieChartView ) -> Int {
        return values.count
    }
    
    func pieChartView(pieChartView: ORKPieChartView, valueForSegmentAtIndex index: Int) -> CGFloat {
        return CGFloat(values[index])
    }
    
    func pieChartView(pieChartView: ORKPieChartView, colorForSegmentAtIndex index: Int) -> UIColor {
        return colors[index]
    }
    
    func pieChartView(pieChartView: ORKPieChartView, titleForSegmentAtIndex index: Int) -> String {
        return label[index]
    }
}

class LineGraphDataSource: NSObject, ORKGraphChartViewDataSource {
    
    var name = ""
    var data = []
    var max = CGFloat(70.0)
    var min = CGFloat(0)
    var scale = 1.0
    var count = 0
    
    func numberOfPlotsInGraphChartView(graphChartView: ORKGraphChartView) -> Int {
        return 1
    }
    
    func graphChartView(graphChartView: ORKGraphChartView, pointForPointIndex pointIndex: Int, plotIndex: Int) -> ORKRangedPoint {
        let dataItem = self.data[self.count - pointIndex - 1]["data"]!! as? [String: AnyObject]
        if dataItem!.keys.contains(name){
            let valueStr = dataItem![name] as! String
            if scale < 3 {
                return ORKRangedPoint(value: CGFloat(Double(valueStr)!))
            }else{
                let value = NSNumberFormatter().numberFromString(valueStr)
                return ORKRangedPoint(value: CGFloat(Double(value!)))
            }
        }else{
            return ORKRangedPoint(value: 0.0)
        }
    }
    
    func graphChartView(graphChartView: ORKGraphChartView, numberOfPointsForPlotIndex plotIndex: Int) -> Int {
        return count
    }
    
    func maximumValueForGraphChartView(graphChartView: ORKGraphChartView) -> CGFloat {
        if max == 0 {
            return graphChartView.maximumValue
        }
        return self.max
    }
    
    func minimumValueForGraphChartView(graphChartView: ORKGraphChartView) -> CGFloat {
        return self.min
    }
    
    func graphChartView(graphChartView: ORKGraphChartView, titleForXAxisAtPointIndex pointIndex: Int) -> String? {
        let minusDate = self.count - pointIndex - 1
        let calendar = NSCalendar.currentCalendar()
        let date = calendar.dateByAddingUnit(.Day, value: -minusDate, toDate: NSDate(), options: [])
        let components = calendar.components(.Day, fromDate: date!)
        return String(components.day)
    }
}
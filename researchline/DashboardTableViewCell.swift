//
//  DashboardTableViewCell.swift
//  researchline
//
//  Created by Leo Kang on 11/22/15.
//  Copyright © 2015 bbb. All rights reserved.
//

import UIKit
import Alamofire
import ResearchKit

class DashboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentGraphView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let maximum = 5
    var data = []
    var scale = 0.0
    var count = 0
    var name: String = ""
    var myGraph: ORKLineGraphChartView? = nil
    
    func drawGraph(){
        if(self.myGraph != nil){
            self.contentGraphView.subviews.forEach({ $0.removeFromSuperview() })
        }
        let frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width - 40, height: 200)
        
        self.myGraph = ORKLineGraphChartView(frame: frame)
        let dataSource = LineGraphDataSource()
        dataSource.data = self.data
        dataSource.scale = self.scale
        dataSource.max = CGFloat(self.scale)
        dataSource.count = self.data.count
        dataSource.name = self.name
        
        self.myGraph!.dataSource = dataSource

        self.contentGraphView.addSubview(self.myGraph!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // request to server about statistic information
    }
    
}
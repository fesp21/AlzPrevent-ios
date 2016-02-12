//
//  DashboardViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit
import Alamofire
import ResearchKit

class DashboardViewController: UITableViewController {

    // MARK: Table View Delgate


    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var pieChartView: ORKPieChartView!
    
    var mFormat: NSNumberFormatter? = nil
    var sizeOfGraph = 0
    var data = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mFormat = NSNumberFormatter(); // use one decimal
        mFormat!.numberStyle = .PercentStyle
    }
    
    override func viewDidAppear(animated: Bool) {
        if(Constants.userDefaults.stringForKey("dateString") != nil){
            dateTextLabel.text = "Today, \(Constants.userDefaults.stringForKey("dateString")!)"
        }else{
            dateTextLabel.text = "Today"
        }
        
        Alamofire.request(.GET, Constants.statistics,
            headers: [
                "deviceKey": Constants.deviceKey,
                "deviceType": Constants.deviceType,
                "signKey": Constants.signKey()
            ], parameters: [
                "activity": "Test1,Memory,Color Reading,Fast Counting,Visual Activity,Item Span Forward,Item Span Backward",
                "size": 5
            ]).responseJSON { (response:Response) -> Void in
                switch response.result{
                case.Success(let json):
                    if(json["success"] as? Int == 0){
                        break
                    }
                    self.data = (json["data"]! as? NSArray)!
                    Constants.userDefaults.setObject(self.data, forKey: "dashboardData")
                    self.sizeOfGraph = 7
                    self.tableView.reloadData()
                    break
                default:
                    break
                }
        }
        
        let doRate = Constants.userDefaults.doubleForKey("completion")
        let doRate100 = doRate * 100
        var pieData = [1-doRate, doRate]
        var label = ["To Do", "Done"]
        if doRate == 0.0  {
            pieData = [1]
            label = ["To Do"]
        } else if doRate == 1.0 {
            pieData = [1]
            label = ["Done"]
        }

        let dataSource = PieChartViewDataSource()
        dataSource.values = pieData
        dataSource.label = label
        
        pieChartView.dataSource = dataSource
        pieChartView.title = String(format: "%.0f%%", doRate100)
        pieChartView.lineWidth = 14
        pieChartView.showsPercentageLabels = false
        pieChartView.showsTitleAboveChart = false
        pieChartView.noDataText = "0%%"
        pieChartView.animateWithDuration(0)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sizeOfGraph
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var thisTableView: DashboardTableViewCell?
        switch(indexPath.row){
        case 0:
            thisTableView = tableView.dequeueReusableCellWithIdentifier("GlucoseDashboardTableViewCell", forIndexPath: indexPath) as? DashboardTableViewCell
            thisTableView!.data = self.data
            thisTableView!.scale = 200
            break
        case 1:
            thisTableView = tableView.dequeueReusableCellWithIdentifier("MemoryDashboardTableViewCell", forIndexPath: indexPath) as? DashboardTableViewCell
            thisTableView!.data = self.data
            thisTableView!.scale = 5
            break
        case 2:
            thisTableView = tableView.dequeueReusableCellWithIdentifier("ColorDashboardTableViewCell", forIndexPath: indexPath) as? DashboardTableViewCell
            thisTableView!.data = self.data
            thisTableView!.scale = 5
            break
        case 3:
            thisTableView = tableView.dequeueReusableCellWithIdentifier("CountingDashboardTableViewCell", forIndexPath: indexPath) as? DashboardTableViewCell
            thisTableView!.data = self.data
            thisTableView!.scale = 5
            break
        case 4:
            thisTableView = tableView.dequeueReusableCellWithIdentifier("VisualDashboardTableViewCell", forIndexPath: indexPath) as? DashboardTableViewCell
            thisTableView!.data = self.data
            thisTableView!.scale = 5
            break
        case 5:
            thisTableView = tableView.dequeueReusableCellWithIdentifier("ItemForwordDashboardTableViewCell", forIndexPath: indexPath) as? DashboardTableViewCell
            thisTableView!.data = self.data
            thisTableView!.scale = 5
            break
        case 6:
            thisTableView = tableView.dequeueReusableCellWithIdentifier("ItemBackwordDashboardTableViewCell", forIndexPath: indexPath) as? DashboardTableViewCell
            thisTableView!.data = self.data
            thisTableView!.scale = 5
            break
        default:
            thisTableView = tableView.dequeueReusableCellWithIdentifier("MemoryDashboardTableViewCell", forIndexPath: indexPath) as? DashboardTableViewCell
            thisTableView!.data = self.data
            thisTableView!.scale = 5
            break
        }
        thisTableView!.drawGraph()
        return thisTableView!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 250;
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
}
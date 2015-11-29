//
//  DashboardViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit
import Charts
import Alamofire

class DashboardViewController: UITableViewController {

    // MARK: Table View Delgate

    @IBOutlet weak var pieChartView: PieChartView!
    
    var mFormat: NSNumberFormatter? = nil
    var sizeOfGraph = 0
    var data = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mFormat = NSNumberFormatter(); // use one decimal
        mFormat!.numberStyle = .PercentStyle

        
        
        Alamofire.request(.GET, Constants.statistics,
            headers: [
                "deviceKey": Constants.deviceKey,
                "deviceType": Constants.deviceType,
                "signKey": Constants.signKey()
            ], parameters: [
                "activity": "Test1,Memory,Color Reading,Fast Counting,Visual Activity,Item Span Forward,Item Span Backward",
                "size": 5
            ]).responseJSON { (response:Response) -> Void in
                debugPrint(response)
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
    }
    
    override func viewDidAppear(animated: Bool) {
        let doRate = Constants.userDefaults.doubleForKey("completion")
        
        let xVals = ["Done", "To Do"]
        let data = [doRate, 1-doRate]
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<xVals.count {
            let dataEntry = ChartDataEntry(value: data[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: xVals, dataSet: pieChartDataSet)
        
        let green = UIColor(red: CGFloat(180.0/255), green: CGFloat(230.0/255), blue: CGFloat(180.0/255), alpha: 1)
        let white = UIColor(red: CGFloat(240.0/255), green: CGFloat(240.0/255), blue: CGFloat(240.0/255), alpha: 1)
        
        pieChartDataSet.colors = [green, white]
        pieChartData.setValueFormatter(mFormat)
        pieChartView.data = pieChartData
        pieChartView.drawCenterTextEnabled = false
        pieChartView.drawMarkers = false
        pieChartView.drawSliceTextEnabled = false
        pieChartView.highlightValue(xIndex: 0, dataSetIndex: 0, callDelegate: false)
        pieChartView.descriptionText = ""
        pieChartView.centerTextRadiusPercent = 10.0
        pieChartView.userInteractionEnabled = false
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
            break
        case 1:
            thisTableView = tableView.dequeueReusableCellWithIdentifier("MemoryDashboardTableViewCell", forIndexPath: indexPath) as? DashboardTableViewCell
            thisTableView!.data = self.data
            break
        case 2:
            thisTableView = tableView.dequeueReusableCellWithIdentifier("ColorDashboardTableViewCell", forIndexPath: indexPath) as? DashboardTableViewCell
            thisTableView!.data = self.data
            break
        case 3:
            thisTableView = tableView.dequeueReusableCellWithIdentifier("CountingDashboardTableViewCell", forIndexPath: indexPath) as? DashboardTableViewCell
            thisTableView!.data = self.data
            break
        case 4:
            thisTableView = tableView.dequeueReusableCellWithIdentifier("VisualDashboardTableViewCell", forIndexPath: indexPath) as? DashboardTableViewCell
            thisTableView!.data = self.data
            break
        case 5:
            thisTableView = tableView.dequeueReusableCellWithIdentifier("ItemForwordDashboardTableViewCell", forIndexPath: indexPath) as? DashboardTableViewCell
            thisTableView!.data = self.data
            break
        case 6:
            thisTableView = tableView.dequeueReusableCellWithIdentifier("ItemBackwordDashboardTableViewCell", forIndexPath: indexPath) as? DashboardTableViewCell
            thisTableView!.data = self.data
            break
        default:
            thisTableView = tableView.dequeueReusableCellWithIdentifier("MemoryDashboardTableViewCell", forIndexPath: indexPath) as? DashboardTableViewCell
            thisTableView!.data = self.data
            break
        }

        return thisTableView!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 250;
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
}
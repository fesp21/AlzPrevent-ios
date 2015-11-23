//
//  ActivitiesViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit
import Alamofire

class ActivitiesViewController: UITableViewController {
    
    var emptyCircleImage: UIImage = UIImage(named: "EmptyCircle")!
    var checkedCircleImage: UIImage = UIImage(named: "valid_icon")!
    var failCircleImage: UIImage = UIImage(named: "redcircle_X")!
    
    var data = []
    var yesterdayData = []
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        refresh()
    }
    
    func refresh(){
        var finishToday = 0
        var finishYesterday = 0
        Alamofire.request(.GET, Constants.todayActivity, headers: [
            "deviceKey": Constants.deviceKey,
            "deviceType": Constants.deviceType,
            "signKey": Constants.signKey!])
            .responseJSON { (response: Response) -> Void in
                switch response.result{
                case.Success(let json):
                    debugPrint(json)
                    if(json["success"] as? Int == 0){
                        Constants.userDefaults.removeObjectForKey("signKey")
//                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Welcome", bundle: nil)
//                        let viewController = mainStoryboard.instantiateInitialViewController()
//                        UIApplication.sharedApplication().keyWindow!.rootViewController = viewController;
                        exit(0)
                        break
                    }
                    self.data = (json["data"]! as? NSArray)!
                    finishToday = 1
                    if(finishYesterday > 0){
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
                    }
                    break
                default:
                    break
                }
                
        }
        
        Alamofire.request(.GET, Constants.yesterdayActivity, headers: [
            "deviceKey": Constants.deviceKey,
            "deviceType": Constants.deviceType,
            "signKey": Constants.signKey!])
            .responseJSON { (response: Response) -> Void in
                switch response.result{
                case.Success(let json):
                    debugPrint(json)
                    if(json["success"] as? Int == 0){
                        Constants.userDefaults.removeObjectForKey("signKey")
//                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Welcome", bundle: nil)
//                        let viewController = mainStoryboard.instantiateInitialViewController()
//                        UIApplication.sharedApplication().keyWindow!.rootViewController = viewController;
                        exit(0)
                        break
                    }
                    self.yesterdayData = (json["data"]! as? NSArray)!
                    finishYesterday = 1
                    if(finishToday > 0){
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
                    }
                    break
                default:
                    break
                }
                
        }
    }
    
    // MARK: Table View Delegate
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count + yesterdayData.count + 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("TodayTableViewCell", forIndexPath: indexPath) as! TodayTableViewCell
            if(self.data.count > 0){
            cell.dateTextView.text = "Today, \(self.data[0]["dateString"]!!)"
            }
            return cell
        }else if(indexPath.row == (data.count + 1)){
            let cell = tableView.dequeueReusableCellWithIdentifier("YesterdayTableViewCell", forIndexPath: indexPath) as! YesterdayTableViewCell
            if(self.yesterdayData.count > 0){
            cell.dateTextView.text = "Yesterday, \(self.yesterdayData[0]["dateString"]!!)"
            }
            
            return cell
        }else if(indexPath.row > (data.count + 1)){
            // Yesterday Logic
            
            let cellData = self.data[indexPath.row - 2 - data.count]
            
            let todayTask = cellData["todayTask"]! as? String
            
            if (todayTask ?? "").isEmpty {
                let cell = tableView.dequeueReusableCellWithIdentifier("ActivitiesTableViewCell2", forIndexPath: indexPath) as! ActivitiesTableViewCell2
                cell.activityName = cellData["name"]! as? String
                cell.activityId = cellData["id"]! as? String
                cell.today = 0
                cell.titleTextView.text = cellData["description"]! as? String
                if(cellData["hasDone"] as? Int > 0){
                    cell.checkImageView.image = failCircleImage
                }else{
                    cell.checkImageView.image = checkedCircleImage
                }
                cell.userInteractionEnabled = false
                return cell
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("ActivitiesTableViewCell", forIndexPath: indexPath) as! ActivitiesTableViewCell
                cell.activityName = cellData["name"]! as? String
                cell.activityId = cellData["id"]! as? String
                cell.today = 0
                cell.titleTextView.text = cellData["description"]! as? String
                cell.subTitleTextView.text = todayTask
                if(cellData["hasDone"] as? Int > 0){
                    cell.checkImageView.image = failCircleImage
                }else{
                    cell.checkImageView.image = checkedCircleImage
                }
                cell.userInteractionEnabled = false
                return cell
            }
        }else{
            // Today Logic
            
            let cellData = self.data[indexPath.row - 1]
            
            let todayTask = cellData["todayTask"]! as? String
            
            if (todayTask ?? "").isEmpty {
                let cell = tableView.dequeueReusableCellWithIdentifier("ActivitiesTableViewCell2", forIndexPath: indexPath) as! ActivitiesTableViewCell2
                cell.activityName = cellData["name"]! as? String
                cell.activityId = cellData["id"]! as? String
                cell.today = 1
                cell.titleTextView.text = cellData["description"]! as? String
                if(cellData["hasDone"] as? Int > 0){
                    cell.checkImageView.image = checkedCircleImage
                }else{
                    cell.checkImageView.image = emptyCircleImage
                }
                cell.activitiesViewController = self
                return cell
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("ActivitiesTableViewCell", forIndexPath: indexPath) as! ActivitiesTableViewCell
                cell.activityName = cellData["name"]! as? String
                cell.activityId = cellData["id"]! as? String
                cell.today = 1
                cell.titleTextView.text = cellData["description"]! as? String
                cell.subTitleTextView.text = todayTask
                if(cellData["hasDone"] as? Int > 0){
                    cell.checkImageView.image = checkedCircleImage
                }else{
                    cell.checkImageView.image = emptyCircleImage
                }
                cell.activitiesViewController = self
                return cell
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0){
            
        }else if(indexPath.row == (data.count + 1)){
            
        }else if(indexPath.row > (data.count + 1)){
            // Yesterday Logic
        }else{
            // Today Logic
            let cellData = self.data[indexPath.row - 1]
            let activityId = cellData["id"]! as? String
            let activityName = cellData["name"] as? String
            let todayTask = cellData["todayTask"]! as? String
            
            if(activityName == "Test1"){
                Alamofire.request(.POST, Constants.activity, headers: [
                    "deviceKey": Constants.deviceKey,
                    "deviceType": Constants.deviceType,
                    "signKey": Constants.signKey!],
                    parameters:[
                        "activityId": activityId!,
                        "value": ""
                    ])
                    .responseJSON { (response: Response) -> Void in
                        switch response.result{
                        case.Success(let json):
                            debugPrint(json)
                            if let _response = response.response {
                                if _response.statusCode < 300 {
                                    if json["data"]!!["hasDone"] as! Int > 0{
                                        let alert = UIAlertController(title: "Alert", message: "Success to Take Glucose Blood Sample.", preferredStyle: UIAlertControllerStyle.Alert)
                                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                                        self.presentViewController(alert, animated: true, completion: nil)
                                    }else{
                                        let alert = UIAlertController(title: "Alert", message: "Fail to Take Glucose Blood Sample.", preferredStyle: UIAlertControllerStyle.Alert)
                                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                                        self.presentViewController(alert, animated: true, completion: nil)
                                    }
                                    
                                }else{
                                    let storybard = UIStoryboard(name: "Activities", bundle: nil)
                                    let controller = storybard.instantiateViewControllerWithIdentifier("ActivityViewController")
                                    
                                    self.navigationController?.pushViewController(controller, animated: true)
                                }
                            }
                            break
                        case.Failure(let error):
                            debugPrint(error)
                            break
                        }
                        
                }
            }else{
                switch (todayTask!){
                case "Memory":
                    let storybard = UIStoryboard(name: "MemoryActivity", bundle: nil)
                    let controller = storybard.instantiateInitialViewController()!
                    
                    self.navigationController?.pushViewController(controller, animated: true)
                break
                case "Color Reading":
                    let storybard = UIStoryboard(name: "ColorReadingActivity", bundle: nil)
                    let controller = storybard.instantiateInitialViewController()!
                    
                    self.navigationController?.pushViewController(controller, animated: true)
                break
                case "Fast Counting":
                    let storybard = UIStoryboard(name: "FastCountingActivity", bundle: nil)
                    let controller = storybard.instantiateInitialViewController()!
                    
                    self.navigationController?.pushViewController(controller, animated: true)
                break
                case "Visual Activity":
                    let storybard = UIStoryboard(name: "VisualActivity", bundle: nil)
                    let controller = storybard.instantiateInitialViewController()!
                    
                    self.navigationController?.pushViewController(controller, animated: true)
                break
                case "Item Span Forward":
                    let storybard = UIStoryboard(name: "ItemSpanForwardActivity", bundle: nil)
                    let controller = storybard.instantiateInitialViewController()!
                    
                    self.navigationController?.pushViewController(controller, animated: true)
                break
                case "Item Span Backward":
                    let storybard = UIStoryboard(name: "ItemSpanBackwardActivity", bundle: nil)
                    let controller = storybard.instantiateInitialViewController()!
                    
                    self.navigationController?.pushViewController(controller, animated: true)
                break
                default:
                break
                }

            }
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
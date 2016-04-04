//
//  ActivitiesViewController.swift
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
    
    @IBOutlet weak var loadingBarView: UIView!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    var progressTimer: NSTimer?
    
    var data = []
    var yesterdayData = []
    
    func updateProgress() {
        progressView.progress += 0.025
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl

        Alamofire.request(.GET, Constants.profile,
            headers: [
                "deviceKey": Constants.deviceKey,
                "deviceType": Constants.deviceType,
                "signKey": Constants.signKey()
            ]).responseJSON { (response:Response) -> Void in
                debugPrint(response)
                switch response.result{
                case.Success(let json):
                    
                    if(json["success"] as? Int == 0){
                        break
                    }
                    Constants.userDefaults.setValue(json["data"]!!["firstName"]!, forKey: "firstName")
                    Constants.userDefaults.setValue(json["data"]!!["lastName"]!, forKey: "lastName")
                    Constants.userDefaults.setValue(json["data"]!!["height"]!, forKey: "height")
                    Constants.userDefaults.setValue(json["data"]!!["weight"]!, forKey: "weight")
                    Constants.userDefaults.setValue(json["data"]!!["sex"]!, forKey: "sex")
                    Constants.userDefaults.setValue(json["data"]!!["birth"]!, forKey: "birth")
                    break
                default:
                    break
                }
        }
        
        if (Constants.signKey() != ""){
            Alamofire.request(.GET, Constants.glucoseData,
                headers: [
                    "deviceKey": Constants.deviceKey,
                    "deviceType": Constants.deviceType,
                    "signKey": Constants.signKey()])
                .responseJSON { (response) -> Void in
                    switch response.result{
                    case.Success(let json):
                        
                        if(json["success"] as? Int == 0){
                            break
                        }
                        let data: NSArray = json["data"] as! NSArray
                        for item in data {
                            let dateStr: String = item["dateStr"] as! String
                            let timeZone: String = item["timeZone"] as! String
                            let formatter = NSDateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                            formatter.timeZone = NSTimeZone(name: timeZone)
                            let date = formatter.dateFromString(dateStr)
                            let result = item["result"] as! Double
                            let date_key = "glucose_"+dateStr
                            if(Constants.userDefaults.valueForKey(date_key) != nil){
                                debugPrint("Glucose data already stored at " + dateStr)
                            }else{
                                HealthManager.requestSavingGlucoseSample(result, date: date!, key: date_key)
                            }
                            
                            
                        }
                        break
                    default:
                        break
                    }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        refresh()
    }
    
    func refresh(){
        progressView.progress = 0
        progressView.hidden = false
        progressTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "updateProgress", userInfo: nil, repeats: true)
        
        var finishToday = 0
        var finishYesterday = 0
        Alamofire.request(.GET, Constants.todayActivity, headers: [
            "deviceKey": Constants.deviceKey,
            "deviceType": Constants.deviceType,
            "signKey": Constants.signKey()])
            .responseJSON { (response: Response) -> Void in
                switch response.result{
                case.Success(let json):
                    debugPrint(json)
                    if(json["success"] as? Int == 0){
                        Constants.userDefaults.removeObjectForKey("signKey")
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Welcome", bundle: nil)
                        let viewController = mainStoryboard.instantiateInitialViewController()
                        UIApplication.sharedApplication().keyWindow!.rootViewController = viewController;
                        break
                    }
                    self.data = (json["data"]! as? NSArray)!
                    
                    var total: Float = 0
                    var success: Float = 0
                    for i in 0...self.data.count-1 {
                        if(self.data[i]["hasDone"]!! as! Int > 0){
                            success += 1
                        }
                        total += 1
                    }
                    let doRate: Float = success / total
                    debugPrint("The rate of completion is \(doRate)%")
                    Constants.userDefaults.setObject(doRate, forKey: "completion")
                    
                    finishToday = 1
                    if(finishYesterday > 0){
                        self.progressTimer?.invalidate()
                        self.loadingBarView.hidden = true
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
            "signKey": Constants.signKey()])
            .responseJSON { (response: Response) -> Void in
                switch response.result{
                case.Success(let json):
                    debugPrint(json)
                    if(json["success"] as? Int == 0){
                        Constants.userDefaults.removeObjectForKey("signKey")
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Welcome", bundle: nil)
                        let viewController = mainStoryboard.instantiateInitialViewController()
                        UIApplication.sharedApplication().keyWindow!.rootViewController = viewController;
                        break
                    }
                    self.yesterdayData = (json["data"]! as? NSArray)!
                    finishYesterday = 1
                    if(finishToday > 0){
                        self.progressTimer?.invalidate()
                        self.loadingBarView.hidden = true
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
                let dateString = self.data[0]["dateString"]!!
                cell.dateTextView.text = "Today, \(dateString)"
                Constants.userDefaults.setObject(dateString, forKey: "dateString")
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
            
            let cellData = self.yesterdayData[indexPath.row - 2 - data.count]
            
            let todayTask = cellData["todayTask"]! as? String
            
            if (todayTask ?? "").isEmpty {
                let cell = tableView.dequeueReusableCellWithIdentifier("ActivitiesTableViewCell2", forIndexPath: indexPath) as! ActivitiesTableViewCell2
                cell.activityName = cellData["name"]! as? String
                cell.activityId = cellData["id"]! as? String
                cell.today = 0
                cell.titleTextView.text = cellData["description"]! as? String
                if(cellData["hasDone"] as? Int > 0){
                    cell.checkImageView.image = checkedCircleImage
                }else{
                    cell.checkImageView.image = failCircleImage
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
                    cell.checkImageView.image = checkedCircleImage
                }else{
                    cell.checkImageView.image = failCircleImage
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
                cell.userInteractionEnabled = true
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
                cell.userInteractionEnabled = true
                return cell
            }
        }
    }
    
    var test1Flag = false
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
                // for glucose test
//                let storybard = UIStoryboard(name: "Activities", bundle: nil)
//                let controller = storybard.instantiateViewControllerWithIdentifier("GlucoseSuccessViewController") as! GlucoseSuccessViewController
//                controller.success =  true
//                controller.score = "300"
//                self.navigationController?.pushViewController(controller, animated: true)
//                return
                // /////////////
                
                if(self.test1Flag == true){
                    return
                }
                self.test1Flag = true;

                Alamofire.request(.POST, Constants.activity, headers: [
                    "deviceKey": Constants.deviceKey,
                    "deviceType": Constants.deviceType,
                    "signKey": Constants.signKey()],
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
                                    let storybard = UIStoryboard(name: "Activities", bundle: nil)
                                    let controller = storybard.instantiateViewControllerWithIdentifier("GlucoseSuccessViewController") as! GlucoseSuccessViewController
                                    
                                    if json["data"]!!["hasDone"] as! Int > 0{
                                        controller.success = true
                                        controller.score = json["data"]!!["value"] as! String
                                    }else{
                                        controller.success = false
                                    }
                                    self.navigationController?.pushViewController(controller, animated: true)
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
                        
                        self.test1Flag = false
                }
            }else{
                debugPrint("key : id_\(activityName!), value : \(activityId!)")
                Constants.userDefaults.setObject(activityId!, forKey: "id_\(activityName!)")
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
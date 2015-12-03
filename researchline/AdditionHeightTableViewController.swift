//
//  HeightTableTableViewController.swift
//  researchline
//
//  Created by jknam on 2015. 11. 30..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit

class AdditionHeightTableViewController: UITableViewController {

    var heights = [Int]()
    var userHeight: Int = 175
    var userHeightIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userHeight = Constants.userDefaults.integerForKey("height")
        
        if userHeight == 0 {
            userHeight = 175
        }
        var index = 0
        for i in 150...200 {
            if(userHeight == i){
                userHeightIndex = index
            }
            heights.append(i)
            index += 1
        }
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return heights.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AdditionHeightCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = "\(heights[indexPath.row]) cm"
        // Configure the cell...
        
        //        if(userHeightIndex == indexPath.row){
        //            cell.accessoryType = .Checkmark
        //            cell.selected = true
        //        }else{
        //            cell.accessoryType = .None
        //        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let height = heights[indexPath.row]
        Constants.userDefaults.setObject(height, forKey: "height")
        
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        
        debugPrint("this indexPath is \(indexPath.row)")
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
    }
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

}

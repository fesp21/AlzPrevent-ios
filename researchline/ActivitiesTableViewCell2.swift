//
//  ActivitiesTableViewCell2.swift
//  researchline
//
//  Created by jknam on 2015. 11. 23..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit
import Alamofire

class ActivitiesTableViewCell2: UITableViewCell {
    
    var activitiesViewController: ActivitiesViewController? = nil;
    var activityName: String? = nil
    var activityId: String? = nil
    var today = 0
    
    @IBOutlet weak var checkImageView: UIImageView!
    
    @IBOutlet weak var titleTextView: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }
    
    
}

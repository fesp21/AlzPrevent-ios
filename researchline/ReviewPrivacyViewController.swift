//
//  ReviewPrivacyViewController.swift
//  researchline
//
//  Created by jknam on 2016. 1. 23..
//  Copyright © 2016년 bbb. All rights reserved.
//

import UIKit

class ReviewPrivacyViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = NSURLRequest(URL: NSURL(string: Constants.urlFilePrivacy)!)
        webView.loadRequest(request)
    }

}

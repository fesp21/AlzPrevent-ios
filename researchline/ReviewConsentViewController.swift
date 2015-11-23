//
//  ReviewConsentViewController.swift
//  researchline
//
//  Created by Leo Kang on 11/22/15.
//  Copyright © 2015 bbb. All rights reserved.
//

import UIKit

class ReviewConsentViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = NSURLRequest(URL: NSURL(string: Constants.urlFileConsent)!)
        webView.loadRequest(request)
    }
}
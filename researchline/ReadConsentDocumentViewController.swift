//
//  ReadConsentDocumentViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit

class ReadConsentDocumentViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = false
        
        let request = NSURLRequest(URL: NSURL(string: Constants.urlFileConsent)!)
        webView.loadRequest(request)
    }
}

//
//  WhatToExpectViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit

class WhatToExpectViewController: UIViewController {

  @IBAction func touchUpInsideGotItButton(sender: UIButton) {
    let storyboard = UIStoryboard(name: "Session", bundle: nil)
    let controller = storyboard.instantiateInitialViewController()!
    navigationController?.pushViewController(controller, animated: true)
  }
}
//
//  EligibilityResultViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit

class EligibilityResultViewController: UIViewController {

  @IBAction func touchUpInsideStartConsent(sender: UIButton) {
    let storyboard = UIStoryboard(name: "Consent", bundle: nil)
    let controller = storyboard.instantiateInitialViewController()!
    navigationController?.pushViewController(controller, animated: true)
  }
}
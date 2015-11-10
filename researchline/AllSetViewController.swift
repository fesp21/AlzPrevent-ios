//
//  AllSetViewController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit

class AllSetViewController: UIViewController {

  @IBAction func touchUpInsideLetsBeginButton(sender: UIButton) {
    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
    let controller = storyboard.instantiateInitialViewController()!

    presentViewController(controller, animated: true, completion: nil)
  }
}
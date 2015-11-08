//
//  StoryboardController.swift
//  researchline
//
//  Created by riverleo on 2015. 11. 8..
//  Copyright © 2015년 bbb. All rights reserved.
//

import UIKit

class StoryboardController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let storyboard = UIStoryboard(name: self.restorationIdentifier!, bundle: nil)
    let controller = storyboard.instantiateInitialViewController()!

    addChildViewController(controller)
    view.addSubview(controller.view)

    controller.didMoveToParentViewController(self)
  }
}
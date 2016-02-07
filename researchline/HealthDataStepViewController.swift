//
//  HealthDataStepViewController.swift
//  researchline
//
//  Created by jknam on 2016. 2. 5..
//  Copyright © 2016년 bbb. All rights reserved.
//

import ResearchKit
import HealthKit

class HealthDataStepViewController: ORKInstructionStepViewController {

    var healthDataStep: HealthDataStep? {
        return step as? HealthDataStep
    }
    
    // MARK: ORKInstructionStepViewController
    
    override func goForward() {
        healthDataStep?.getHealthAuthorization() { succeeded, _ in
            guard succeeded else { return }
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                super.goForward()
            }
        }
    }

}

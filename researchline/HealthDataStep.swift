//
//  HeathDataStep.swift
//  researchline
//
//  Created by jknam on 2016. 2. 5..
//  Copyright © 2016년 bbb. All rights reserved.
//

import ResearchKit
import HealthKit

class HealthDataStep: ORKInstructionStep {
    
    let healthDataItemsToRead: Set<HKObjectType> = [
        HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!,
        HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!,
        HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!
    ]
    
    let healthDataItemsToWrite: Set<HKSampleType> = [
        HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!,
        HKObjectType.workoutType()
    ]
    
    // MARK: Initialization
    
    override init(identifier: String) {
        super.init(identifier: identifier)
        
        title = NSLocalizedString("Health Data", comment: "")
        text = NSLocalizedString("On the next screen, you will be prompted to grant access to read and write some of your general and health information, such as height, weight, and steps taken so you don't have to enter it again.", comment: "")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Convenience
    
    func getHealthAuthorization(completion: (success: Bool, error: NSError?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            let error = NSError(domain: "com.example.apple-samplecode.ORKSample", code: 2, userInfo: [NSLocalizedDescriptionKey: "Health data is not available on this device."])
            
            completion(success: false, error:error)
            
            return
        }
        
        // Get authorization to access the data
        HKHealthStore().requestAuthorizationToShareTypes(healthDataItemsToWrite, readTypes: healthDataItemsToRead) { (success, error) -> Void in
            completion(success:success, error:error)
        }
    }
}

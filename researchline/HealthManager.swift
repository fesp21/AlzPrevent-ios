//
//  HealthManager.swift
//  researchline
//
//  Created by Leo Kang on 11/15/15.
//  Copyright © 2015 bbb. All rights reserved.
//

import UIKit
import HealthKit

class HealthManager: NSObject {
    
    static let store: HKHealthStore = HKHealthStore()
    
    internal static let readTypes = [
        "sex": HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)!,
        "dateOfBirth": HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!,
        "distanceWalkingRunning": HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!,
        "flightsClimbed": HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierFlightsClimbed)!,
        "bloodClucose": HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodGlucose)!,
        "stepCount": HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!,
        "bodyMass": HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!,
        "height": HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!
    ]
    
    internal static let writeTypes = [
        "bloodGlucose": HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodGlucose)!,
    ]
    
    static func requestAuthorizationToShareTypes(completion: (success: Bool, unavailables: [String]) -> Void) {
        if (NSClassFromString("HKHealthStore") != nil && HKHealthStore.isHealthDataAvailable()) {
            store.requestAuthorizationToShareTypes(Set(writeTypes.values),
                readTypes: Set(readTypes.values),
                completion: { (success, error) -> Void in
                    var allAuthorized = true
                    
                    var unavailables = [String]();
                    for (key, value) in writeTypes {
                        // checking authorization of all types, but HealthKit is not provide checking read permission...
                        if store.authorizationStatusForType(value) == .SharingDenied {
                            unavailables.append(key)
                            allAuthorized = false
                        }
                    }
                    
                    completion(success: allAuthorized, unavailables: unavailables)
            })
        } else {
            let alertView = UIAlertView(title: "Not available", message: "This device can't using HealthKit", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }
    }
    
    static var checkCount = 0
    
    static func requestSavingGlucoseSample(glucoseSampleNumber:Double, date:NSDate){
        
        let glucoseType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodGlucose)
//        let milliUnit = HKUnit.moleUnitWithMetricPrefix(HKMetricPrefix.Milli, molarMass: HKUnitMolarMassBloodGlucose)
//        let literUnit = HKUnit.literUnit();
        let milliUnit = HKUnit.gramUnitWithMetricPrefix(HKMetricPrefix.Milli)
        let literUnit = HKUnit.literUnitWithMetricPrefix(HKMetricPrefix.Deci)
        let glucoseQuantity = HKQuantity(unit: milliUnit.unitDividedByUnit(literUnit), doubleValue: glucoseSampleNumber)
        let glucoseSample = HKQuantitySample(type: glucoseType!, quantity: glucoseQuantity, startDate: date, endDate: date)
        
        store.saveObject(glucoseSample, withCompletion: {(success, error) -> Void in
            if (success) {
                debugPrint("success storing glucose")
            }else{
                debugPrint(error)
                HealthManager.checkCount += 1
                if(HealthManager.checkCount > 1){
                    
                }else{
                    HealthManager.requestAuthorizationToShareTypes { (success, unavailables: [String]) -> Void in
                        if success {
                            requestSavingGlucoseSample(glucoseSampleNumber, date: date)
                        } else {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                UIAlertView(title: "Please...", message: String("You must %s authorize all types.", unavailables.joinWithSeparator(", ")), delegate: nil, cancelButtonTitle: "Okay").show()
                            })
                        }
                    }
                }
            }
        })
    }
}
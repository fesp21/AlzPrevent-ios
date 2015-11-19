//
//  Constants.swift
//  researchline
//
//  Created by Leo Kang on 11/19/15.
//  Copyright © 2015 bbb. All rights reserved.
//

import UIKit

class Constants: NSObject {
    // URLs
    static let host = "http://52.8.54.205/"
//    static let host = "http://192.168.0.22:9001/"
    static let login = host + "login_process"
    static let register = host + "api/register/all"
    
    // Device
    static let deviceType = "ios"
    static var deviceKey: String {
        // 서버에서 디바이스를 구분할 수 있도록 고유키를 생성합니다.
        return UIDevice.currentDevice().identifierForVendor!.UUIDString
    }
    
    // Token
    static var signKey: String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        return userDefaults.stringForKey("signKey")
    }
    
    // First, Last Name
    static var firstName: String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        return userDefaults.stringForKey("firstName")
    }
    
    static var lastName: String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        return userDefaults.stringForKey("lastName")
    }
}
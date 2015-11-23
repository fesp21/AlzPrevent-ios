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
//    static let host = "http://52.8.54.205/"
    static let host = "http://192.168.0.12:9001/"
//    static let host = "http://localhost:9001/"
    static let login = host + "login_process"
    static let glucoseLogin = host + "api/glucose/auth"
    static let profile = host + "api/profile"
    static let register = host + "api/register/all"
    static let token = host + "api/register/token"
    static let findPassword = host + "support/reset/password"
    static let todayActivity = host + "api/activity/today"
    static let yesterdayActivity = host + "api/activity/yesterday"
    static let activity = host + "api/activity"
    
    static let urlChangePassword = host + "support/reset/password"
    static let urlFileConsent = host + "file/consent.pdf"

    static let userDefaults = NSUserDefaults.standardUserDefaults()
    
    // Device
    static let deviceType = "ios"
    static var deviceKey: String {
        // 서버에서 디바이스를 구분할 수 있도록 고유키를 생성합니다.
        return UIDevice.currentDevice().identifierForVendor!.UUIDString
    }
    
    // Token
    static var signKey: String? {
        return userDefaults.stringForKey("signKey")
    }
    
    // First, Last Name
    static var username: String {
        return "\(userDefaults.stringForKey("firstName")!) \(userDefaults.stringForKey("lastName")!)"
    }
    
    static var firstName: String {
        return userDefaults.stringForKey("firstName") ?? ""
    }
    
    static var lastName: String {
        return userDefaults.stringForKey("lastName") ?? ""
    }
    
    static var email: String {
        return userDefaults.stringForKey("email") ?? ""
    }
}
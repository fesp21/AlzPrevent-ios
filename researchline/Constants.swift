//
//  Constants.swift
//  researchline
//
//  Created by Leo Kang on 11/19/15.
//  Copyright © 2015 bbb. All rights reserved.
//

import UIKit

class Constants: NSObject {
    static let studyName = "HKU AD"
    
    // URLs
    static let host = "https://researchline.net/"
//    static let host = "http://172.18.99.11:9001/"
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
    static let statistics = host + "api/statistics"
    static let requestVerifyingEmail = host + "support/request/verifying"
    static let checkVerifyingEmail = host + "support/check/verifying"
    static let sendConsentEmail = host + "support/mail/consent"
    static let urlChangePassword = host + "support/reset/password"
    static let changeEmail = host + "support/change/email"
    static let urlFileConsent = host + "file/consent.pdf"
    static let urlFilePrivacy = host + "file/privacy.pdf"

    static var signFileData: UIImage?
    
    static let userDefaults = NSUserDefaults.standardUserDefaults()
    
    // Device
    static let deviceType = "ios"
    static var deviceKey: String {
        // 서버에서 디바이스를 구분할 수 있도록 고유키를 생성합니다.
        return UIDevice.currentDevice().identifierForVendor!.UUIDString
    }
    
    // Token
    static func signKey() -> String {
        return userDefaults.stringForKey("signKey") ?? ""
    }
    
    // First, Last Name
    static func username() -> String {
        return "\(userDefaults.stringForKey("firstName")!) \(userDefaults.stringForKey("lastName")!)"
    }
    
    static func firstName() -> String {
        return userDefaults.stringForKey("firstName") ?? ""
    }
    
    static func lastName() -> String {
        return userDefaults.stringForKey("lastName") ?? ""
    }
    
    static func email() -> String {
        return userDefaults.stringForKey("email") ?? ""
    }
    
    static func registerStep() -> String {
        return userDefaults.stringForKey("registerStep") ?? ""
    }
    
    static let STEP_READY = "step_ready"
    static let STEP_REGISTER = "step_register"
    static let STEP_EMAIL_VERIFICATION = "step_email_verification"
    static let STEP_FINISHED = "step_finished"
    
}
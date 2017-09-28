//
//  CacheUtils.swift
//  iOSSwiftCore
//
//  Created by Mobile on 7/6/16.
//  Copyright © 2016 iOS_Devs. All rights reserved.
//

import UIKit

class CacheUtils: NSObject {

    static let userDefaults: UserDefaults = UserDefaults.standard
    
    /**
     *  For bool value
     */
    class func setBoolValue(_ value: Bool, forKey: String) {
        userDefaults.set(value, forKey: forKey)
        userDefaults.synchronize()
    }
    
    class func getBoolValueForKey(_ key: String) -> Bool {
        return userDefaults.bool(forKey: key)
    }
    
    /**
     *  For integer value
     */
    class func setIntegerValue(_ value: Int, forkey: String) {
        userDefaults.set(value, forKey: forkey)
        userDefaults.synchronize()
    }
    
    class func getIntegerValueForKey(_ key: String) -> Int {
        return userDefaults.integer(forKey: key)
    }
    
    /**
     *  For double value
     */
    class func setDoubleValue(_ value: Double, forKey: String) {
        userDefaults.set(value, forKey: forKey)
        userDefaults.synchronize()
    }
    
    class func getDoubleValueFroKey(_ key: String) -> Double {
        return userDefaults.double(forKey: key)
    }
    
    /**
     *  For floar value
     */
    class func setFloatValue(_ value: Float, forkey: String) {
        userDefaults.set(value, forKey: forkey)
        userDefaults.synchronize()
    }
    
    class func getFloatValueForKey(_ key: String) -> Float {
        return userDefaults.float(forKey: key)
    }
    
    /**
     *  For object value
     */
    class func setObject(_ object: AnyObject, forKey: String) {
        userDefaults.set(object, forKey: forKey)
        userDefaults.synchronize()
    }
    
    class func getObjectForKey(_ key: String) -> AnyObject! {
        return userDefaults.object(forKey: key) as AnyObject!
    }
}

extension CacheUtils
{
    /* Get - Set AuthToken */
    class func setAuthToken(_ authToken: String) {
        setObject(authToken as AnyObject, forKey: "authToken")
    }
    
    class func getAuthToken() -> String? {
        return getObjectForKey("authToken") as? String
    }
    
    /* Get - Set UserId */
    class func setUserId(_ authToken: String) {
        setObject(authToken as AnyObject, forKey: "userId")
    }
    
    class func getUserId() -> String? {
        return getObjectForKey("userId") as? String
    }
    
    /* Get - Set email */
    class func setEmail(_ email : String) {
        setObject(email as AnyObject, forKey: "email")
    }
    
    class func getEmail() -> String? {
        return getObjectForKey("email") as? String
    }
    
    /* Get - Set username */
    class func setUserName(_ userName : String) {
        setObject(userName as AnyObject, forKey: "userName")
    }
    
    class func getUserName() -> String? {
        return getObjectForKey("userName") as? String
    }
    
    /* Get - Set username */
    class func setUserToken(_ token : String) {
        setObject(token as AnyObject, forKey: "userToken")
    }
    
    class func getUserToken() -> String? {
        return getObjectForKey("userToken") as? String
    }
    
    /* Get - Set show tutorial */
    class func setFirstTimeLauchApp() {
        setBoolValue(true, forKey: "firstTimeLauchApp")
    }
    
    class func isTheFirstTimeLauchApp() -> Bool? {
        return getBoolValueForKey("firstTimeLauchApp")
    }
}

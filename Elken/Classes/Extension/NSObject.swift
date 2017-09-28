//
//  NSObject.swift
//  iOSSwiftCore
//
//  Created by Mobile on 7/5/16.
//  Copyright © 2016 iOS_Devs. All rights reserved.
//

import UIKit

public extension NSObject {
    func JSONDictionary() -> [String : Any] {
        var dict = Dictionary<String, Any>()
        
        let mirror = Mirror(reflecting: self)
        
        for child in mirror.children {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        
        var result = [String: Any]()
        for (key, value) in dict {
            result[key] = value
        }
        
        return result
    }
    
    public var nameOfClass: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last ?? ""
    }
    
    func getClassName() -> String {
        return self.nameOfClass
    }
}

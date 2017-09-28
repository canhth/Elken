//
//  ResultExtension.swift
//  iOSSwiftCore
//
//  Created by thcanh on 12/29/16.
//  Copyright © 2016 iOS_Devs. All rights reserved.
//

import Foundation
import RealmSwift

public extension Results {
    
    public func threadSafeObjects() -> [T] {
        var result = [T]()
        for object in self {
            let threadSafeObject = object as! BaseRealmObjectModel
            result.append(threadSafeObject.clone() as! T)
        }
        
        return result
    }
    
    // distinct/ unique objects
    public func uniqueObjects<U : Equatable>(_ paramKey: String, paramType: U.Type) -> [T] {
        var uniqueObjects : [T] = [T]()
        var uniqueKeys : [U] = [U]()
        
        for obj in self {
            if let val = obj.value(forKeyPath: paramKey) {
                let uniqueKey : U = val as! U
                if !uniqueKeys.contains(uniqueKey) {
                    uniqueKeys.append(uniqueKey)
                    uniqueObjects.append(obj)
                }
            }
            
        }
        return uniqueObjects
    }
    
    func toArray() -> [T] {
        return self.map{$0}
    }
}


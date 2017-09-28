//
//  BaseObjectModel.swift
//  iOSSwiftCore
//
//  Created by thcanh on 12/29/16.
//  Copyright © 2016 iOS_Devs. All rights reserved.
//

import UIKit
import RealmSwift

open class BaseRealmObjectModel: Object {
    
    open func clone() -> Self {
        let threadSafeObject = type(of: self).init()
        if let properties = type(of: self).sharedSchema()?.properties {
            
            let object = threadSafeObject as Object
            for property in properties {
                let value = self.value(forKeyPath: property.name)
                object.setValue(value, forKeyPath: property.name)
            }
            
            self.additionClone(threadSafeObject)
        }
        
        return threadSafeObject
    }
    
    open func additionClone(_ cloneObject: BaseRealmObjectModel) {
    }
    
    open func saveToLocal( withRealm realm: Realm? = nil) {
        guard let finalRealm = realm ?? Realm.tryCreate() else {
            return // Should never happen
        }
        
        let object = self.clone()
        
        finalRealm.tryWrite({ () -> Void in
            finalRealm.add(object, update: true)
        })
    }
    open func delete( withRealm realm: Realm? = nil) {
        guard let finalRealm = realm ?? Realm.tryCreate() else {
            return // Should never happen
        }
        
        let obj = self as Object
        
        if let primaryKey = type(of: self).primaryKey(), let value = obj.value(forKeyPath: primaryKey) {
            if let object = finalRealm.object(ofType: type(of: self), forPrimaryKey: value as AnyObject) {
                finalRealm.tryWrite({ () -> Void in
                    finalRealm.delete(object)
                })
            }
        }
    }
    
    open static func deleteAll(_ objects: [BaseRealmObjectModel], withRealm realm: Realm? = nil) {
        for object in objects {
            object.delete(withRealm: realm)
        }
    }
    
    open static func saveAllToLocal(_ objects: [BaseRealmObjectModel], withRealm realm: Realm? = nil) {
        for object in objects {
            object.saveToLocal(withRealm: realm)
        }
    }
    
    open func threadSafeObject() -> Self {
        return self.clone()
    }
}

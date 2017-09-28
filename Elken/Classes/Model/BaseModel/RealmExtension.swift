//
//  RealmExtension.swift
//  iOSSwiftCore
//
//  Created by thcanh on 12/29/16.
//  Copyright © 2016 iOS_Devs. All rights reserved.
//

import RealmSwift

public extension Realm {
    
    public static func tryCreate(_ config: Realm.Configuration? = nil) -> Realm? {
        var realm: Realm? = nil
        do {
            if let config = config {
                realm = try Realm(configuration: config)
            } else {
                realm = try Realm()
            }
            
        } catch let error {
            print("[Realm] Can't create Realm object - error=\(error)")
        }
        
        return realm
    }
    
    public func tryWrite(_ block: () -> Void) {
        do {
            try self.write(block)
        } catch let error {
            print("[Realm] Can't create a Realm transaction - error=\(error)")
        }
    }
}

extension RealmSwift.List {
    
    func toArray() -> [T] {
        return self.map{$0}
    }
}

// Swift 2 Array Extension
extension Array where Element: Equatable {
    mutating func removeObject(_ object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
    mutating func removeObjectsInArray(_ array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
}

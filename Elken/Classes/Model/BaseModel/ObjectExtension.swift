//
//  ObjectExtension.swift
//  iOSSwiftCore
//
//  Created by thcanh on 12/29/16.
//  Copyright © 2016 iOS_Devs. All rights reserved.
//

import UIKit
import RealmSwift

public extension Object {
    public static func deleteAll() {
        let realm = Realm.tryCreate()
        if let result = realm?.objects(self) {
            guard result.count > 0 else {
                return
            }
            
            realm?.tryWrite({ () -> Void in
                realm?.delete(result)
            })
        }
    }
}

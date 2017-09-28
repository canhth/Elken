//
//  Car.swift
//  Elken
//
//  Created by Canh Tran on 9/28/17.
//  Copyright © 2017 Canh Tran. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import RealmSwift

class Car: BaseRealmObjectModel, Mappable  {
    
    dynamic var id = ""
    dynamic var name = ""
    dynamic var brand = ""
    dynamic var price = ""
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name                     <- map["name"]
        brand                    <- map["brand"]
        price                    <- map["price"]
        id                       <- map["id"]
        
    }
    
    public static func getAllCars() -> [Car] {
        
        guard let finalRealm = Realm.tryCreate() else {
            return [] // Should never happen
        }
        
        return finalRealm.objects(Car.self).toArray()
    }
    
    public static func getCarIdWithName(name: String) -> String {
        
        guard let finalRealm = Realm.tryCreate() else {
            return "01" // Should never happen
        }
        
        if let sport = finalRealm.objects(Car.self).filter("name = '\(name)'").first {
            return sport.id
        } else {
            return "01"
        }
    }
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Car.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
}

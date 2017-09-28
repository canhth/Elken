//
//  AppComponents.swift
//  GameOn
//
//  Created by thcanh on 1/14/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

let realm = try! Realm()

open class AppComponents {
    
    open static let sharedInstance = AppComponents()
    
    var userInfo: User!
    var listSports = realm.objects(Sport.self).toArray()
    var listStadiums = realm.objects(Location.self).toArray()
    
    open func setups() {
        if let user = realm.objects(User.self).first {
            userInfo = user
        }
        
        GetDataAPI.getAndUpdateListSports()
        GetDataAPI.getAndUpdateListLocations()
    }
    
    
    func getImageBySport(sportId: String) -> String {
        let sport = listSports.filter({ $0.id == sportId })
        if let object = sport.first {
            return object.icon
        } else {
            return "http://viet.vn09.com/GameOn/app/web/upload/categories/1486443504-42b72e2d9dc97077e9beb31678ee12cd.png"
        }
    }
    
}

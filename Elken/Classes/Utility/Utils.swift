//
//  Utils.swift
//  iOSSwiftCore
//
//  Created by Mobile on 6/17/16.
//  Copyright © 2016 iOS_Devs. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import IQKeyboardManagerSwift

class Utils: NSObject {
    
    static func getRGBA(_ r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return UIColor.init(red: r, green: g, blue: b, alpha: a)
    }
    
    static func getRGB(_ r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    static func configKeyboardManager() {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = (15.0 * RATIO.SCREEN)
        IQKeyboardManager.sharedManager().toolbarManageBehaviour = .bySubviews
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
    }
    
    static func getNavigationController() -> UINavigationController {
        return appDelegate.window?.rootViewController as! UINavigationController
    }
}


public func delay(_ delay:Double, _ closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

public func dispatchBackground(_ block: @escaping ()->()) {
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: block)
}

public func dispatchMain(_ block: @escaping ()->()) {
    DispatchQueue.main.async(execute: block)
}



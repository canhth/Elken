//
//  CommonsProtocol.swift
//  iOSSwiftCore
//
//  Created by Canh Tran on 9/6/17.
//  Copyright © 2017 iOS_Devs. All rights reserved.
//

import UIKit

// For reusable cells
public protocol ReusableView: class { }
public protocol NibLoadableView: class { }

//public extension ReusableView where Self: UIView {
//    static var reuseIdentifier: String {
//        return String(self)
//    }
//}
//
//public extension NibLoadableView where Self: UIView {
//    static var nibName: String {
//        return String(self)
//    }
//}



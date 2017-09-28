//
//  MFLUtilities.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 12/3/15.
//  Copyright © 2015 misfit. All rights reserved.
//

import UIKit

public var mfl_rootViewController: UIViewController? {
    get {
        if let window = UIApplication.shared.delegate?.window {
            return window?.rootViewController
        }
    
        return nil
    }
}

public var mfl_statusBarHeight: CGFloat {
    get {
        return UIApplication.shared.statusBarFrame.size.height
    }
}


//public func <=(left: String, right: String) -> Bool {
//    return false
//}

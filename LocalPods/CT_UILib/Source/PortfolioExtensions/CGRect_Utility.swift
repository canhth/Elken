//
//  CGRect_Utility.swift
//  Portfolio
//
//  Created by Phan Anh Duy on 9/21/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import Foundation

public extension CGRect {
    /**
     get visible of this frame in base view
     */
    public func getVisibleFrameInView(_ baseView: UIView) -> CGRect {
        var visFrame = self
        let widthOfScreen = baseView.bounds.size.width
        let heightOfScreen = baseView.bounds.size.height
        /*
                          ----------
                          | case 3 |
                          |        |
                          ----------
         
                        ---------------
                        |             |
         ----------     |             |   ----------
         | case 2 |     |  base view  |   | case 1 |
         |        |     |             |   |        |
         ----------     |             |   ----------
                        |             |
                        ---------------
         
                          ----------
                          | case 4 |
                          |        |
                          ----------
         
         */
        // case1: this frame is in right of base view
        if visFrame.origin.x > 0 {
            while visFrame.origin.x > widthOfScreen {
                visFrame.origin.x -= widthOfScreen
            }
        } else {
            // case2: this frame is in left of base view
            while visFrame.origin.x < 0 {
                visFrame.origin.x += widthOfScreen
            }
        }
        
        // case4: is in top of base view
        if visFrame.origin.y > 0 {
            while visFrame.origin.y > heightOfScreen {
                visFrame.origin.y -= heightOfScreen
            }
        } else {
            // case4: is in bottom of base view
            while visFrame.origin.y < 0 {
                visFrame.origin.y += heightOfScreen
            }
        }
        
        return visFrame
    }
    
    public var center: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
}

let π = CGFloat.pi

public func DegreesToRadians (_ value:CGFloat) -> CGFloat {
    return value * π / 180.0
}

public func RadiansToDegrees (_ value:CGFloat) -> CGFloat {
    return value * 180.0 / π
}


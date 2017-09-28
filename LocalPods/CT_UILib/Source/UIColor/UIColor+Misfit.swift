//
//  UIColor+Misfit.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 12/3/15.
//  Copyright © 2015 misfit. All rights reserved.
//

import UIKit

//MARK: Constructors
public extension UIColor {
    public convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1.0) {
         self.init(red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: a)
    }
    
    public convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(r: (hex >> 16) & 0xff, g: (hex >> 8) & 0xff, b: hex & 0xff, a: a)
    }
}

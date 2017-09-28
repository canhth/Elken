//
//  UISwitch_Color.swift
//  Portfolio
//
//  Created by david  beckz on 5/19/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import Foundation

public extension UISwitch {
    public func setOnColor(_ color: UIColor) {
        self.onTintColor = color;
    }
    
    public func setOffColor(_ color: UIColor) {
        self.tintColor = color;
        self.backgroundColor = color;
        self.layer.cornerRadius = 16.0;
    }
}

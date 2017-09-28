//
//  UIButton_Utility.swift
//  Portfolio
//
//  Created by david  beckz on 5/19/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import Foundation

public extension UIButton {
    public override func didEnabled(_ enabled: Bool) {
        self.isEnabled = enabled
        if enabled {
            self.alpha = 1.0
        } else {
            self.alpha = 0.3
        }
    }
    
    public func didEnabledWithAlpha(enabled: Bool, alpha: CGFloat) {
        self.isEnabled = enabled
        if enabled {
            self.alpha = 1.0
        } else {
            self.alpha = alpha
        }
    }
}

//
//  UIButtonBarItem.swift
//  Portfolio
//
//  Created by Phan Anh Duy on 7/26/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {
    public func didEnabled(_ enabled: Bool) {
        self.isEnabled = enabled
        if let view = self.customView {
            view.didEnabled(enabled)
        }
    }
    
    
    public func didEnabledWithoutAlpha(enabled: Bool) {
        self.isEnabled = enabled
    }
}

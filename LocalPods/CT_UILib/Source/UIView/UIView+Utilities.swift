//
//  UIView+Utilities.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 12/7/15.
//  Copyright © 2015 misfit. All rights reserved.
//

import UIKit

public extension UIView {
    
    public var mfl_viewController: UIViewController? {
        var parentResponder: UIResponder! = self
        while parentResponder != nil {
            parentResponder = parentResponder.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        
        return nil
    }
    
    @discardableResult
    public func mfl_addBorder(borderWidth: CGFloat = 1,
        color: UIColor = UIColor.black,
        cornerRadius: CGFloat = 0) -> UIView {
            self.layer.borderColor = color.cgColor
            self.layer.borderWidth = borderWidth
            
            self.layer.cornerRadius = cornerRadius
            
            self.clipsToBounds = true
            
            return self
    }
    
    @discardableResult
    public func mfl_addAllBorderToSubview() -> UIView {
        for view in self.subviews {
            view.mfl_addBorder(borderWidth: 1, color: UIColor.yellow)
            view.mfl_addAllBorderToSubview()
        }
        
        self.mfl_addBorder(borderWidth: 1, color: UIColor.yellow)
        
        return self
    }
    
    public func mfl_snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        self.layer.render(in: context!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image!
    }
}

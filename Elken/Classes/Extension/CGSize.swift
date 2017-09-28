//
//  CGSize.swift
//  iOSSwiftCore
//
//  Created by Mobile on 7/13/16.
//  Copyright © 2016 iOS_Devs. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

extension CGSize {
    
    func aspectRatioForWidth(_ newWidth: CGFloat) -> CGSize {
        let newHeight = height * newWidth / width
        return CGSize(width: ceil(newWidth), height: ceil(newHeight))
    }
    
    func aspectRatioForHeight(_ newHeight: CGFloat) -> CGSize {
        let newWidth = width * newHeight / height
        return CGSize(width: ceil(newWidth), height: ceil(newHeight))
    }
    
}


extension UIFont {
    
    static func setFontNameWithSize(size: CGFloat, isBold: Bool) -> UIFont {
        let fontName = isBold ? "Roboto-Bold" : "Roboto-Regular"
        return UIFont(name: fontName, size: (size * CGFloat(ScaleValue.FONT)) )!
    }
}

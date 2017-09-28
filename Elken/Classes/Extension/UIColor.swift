//
//  UIColor.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/5/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(hex: String) {
        self.init(hex: hex, alpha:1)
    }

    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            hexWithoutSymbol = hex.substring(1)
        }
        
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt:UInt32 = 0x0
        scanner.scanHexInt32(&hexInt)
        
        var r:UInt32!, g:UInt32!, b:UInt32!
        switch (hexWithoutSymbol.length) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
            break;
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
            break;
        default:
            // TODO:ERROR
            break;
        }
        
        self.init(
            red: (CGFloat(r)/255),
            green: (CGFloat(g)/255),
            blue: (CGFloat(b)/255),
            alpha:alpha)
    }
    
    static func gameOnBorderColor() -> UIColor {
        return UIColor(hex: "C8C8C8")
    }
    
    static func gameOnButtonGreenColor() -> UIColor {
        return UIColor(hex: "0099FF")
    }
    
    static func gameOnTextColorActive() -> UIColor {
        return UIColor(hex: "444444")
    }
    
    static func gameOnTextColorInActive() -> UIColor {
        return UIColor(hex: "C8C8C8")
    }
    
    static func gameOnLineTextFieldInActive() -> UIColor {
        return UIColor(hex: "E3E3E3")
    }
    
    static func gameOnLineTextFieldError() -> UIColor {
        return UIColor(hex: "C23244")
    }
    
    static func gameOnNormalTextColor() -> UIColor {
        return UIColor(hex: "333333")
    }
    
}

//
//  ThemeUtil.swift
//  Portfolio
//
//  Created by Nga Pham on 10/4/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit
import CocoaLumberjack

public let kFontSizeScaleFromIPhone6: CGFloat = {
    let screenType = MFLScreenSize.CurrentType
    if screenType == .ip6Plus {
        return 1.2
    } else if screenType == .ip4S || screenType == .ip5 {
        return 0.92
    } else {
        return 1
    }
}()

public let kSizeScaleFromIPhone6: CGFloat = {
    let screenType = MFLScreenSize.CurrentType
    if screenType == .ip6Plus {
        return 1.2
    } else if screenType == .ip4S || screenType == .ip5 {
        return 0.92
    } else {
        return 1
    }
}()

open class ThemeUtil: NSObject {
    //MARK:- Font scaled based on phone's size
    open static func font(_ name: String, sizeInIphone6Zeplin: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: sizeInIphone6Zeplin * kFontSizeScaleFromIPhone6) else {
            #if DEBUG
                fatalError("Theme: Missing font: \(name). Will replace with system font")
            #else
                DDLogError("Theme: Missing font: \(name). Will replace with system font")
                return UIFont.systemFont(ofSize: sizeInIphone6Zeplin * kFontSizeScaleFromIPhone6)
            #endif
        }
        return font
    }
    
    open static func lineHeight(_ height: CGFloat) -> CGFloat {
        return height * kFontSizeScaleFromIPhone6
    }
    
    open static func attributedText(_ text: String, lineSpacing: CGFloat? = nil, charSpacing: CGFloat? = nil, alignment: NSTextAlignment? = nil, textColor: UIColor? = nil) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        if lineSpacing != nil {
            paragraphStyle.lineSpacing = lineSpacing!
        }
        if alignment != nil {
            paragraphStyle.alignment = alignment!
        }
        
        var attributes: [String: AnyObject] = [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSKernAttributeName: charSpacing.toZeroIfNil as AnyObject
        ]
        
        if let textColor = textColor {
            attributes[NSForegroundColorAttributeName] = textColor
        }
        
        let attributedText = NSMutableAttributedString(
            string: text,
            attributes: attributes
        )
        return attributedText
    }
    
    open static func attributedText(_ text: String, font: UIFont, lineHeight: CGFloat? = nil, charSpacing: CGFloat? = nil, alignment: NSTextAlignment? = nil, textColor: UIColor? = nil) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        
        if let lineHeight = lineHeight {
            paragraphStyle.lineHeightMultiple = lineHeight / font.pointSize
        }
        
        if let alignment = alignment {
            paragraphStyle.alignment = alignment
        }
        
        var attributes: [String: AnyObject] = [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSKernAttributeName: charSpacing.toZeroIfNil as AnyObject,
            NSFontAttributeName: font
        ]
        
        if let textColor = textColor {
            attributes[NSForegroundColorAttributeName] = textColor
        }
        
        let attributedText = NSMutableAttributedString(
            string: text,
            attributes: attributes
        )
        return attributedText
    }
    
    open static func invertedColor(_ color: UIColor) -> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return UIColor(red: CGFloat(1) - r, green: 1 - g, blue: 1 - b, alpha: a)
    }
    
    open static func estimatedHeightForOneLineText(font: UIFont) -> CGFloat {
        return font.lineHeight + abs(font.descender)
    }
    
    open static func charSpacing(photoshopParams_Tracking tracking: CGFloat, font: UIFont) -> CGFloat {
        return tracking / 1000 * font.pointSize
    }
    
    open static func lineSpacing(photoshopParams_Leading leading: CGFloat, font: UIFont) -> CGFloat {
        return leading / font.pointSize
    }
}

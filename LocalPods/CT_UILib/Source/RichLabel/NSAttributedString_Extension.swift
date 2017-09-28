//
//  KSAttributedStringExt.swift
//  Portfolio
//
//  Created by Khanh Pham on 6/7/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import Foundation

public extension NSAttributedString {
    public class func attributedString(_ text: String, font: UIFont, color: UIColor, textAlignment: NSTextAlignment = .center, charSpacing: CGFloat? = nil, lineHeight: CGFloat? = nil, lineHeightInIphone6Zeplin: CGFloat? = nil, underline: NSUnderlineStyle? = nil) -> NSAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        if let lineHeightInIphone6Zeplin = lineHeightInIphone6Zeplin {
            paragraphStyle.lineHeightMultiple = ThemeUtil.lineHeight(lineHeightInIphone6Zeplin) / font.pointSize
        } else if let lineHeight = lineHeight {
            paragraphStyle.lineHeightMultiple = lineHeight / font.pointSize
        }
        
        var attributes: [String: AnyObject] = [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: color
        ]
        
        if let kern = charSpacing {
            attributes[NSKernAttributeName] = kern as AnyObject
        }
        
        if let _underline = underline {
            attributes[NSUnderlineStyleAttributeName] = _underline.rawValue as AnyObject
        }
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}

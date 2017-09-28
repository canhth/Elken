//
//  LabelStyleInfo.swift
//  Portfolio
//
//  Created by Nga Pham on 10/4/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

// MARK:
public struct LabelStyleInfo {
    public var font: UIFont
    public var textColor: UIColor
    public var invertedTextColor: UIColor
    public var charSpacing: CGFloat
    public var lineSpacing: CGFloat
    public var lineHeight: CGFloat?
    public var textAlignment: NSTextAlignment = .center
    public var scaleOfSubscriptFont: CGFloat = 1
    public var capitalizationOption: TextCapitalizationOption = .none
    public var paragraphLineBreakMode: NSLineBreakMode = .byWordWrapping
    public var highlightedColor: UIColor? = nil
    public var alpha: CGFloat = 1.0
    public var numberOfLines: Int = 1
    
    public init(font: UIFont,
         textColor: UIColor,
         invertedTextColor: UIColor? = nil,
         charSpacing: CGFloat = 0,
         lineSpacing: CGFloat = 1,
         lineHeight: CGFloat? = nil,
         lineHeightInIphone6Zeplin: CGFloat? = nil,
         textAlignment: NSTextAlignment = .center,
         scaleOfSubscriptFont: CGFloat = 1,
         capitalizationOption: TextCapitalizationOption = .none,
         paragraphLineBreakMode: NSLineBreakMode = .byWordWrapping,
         highlightedColor: UIColor? = nil,
         alpha: CGFloat = 1.0,
         numberOfLines: Int = 1)
    {
        self.font = font
        self.textColor = textColor
        self.invertedTextColor = invertedTextColor ?? ThemeUtil.invertedColor(textColor)
        self.charSpacing = charSpacing
        self.lineSpacing = lineSpacing
        self.textAlignment = textAlignment
        self.scaleOfSubscriptFont = scaleOfSubscriptFont
        self.capitalizationOption = capitalizationOption
        self.paragraphLineBreakMode = paragraphLineBreakMode
        self.highlightedColor = highlightedColor
        self.alpha = alpha
        self.numberOfLines = numberOfLines
        if let lineHeight = lineHeightInIphone6Zeplin {
            self.lineHeight = ThemeUtil.lineHeight(lineHeight)
        } else {
            self.lineHeight = lineHeight
        }
    }
    
    
    
    // tnthuyen: Init an raw object
    // Too lazy to pass some required arguments with raw (default) values
    public static func defaultStyle() -> LabelStyleInfo {
        return LabelStyleInfo(font: .systemFont(ofSize: 12), textColor: .clear)
    }
    
    public func getTextAttributes(alignment: NSTextAlignment = NSTextAlignment.left, isInvertedColor: Bool = false) -> [String: AnyObject] {
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        //paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        
        if let lineHeight = self.lineHeight {
            paragraphStyle.lineHeightMultiple = lineHeight / font.pointSize
        }
        
        let attributes: [String: AnyObject] = [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSKernAttributeName: charSpacing as AnyObject,
            NSForegroundColorAttributeName: isInvertedColor ? invertedTextColor : textColor,
            NSFontAttributeName: font
        ]
        
        return attributes
    }
    
    // FIXME: tnthuyen: Duplicate code here (with RichLabel.processAttributedString)
    // Reason: I cannot remove the duplicate since the RichLabel does not hold a labelStyle
    public func makeAttributedString(fromString string: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        if let lineHeight = lineHeight {
            paragraphStyle.lineHeightMultiple = lineHeight / font.pointSize
        }
        
        paragraphStyle.alignment = self.textAlignment
        paragraphStyle.lineBreakMode = self.paragraphLineBreakMode
        
        var defaultAttributes: [String: AnyObject] = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: textColor,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        defaultAttributes[NSKernAttributeName] = charSpacing as AnyObject
        
        let preprocessedString = RichLabel.preprocessString(string, capitalizationOption: capitalizationOption)
        var attributedStr = NSAttributedString(string: preprocessedString, attributes: defaultAttributes)
        
        if let color = highlightedColor {
            attributedStr = RichLabel.processAttributedString(attributedStr, delimiter: RichLabel.kHighlightedMarker, applyAttributes: [NSForegroundColorAttributeName: color])
        }
        
        let subscriptFont = font.fontWithScale(CGFloat(scaleOfSubscriptFont))
        return RichLabel.processAttributedString(attributedStr, delimiter: "_", applyAttributes: [NSFontAttributeName: subscriptFont])
    }
    
}

// MARK: - UIFont
public extension UIFont {
    public func fontWithScale(_ scale: CGFloat) -> UIFont {
        return self.withSize(self.pointSize * CGFloat(scale))
    }
    
    public func estimatedHeightForOneLineText() -> CGFloat {
        return self.lineHeight + abs(self.descender)
    }
}

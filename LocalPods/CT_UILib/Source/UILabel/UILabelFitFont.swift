//
//  File.swift
//  MisfitLink
//
//  Created by Phan Nhu on 1/14/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

open class UILabelFitFont: UILabel {
    var maxFontSize:CGFloat = 14
    var oldText:String?
    
    public init(maxFontSizeValue:CGFloat)
    {
        super.init(frame: CGRect.zero)
        if (maxFontSizeValue > 0)
        {
            maxFontSize = maxFontSizeValue
        }
        
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if (oldText == nil && self.text == nil) {
            return
        }
        
        if (oldText != self.text) {
            self.font = self.fontToFitHeight()
        }
        
        oldText = self.text
        
    }
    
    // Returns an UIFont that fits the new label's height.
    fileprivate func fontToFitHeight() -> UIFont {
        var minSize: CGFloat = 8
        var maxSize: CGFloat = 67
        var fontSizeAverage: CGFloat = 0
        let textAndLabelHeightDiff: CGFloat = 0.2
        let constraintSize = CGSize(width: self.frame.size.width, height: 1000)
        
        while (maxSize - minSize > textAndLabelHeightDiff) {
            fontSizeAverage = minSize / 2 + maxSize / 2
            guard let textRect = (self.text as NSString?)?.boundingRect(with: constraintSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:self.font.withSize(fontSizeAverage)], context: nil) else
            {
                return self.font
            }
            
            let labelSize = textRect.size;
            
            if( labelSize.height >= self.frame.size.height) {
                maxSize = fontSizeAverage
            } else {
                minSize = fontSizeAverage
            }
        }
        
        if (minSize <= maxFontSize)
        {
            return font.withSize(minSize)
        }
        return font.withSize(maxFontSize)
    }
}

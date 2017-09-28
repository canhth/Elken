//
//  ProfileImageFactory.swift
//  Portfolio
//
//  Created by Khanh Pham on 5/17/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit
import Foundation

open class ProfileImageFactory: NSObject {
    
    open class func profileImageWithText(_ text: String,
                                    textAttributes: [String: AnyObject],
                                    borderColor: UIColor,
                                    backgroundColor: UIColor,
                                    diameter: CGFloat,
                                    offset: CGFloat = 0) -> UIImage {
        var newOffset = offset
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        
        let size = CGSize(width: diameter, height: diameter)
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        //// Oval Drawing
        let ovalRect = frame
        let ovalPath = UIBezierPath(ovalIn: ovalRect)
        backgroundColor.setFill()
        ovalPath.fill()
        borderColor.setStroke()
        ovalPath.lineWidth = 1
        ovalPath.stroke()
        
        var ovalFontAttributes = textAttributes
        let attributedString = NSAttributedString(string: text, attributes: ovalFontAttributes)
        
        let drawingOptions: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let estimatedOvalSize: CGSize = attributedString.boundingRect(with: frame.size, options: drawingOptions, context: nil).size
        let charSpacing = ovalFontAttributes[NSKernAttributeName] as? CGFloat ?? 0
        let font: UIFont? = ovalFontAttributes[NSFontAttributeName] as? UIFont
        if newOffset == 0 && font != nil {
            newOffset = abs(estimatedOvalSize.height - font!.lineHeight)
        }
        
        context.saveGState()
        let rectToDraw = CGRect(x: ovalRect.minX + charSpacing / 2, y: ovalRect.minY + (ovalRect.height - estimatedOvalSize.height) / 2 + newOffset, width: ovalRect.width, height: estimatedOvalSize.height)
        context.clip(to: ovalRect)
        
        attributedString.draw(with: rectToDraw, options: drawingOptions, context: nil)
        context.restoreGState()
        
        let profileImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return profileImage ?? UIImage()
    }

}

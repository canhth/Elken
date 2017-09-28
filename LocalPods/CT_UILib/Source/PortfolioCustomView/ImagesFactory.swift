//
//  ImagesFactory.swift
//  Portfolio
//
//  Created by Khanh Pham on 5/25/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

/// Use to draw images, icons
open class ImagesFactory: NSObject {
    
    // MARK: - Drawing methods
    
    open class func drawPlusIcon(size: CGSize, strokeWidth: CGFloat, strokeColor: UIColor) {
        
        //// Frames
        let drawFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        
        //// Plus Drawing
        let plusPath = UIBezierPath()
        plusPath.move(to: CGPoint(x: drawFrame.minX, y: drawFrame.midY))
        plusPath.addLine(to: CGPoint(x: drawFrame.maxX, y: drawFrame.midY))
        plusPath.move(to: CGPoint(x: drawFrame.midX, y: drawFrame.minY))
        plusPath.addLine(to: CGPoint(x: drawFrame.midX, y: drawFrame.maxY))
        strokeColor.setStroke()
        plusPath.lineWidth = strokeWidth
        plusPath.stroke()
    }
    
    // MARK: - Generates images
    
    open class func imageOfPlusIcon(size: CGSize, strokeWidth: CGFloat, strokeColor: UIColor) ->UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        drawPlusIcon(size: size, strokeWidth: strokeWidth, strokeColor: strokeColor)
        
        let imageOfPlusIcon = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageOfPlusIcon ?? UIImage()
    }
    
}

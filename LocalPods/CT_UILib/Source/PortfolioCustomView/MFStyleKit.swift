//
//  MFStyleKit.swift
//  Portfolio
//
//  Created by Khanh Pham on 6/7/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import Foundation

open class MFStyleKit: NSObject {
    
    // MARK: - Drawing
    
    open class func drawImageFromColor(_ fillColor: UIColor, size: CGSize) {
        //// Rectangle Drawing
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        fillColor.setFill()
        path.fill()
    }
    
    open class func drawOvalImageFromColor(_ color: UIColor, size: CGSize) {
        
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        color.setFill()
        ovalPath.fill()
    }
    
    open class func drawDiamondImageFromColor(_ color: UIColor, size: CGSize) {
        
        //// Diamond Drawing
        let path = UIBezierPath()
        path.move(to: CGPoint(x: size.width * 0.5, y: 0))
        path.addLine(to: CGPoint(x: size.width, y: size.height * 0.5))
        path.addLine(to: CGPoint(x: size.width * 0.5, y: size.height))
        path.addLine(to: CGPoint(x: 0, y: size.height * 0.5))
        path.close()
        
        color.setFill()
        path.fill()
    }
    
    open class func drawNavigationBackground(color: UIColor, size: CGSize = CGSize(width: 375, height: 64), borderHeight: CGFloat = 2) {
        
        //// Frames
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        
        //// backgroundRect Drawing
        let backgroundRectPath = UIBezierPath(rect: CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height))
        color.setFill()
        backgroundRectPath.fill()
        
        
        //// borderLine Drawing
        let borderLinePath = UIBezierPath(rect: CGRect(x: 0, y: frame.maxY - borderHeight, width: size.width, height: borderHeight))
        color.setFill()
        borderLinePath.fill()
    }
    
    // MARK: - Images
    
    open class func imageOfNavigationBackground(color: UIColor, size: CGSize = CGSize(width: 375, height: 64), borderHeight: CGFloat = 1) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        drawNavigationBackground(color: color, size: size, borderHeight: borderHeight)
        
        let imageOfNavigationBackground = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageOfNavigationBackground ?? UIImage()
    }
    
    open class func imageFromColor(_ fillColor: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        drawImageFromColor(fillColor, size: size)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
    
    open class func imageOfOvalImageFromColor(_ fillColor: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        drawOvalImageFromColor(fillColor, size: size)
        
        let imageOfBackgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageOfBackgroundImage ?? UIImage()
    }
    
    open class func imageOfDiamondImageFromColor(_ fillColor: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        drawDiamondImageFromColor(fillColor, size: size)
        
        let imageOfBackgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageOfBackgroundImage ?? UIImage()
    }
}

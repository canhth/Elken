//
//  UIImage_Utility.swift
//  Portfolio
//
//  Created by Phan Anh Duy on 6/16/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit
import CocoaLumberjack

public extension UIImage {
    public static func initWithNamed(_ name: String) -> UIImage? {
        return initWithImageNamed(name)
    }
    
    public static func initWithImageNamed(_ name: String) -> UIImage? {
        guard let image = UIImage(named: name) else {
            DDLogError("UIImage_Utility: Missing image: \(name).")
            return nil
        }
        return image
    }
    
    public class func imagePNGFromMainBundle(_ fileName: String) -> UIImage? {
        if let strFile = Bundle.main.path(forResource: fileName, ofType: "png") {
            return UIImage(contentsOfFile: strFile);
        } else {
            return nil;
        }
    }
    
    public class func imageJPGFromMainBundle(_ fileName: String) -> UIImage? {
        if let strFile = Bundle.main.path(forResource: fileName, ofType: "jpg") {
            return UIImage(contentsOfFile: strFile);
        } else {
            return nil;
        }
    }
    
    // merge image-from to this image
    public func mergeFrom(imageFrom: UIImage, yOffset: CGFloat? = nil) -> UIImage? {
        let size = CGSize(width: self.size.width, height: self.size.height)
        if size == CGSize.zero {
            return nil
        } else {
            let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            UIGraphicsBeginImageContext(size)
            self.draw(in: areaSize)
            
            if let _yOffset = yOffset {
                let newSize = CGRect(x: 0, y: _yOffset, width: size.width, height: size.height)
                imageFrom.draw(in: newSize)
            } else {
                imageFrom.draw(in: areaSize)
            }
            
            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
            
            UIGraphicsEndImageContext()
            
            return newImage
        }
    }
    
    public func flipIfIsRTLLanguage() -> UIImage {
        if #available(iOS 9.0, *) {
            return self.imageFlippedForRightToLeftLayoutDirection()
        } else {
            return self
        }
    }
    
    public var flipIfIsRTL: UIImage {
        if #available(iOS 9.0, *) {
            return self.imageFlippedForRightToLeftLayoutDirection()
        } else {
            return self
        }
    }
    
    public func maskWthColor(_ color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, self.scale)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return self
        }
        
        self.draw(in: rect)
        
        context.setFillColor(color.cgColor)
        context.setBlendMode(CGBlendMode.sourceAtop)
        context.fill(rect);
        guard let result: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return self
        }
        
        UIGraphicsEndImageContext()
        return result
    }
}

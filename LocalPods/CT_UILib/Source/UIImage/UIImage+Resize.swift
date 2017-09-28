//
//  UIImage+Resize.m
//
//  Created by Olivier Halligon on 12/08/09.
//  Copyright 2009 AliSoftware. All rights reserved.
//
public extension UIImage {
    
    public var mfl_square: UIImage {
        let edge = min(self.size.width, self.size.height)
        return self.mfl_cropToSize(CGSize(width: edge, height: edge))
    }
    
    public func mfl_resizeIfOutMaxSize(_ maxSize: CGSize, scale: CGFloat = 0) -> UIImage {
        if self.size.width <= maxSize.width && self.size.height <= maxSize.height {
            return self
        }
        
        var width = self.size.width
        var height = self.size.height
        
        if width > maxSize.width {
            height = height * maxSize.width / width
            width = maxSize.width
        }
        
        if height > maxSize.height {
            width = width * maxSize.height / height
            height = maxSize.height
        }
        
        return self.mfl_resizeAspectFillToSize(CGSize(width: width, height: height), scale: scale)
    }
    
    public func mfl_resizeToSize(_ dstSize: CGSize, scale: CGFloat = 0) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(dstSize, false, scale)
        self.draw(in: CGRect(x: 0, y: 0, width: dstSize.width, height: dstSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? UIImage()
    }
    
    public func mfl_resizeAspectFitToSize(_ dstSize: CGSize, scale: CGFloat = 0) -> UIImage {
        let hightScale = dstSize.height / self.size.height
        let widthScale = dstSize.width / self.size.width
        let sizeScale = min(hightScale, widthScale)
        
        let aspectSize = CGSize(width: self.size.width * sizeScale, height: self.size.height * sizeScale)
        return self.mfl_resizeToSize(aspectSize, scale: scale)
    }
    
    public func mfl_resizeAspectFillToSize(_ dstSize: CGSize, scale: CGFloat = 0) -> UIImage {
        let hightScale = dstSize.height / self.size.height
        let widthScale = dstSize.width / self.size.width
        let sizeScale = max(hightScale, widthScale)
        
        let aspectSize = CGSize(width: self.size.width * sizeScale, height: self.size.height * sizeScale)
        
        return self.mfl_resizeToSize(aspectSize, scale: scale).mfl_cropToSize(dstSize)
    }
    
    public func mfl_cropToSize(_ dstSize: CGSize) -> UIImage {
        let startPointX = self.size.width / 2 - dstSize.width / 2
        let startPointY = self.size.height / 2 - dstSize.height / 2
        guard startPointX >= 0 && startPointY >= 0 else {
            return self
        }
        
        if let cgImage = self.cgImage {
            if let cgImage = cgImage.cropping(to: CGRect(x: startPointX, y: startPointY, width: dstSize.width, height: dstSize.height)) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return self
    }
    
    public func mfl_scaleWithRatio(_ ratio: CGFloat, scale: CGFloat = 0) -> UIImage {
        let newSize: CGSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        
        return self.mfl_resizeToSize(newSize, scale: scale)
    }
}

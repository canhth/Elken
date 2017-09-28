//
//  UIIMage.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/5/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func trim(_ trimRect :CGRect) -> UIImage {
        if CGRect(origin: CGPoint.zero, size: self.size).contains(trimRect) {
            if let imageRef = self.cgImage!.cropping(to: trimRect) {
                return UIImage(cgImage: imageRef)
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(trimRect.size, true, self.scale)
        self.draw(in: CGRect(x: -trimRect.minX, y: -trimRect.minY, width: self.size.width, height: self.size.height))
        let trimmedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let image = trimmedImage else { return self }
        
        return image
    }
    
    //////
    
    func resizedImageAspectRatioWithNewWidth(_ newWidth: CGFloat) -> UIImage {
        let newSize = self.size.aspectRatioForWidth(newWidth)
        return resizedImageWithSize(newSize)
    }
    
    func resizedImageWithSize(_ newSize: CGSize) -> UIImage {
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        var newImage: UIImage!
        
        UIGraphicsBeginImageContextWithOptions(newRect.size, false, self.scale);
        self.draw(in: newRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        let data = UIImageJPEGRepresentation(newImage, 0.7)
        return UIImage(data: data!)!
    }
    
    func resizedImageAspectRatioWithNumberBytes(_ numberBytes: Int) -> UIImage {
        let dataImage = UIImageJPEGRepresentation(self, 0.7)
        let newImage = UIImage(data: dataImage!)
        
        let scaleValue = CGFloat((dataImage?.count)!) / (CGFloat(numberBytes) * 0.95)
        let newWidth = newImage!.size.width / scaleValue
        
        return newImage!.resizedImageAspectRatioWithNewWidth(newWidth)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func saveToLocal() {
        
        if let data = UIImageJPEGRepresentation(self, 0.95) {
            let filename = getDocumentsDirectory().appendingPathComponent("profile.png")
            try? data.write(to: filename)
        }
        
    }
    
    class func getImageProfileURL(fileName: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsURL = paths[0]
        let filePath = documentsURL.appendingPathComponent(fileName)
        return filePath
    }
    
    class func getImageProfile(fileName: String) -> UIImage {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsURL = paths[0]
        let filePath = documentsURL.appendingPathComponent(fileName)
        let image  = UIImage(contentsOfFile: filePath.path)
        return image ?? UIImage(named: "ic_avatar")!
    }
}

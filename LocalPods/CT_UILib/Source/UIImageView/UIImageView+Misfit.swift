//
//  UIImageView+Misfit.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 12/3/15.
//  Copyright © 2015 misfit. All rights reserved.
//

import UIKit

//MARK: Properties
public extension UIImageView {
    public var mfl_imageWidth: CGFloat {
        get {
            return self.image?.size.width ?? 0
        }
    }
    
    public var mfl_imageHeight: CGFloat {
        get {
            return self.image?.size.height ?? 0
        }
    }
    
    public var mfl_imageSize: CGSize {
        get {
            return CGSize(width: self.mfl_imageWidth, height: self.mfl_imageHeight)
        }
    }
}

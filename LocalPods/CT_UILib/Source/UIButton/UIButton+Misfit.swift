//
//  UIButton+Misfit.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 12/3/15.
//  Copyright © 2015 misfit. All rights reserved.
//

import UIKit

//MARK: Constructors
public extension UIButton {
    public convenience init(title: String,
        textFont: UIFont = UIFont.systemFont(ofSize: 14),
        textColor: UIColor = UIColor.black,
        backgroundColor: UIColor? = nil,
        highlightColor: UIColor? = nil,
        cornerRadius: CGFloat = 0,
        borderWidth: CGFloat = 0,
        borderColor: UIColor = UIColor.black) {
            self.init(frame: CGRect.zero)
            
            self.setTitle(title, for: UIControlState())
            self.setTitleColor(textColor, for: UIControlState())
            self.titleLabel?.font = textFont
            
            if let bg = backgroundColor {
                self.backgroundColor = bg
            }
            
            if let hi = highlightColor {
                self.setBackgroundImage(UIImage.mfl_fromColor(hi, size: CGSize(width: 1, height: 1)),
                    for: .highlighted)
            }
            
            self.mfl_addBorder(borderWidth: borderWidth, color: borderColor, cornerRadius: cornerRadius)
    }
    
    public convenience init(image: UIImage,
        highlightImage: UIImage) {
        self.init(frame: CGRect.zero)
        
        self.setImage(image, for: UIControlState())
        self.setImage(highlightImage, for: .highlighted)
    }
    
    public convenience init(title: String,
        textFont: UIFont,
        textColorNormal: UIColor,
        textColorSelected: UIColor,
        normalImage: UIImage,
        selectedImage: UIImage,
        highlightColor: UIColor? = nil) {
            self.init(frame: CGRect.zero)
            
            self.setImage(normalImage, for: UIControlState())
            self.setImage(selectedImage, for: UIControlState.selected)
            if highlightColor != nil {
                self.setBackgroundImage(UIImage.mfl_fromColor(highlightColor!, size: CGSize(width: 1, height: 1)), for: UIControlState.highlighted)
            }
            
            self.setTitle(title, for: UIControlState())
            self.setTitleColor(textColorNormal, for: UIControlState())
            self.setTitleColor(textColorSelected, for: .selected)
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.mfl_imageWidth / 2, -self.mfl_imageHeight / 2, 0)
    }
}

//MARK: Properties
public extension UIButton {
    public var mfl_imageWidth: CGFloat {
        get {
            return self.imageView?.image?.size.width ?? 0
        }
    }
    
    public var mfl_imageHeight: CGFloat {
        get {
            return self.imageView?.image?.size.height ?? 0
        }
    }
    
    public var mfl_imageSize: CGSize {
        get {
            return CGSize(width: self.mfl_imageWidth, height: self.mfl_imageHeight)
        }
    }
}

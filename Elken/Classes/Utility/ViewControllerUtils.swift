//
//  ViewControllerUtils.swift
//  GameOn
//
//  Created by thcanh on 1/11/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import UIKit

open class ViewControllerUtils: NSObject {
    open class func setupNavigationBar(_ vc: UIViewController,
                            title: String = "",
                            isTransparent: Bool = false,
                            isDarkBackground: Bool = true,
                            isHideStatusBar: Bool = false,
                            backgroundColor: UIColor = UIColor(hex: "E6E6E6")) {
        //vc.navigationItem.hidesBackButton = true
        
        vc.navigationController?.navigationBar.tintColor = isDarkBackground ? UIColor.white : UIColor.gameOnButtonGreenColor()
        
        vc.navigationController?.isNavigationBarHidden = false
        vc.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if !title.isEmpty {
            
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.setFontNameWithSize(size: 14, isBold: true)
            titleLabel.textColor = isDarkBackground ? UIColor.white : UIColor.black
            titleLabel.numberOfLines = 2
            titleLabel.lineBreakMode = .byTruncatingTail
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.sizeToFit()
            
            vc.navigationItem.titleView = titleLabel
            _ = titleLabel.centerHorizontalParent(0)
        }
        
        
        self.setupNavigationBarTransparent(vc, transparent: isTransparent, isDarkBackground: isDarkBackground, color: backgroundColor)
    }
    
    class func setupNavigationBarTransparent(_ vc: UIViewController, transparent: Bool, isDarkBackground: Bool, color: UIColor? = nil) {
        if transparent || color == nil {
            vc.navigationController?.navigationBar.isTranslucent = true
            vc.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            vc.navigationController?.navigationBar.shadowImage = UIImage()
        } else {
            vc.navigationController?.navigationBar.isTranslucent = false
            vc.navigationController?.navigationBar.setBackgroundImage(self.imageOfNavigationBackground(color: color!), for: UIBarMetrics.default)
            //vc.navigationController?.navigationBar.shadowImage = UIImage()
        }
        
        if isDarkBackground {
            vc.navigationController?.navigationBar.barStyle = .black
            
        } else {
            vc.navigationController?.navigationBar.barStyle = .default
            UIApplication.shared.statusBarStyle = .default
            
        }
    }
    
    class func imageOfNavigationBackground(color: UIColor, size: CGSize =  CGSize.init(width: 375, height: 64), borderHeight: CGFloat = 0) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        drawNavigationBackground(color: color, size: size, borderHeight: borderHeight)
        
        let imageOfNavigationBackground = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageOfNavigationBackground ?? UIImage()
    }
    
    class func drawNavigationBackground(color: UIColor, size: CGSize = CGSize.init(width: 375, height: 64), borderHeight: CGFloat = 0) {
        
        //// Frames
        let frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        
        //// backgroundRect Drawing
        let backgroundRectPath = UIBezierPath(rect: CGRect.init(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height))
        color.setFill()
        backgroundRectPath.fill()
        
        
        //// borderLine Drawing
        let borderLinePath = UIBezierPath(rect: CGRect.init(x:0, y: frame.maxY - borderHeight, width: size.width, height: borderHeight))
        UIColor.white.setFill()
        borderLinePath.fill()
    }
    
    
}

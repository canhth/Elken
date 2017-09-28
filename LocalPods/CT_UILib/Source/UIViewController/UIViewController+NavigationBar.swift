//
//  UIView+NavigationBar.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 11/22/15.
//  Copyright © 2015 MisfitUILib. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    public static var kMFLNavigationBarFontSize: CGFloat {
        get {
            return 17
        }
    }
    
    public var mfl_navigationBarHeight: CGFloat {
        get {
            return self.navigationController?.navigationBar.mfl_height ?? 0
        }
    }
    
    public func mfl_hideBackBarButton() -> UIViewController {
        self.navigationItem.hidesBackButton = true
        
        return self
    }
    
    @discardableResult
    public func mfl_setBackBarButton(text: String = "", color: UIColor? = nil) -> UIViewController {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: text, style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        if color != nil {
            self.navigationController?.navigationBar.tintColor = color
        }
        
        return self
    }
    
    @discardableResult
    public func mfl_setLeftBarButton(_ text: String,
        color: UIColor = UIColor.black,
        highlightColor: UIColor = UIColor.lightGray,
        font: UIFont = UIFont.systemFont(ofSize: UIViewController.kMFLNavigationBarFontSize),
        selector: Selector,
        likeBackButton: Bool = false) -> UIViewController {
            self.navigationItem.hidesBackButton = true
            
            let textAttributes = [NSForegroundColorAttributeName : color,
                NSFontAttributeName : font]
            let highlightTextAttributes = [NSForegroundColorAttributeName : highlightColor,
                NSFontAttributeName : font]
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: text,
                style: UIBarButtonItemStyle.plain,
                target: self,
                action: selector)
            
            self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(textAttributes, for: UIControlState())
            self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(highlightTextAttributes, for: UIControlState.highlighted)
            
            if likeBackButton
                && self.navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) != nil {
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                    self.navigationController?.interactivePopGestureRecognizer?.delegate = (self as! UIGestureRecognizerDelegate)
                    // TODO: figure out way to add recognizer touch gesture
            }
            
            return self
    }
    
    @discardableResult
    public func mfl_setLeftBarButton(_ image: UIImage?,
        selector: Selector,
        likeBackButton: Bool = false) -> UIViewController {
            
            self.navigationItem.hidesBackButton = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: selector)
            
            if likeBackButton
                && self.navigationController?.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) != nil {
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                    self.navigationController?.interactivePopGestureRecognizer?.delegate = (self as! UIGestureRecognizerDelegate)
                    // TODO: figure out way to add recognizer touch gesture
            }
            
            return self
    }
    
    @discardableResult
    public func mfl_setRightBarButton(_ text: String,
        color: UIColor = UIColor.black,
        highlightColor: UIColor = UIColor.lightGray,
        font: UIFont = UIFont.systemFont(ofSize: UIViewController.kMFLNavigationBarFontSize),
        selector: Selector) -> UIViewController {
            let textAttributes = [NSForegroundColorAttributeName : color,
                NSFontAttributeName : font]
            
            let highlightTextAttributes = [NSForegroundColorAttributeName : highlightColor,
                NSFontAttributeName : font]
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: text,
                style: UIBarButtonItemStyle.plain,
                target: self,
                action: selector)
            
            self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(textAttributes, for: UIControlState())
            self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(highlightTextAttributes, for: UIControlState.highlighted)
            
            return self
    }
    
    @discardableResult
    public func mfl_setRightBarButton(_ image: UIImage, selector: Selector) -> UIViewController {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: selector)
        
        return self
    }
    
    @discardableResult
    public func mfl_setTitleBarButton(_ text: String = "",
        color: UIColor = UIColor.black,
        font: UIFont = UIFont.systemFont(ofSize: UIViewController.kMFLNavigationBarFontSize)) -> UIViewController {
            let textAttributes = [NSForegroundColorAttributeName : color,
                NSFontAttributeName : font]
            self.navigationItem.title = text
            self.navigationController?.navigationBar.titleTextAttributes = textAttributes
            return self
    }
    
    @discardableResult
    public func mfl_transparentBar(_ keepLineBreak: Bool = false) -> UIViewController {
        self.navigationController?.navigationBar.mfl_transparentBar(keepLineBreak)
        
        return self
    }
    
    @discardableResult
    public func mfl_setLineBarColor(lineWith: Double = 0.5,
        color: UIColor = UIColor.black) -> UIViewController {
        self.navigationController?.navigationBar.mfl_setLineBarColor(lineWith: lineWith, color: color)
        
        return self
    }
    
    @discardableResult
    public func mfl_turnStatusBarLight(_ on: Bool) -> UIViewController {
        self.navigationController?.navigationBar.mfl_turnStatusBarLight(on)

        return self
    }
}

import ObjectiveC

var MFLAssociatedBorderViewHandle: UInt8 = 0

public extension UINavigationBar {
    
    public var mfl_borderView: UIView? {
        get {
            return objc_getAssociatedObject(self, &MFLAssociatedBorderViewHandle) as? UIView
        }
        
        set {
            objc_setAssociatedObject(self, &MFLAssociatedBorderViewHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @discardableResult
    public func mfl_transparentBar(_ keepLineBreak: Bool = false) -> UINavigationBar {
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.isTranslucent = true
        if (!keepLineBreak) {
            self.shadowImage = UIImage()
        }
        
        self.backgroundColor = UIColor.clear
        
        return self
    }
    
    @discardableResult
    public func mfl_setLineBarColor(lineWith: Double = 0.5,
        color: UIColor = UIColor.black) -> UINavigationBar {
            
            self.mfl_borderView?.removeFromSuperview()
            
            self.mfl_borderView = UIView(frame: CGRect(x: 0, y: self.mfl_height - CGFloat(lineWith),
                width: UIScreen.main.bounds.size.width, height: 1))
            self.mfl_borderView?.backgroundColor = color
            self.addSubview(self.mfl_borderView!)
            
            return self
    }
    
    @discardableResult
    public func mfl_turnStatusBarLight(_ on: Bool) -> UINavigationBar {
        self.barStyle = on ? .black : .default
        
        return self
    }
}

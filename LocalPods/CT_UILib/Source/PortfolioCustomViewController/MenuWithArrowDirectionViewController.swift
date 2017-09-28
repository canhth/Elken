//
//  MenuWithArrowDirectionViewController.swift
//  Portfolio
//
//  Created by Phan Anh Duy on 6/2/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

public enum MenuWithArrowDirectionType: Int {
    case right = 0
    case left
    case up
    case down
}

public enum MenuWithArrowAnimationType: Int {
    case translation = 0
    case scale
}

public protocol MenuWithArrowDelegate: class {
    // Fire when show the menu
    func didShowMenuWithArrow()
    
    // Fire when hide the menu
    func didHideMenuWithArrow()
}

public extension MenuWithArrowDelegate {
    func didShowMenuWithArrow() {
        
    }
    
    func didHideMenuWithArrow() {
        
    }
}

open class MenuWithArrowDirectionViewController: UIViewController, UIGestureRecognizerDelegate {
    // MARK:- constants
    struct constants {
        static let arrowSize: CGSize = CGSize(width: 30, height: 20)
    }
    
    // MARK:- Variables
    fileprivate var anchorType: MenuWithArrowDirectionType = .right
    fileprivate var animationType: MenuWithArrowAnimationType = .scale
    
    fileprivate var baseView: UIView!
    fileprivate var menuView: UIView!
    fileprivate var panGesture: UIPanGestureRecognizer?
    fileprivate var vButtonOutSide: UIView = UIView(frame: CGRect.zero)
    fileprivate var borderLayer: CAShapeLayer?
    
    open var arrowSize: CGSize = constants.arrowSize // by default
    
    open var durationAnimation: TimeInterval = 0.3
    open var borderColor: UIColor = UIColor(red: 231.0 / 255.0, green: 231.0 / 255.0, blue: 231.0 / 255.0, alpha: 1.0)
    
    open weak var delegate: MenuWithArrowDelegate? = nil
    
    open var isShowing: Bool = false
    
    // MARK:-
    public convenience init(anchorType: MenuWithArrowDirectionType, animationType: MenuWithArrowAnimationType = MenuWithArrowAnimationType.translation, menuView: UIView!, baseView: UIView!) {
        self.init()
        self.anchorType = anchorType
        self.animationType = animationType
        self.baseView = baseView
        self.menuView = menuView
        
        // set up gesture on baseview
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(MenuWithArrowDirectionViewController.handleTap(_:)))
        panGesture!.delegate = self
        vButtonOutSide.addGestureRecognizer(panGesture!)
    
        let containerView: UIView = baseView.superview ?? baseView
        vButtonOutSide.frame = containerView.bounds
    }
    
    func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        self.hide()
    }
    
    open func gestureRecognizerShouldBegin(_ gesture: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK:- general functions
    open func show(_ anchorPoint: CGPoint) {
        var arrowPoint: CGPoint = CGPoint.zero
        let path = UIBezierPath()
        
        var transPoint: CGPoint = CGPoint.zero
        switch anchorType {
        case .right:
            transPoint.x = menuView.bounds.size.width - self.arrowSize.height
            
            arrowPoint.x = menuView.bounds.size.width
            arrowPoint.y = anchorPoint.y
            
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: menuView.bounds.size.width - self.arrowSize.height, y: 0))
            path.addLine(to: CGPoint(x: menuView.bounds.size.width - self.arrowSize.height, y: arrowPoint.y - self.arrowSize.width / 2.0))
            path.addLine(to: arrowPoint)
            path.addLine(to: CGPoint(x: menuView.bounds.size.width - self.arrowSize.height, y: arrowPoint.y + self.arrowSize.width / 2.0))
            path.addLine(to: CGPoint(x: menuView.bounds.size.width - self.arrowSize.height, y: menuView.bounds.size.height))
            path.addLine(to: CGPoint(x: 0, y: menuView.bounds.size.height))
            path.addLine(to: CGPoint.zero)
            path.close()
            
            break
            
        case .left:
            transPoint.x = -menuView.bounds.size.width + self.arrowSize.height
            
            arrowPoint.x = 0
            arrowPoint.y = anchorPoint.y
            
            path.move(to: CGPoint(x: self.arrowSize.height, y: 0))
            path.addLine(to: CGPoint(x: menuView.bounds.size.width, y: 0))
            path.addLine(to: CGPoint(x: menuView.bounds.size.width, y: menuView.bounds.size.height))
            path.addLine(to: CGPoint(x: self.arrowSize.height, y: menuView.bounds.size.height))
            path.addLine(to: CGPoint(x: self.arrowSize.height, y: arrowPoint.y + self.arrowSize.width / 2.0))
            path.addLine(to: arrowPoint)
            path.addLine(to: CGPoint(x: self.arrowSize.height, y: arrowPoint.y - self.arrowSize.width / 2.0))
            path.addLine(to: CGPoint(x: self.arrowSize.height, y: 0))
            path.close()
            
            break
            
        case .up:
            transPoint.y = menuView.bounds.size.height
            
            arrowPoint.x = anchorPoint.x
            arrowPoint.y = 0
            break
        
        case .down:
            transPoint.y = -menuView.bounds.size.height
            
            arrowPoint.x = anchorPoint.x
            arrowPoint.y = menuView.bounds.size.height
            break
        }
        
        if let panGesture_ = self.panGesture {
            baseView.addGestureRecognizer(panGesture_)
        }
        
        // clear borderLayer before draw new borderlayer
        self.borderLayer?.removeFromSuperlayer()
        
        // draw boder
        let borderMaskLayer = CAShapeLayer()
        borderMaskLayer.path = path.cgPath
        borderMaskLayer.fillColor = UIColor.clear.cgColor
        borderMaskLayer.strokeColor = self.borderColor.cgColor
        borderMaskLayer.borderWidth = 20
        menuView.layer.addSublayer(borderMaskLayer)
        
        // cache borderLayer
        self.borderLayer = borderMaskLayer
        
        // draw shape with arrow direction
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        menuView.layer.mask = maskLayer
        menuView.clipsToBounds = true
        menuView.layer.masksToBounds = true
        
        if self.animationType == MenuWithArrowAnimationType.scale {
            self.baseView.layoutIfNeeded()
            baseView.addConstraintAlignRightToView(vRelated: baseView.superview!, constant: -self.menuView.bounds.size.width + self.arrowSize.height)
        }
        
        let transformShow: CGAffineTransform = CGAffineTransform(translationX: transPoint.x, y: transPoint.y)
        UIView.animate(withDuration: durationAnimation, animations: { [weak self] _ in
            guard let strongSelf = self else { return }
            
            if strongSelf.animationType == MenuWithArrowAnimationType.scale {
                // scale animation
                strongSelf.baseView.setNeedsLayout()
                strongSelf.baseView.layoutIfNeeded()
            } else {
                // translation animation
                strongSelf.baseView.transform = transformShow
            }
            
            strongSelf.menuView.transform = transformShow
            strongSelf.menuView.alpha = 1.0
            
            }, completion: { [weak self] (isComplete) in
                self?.isShowing = true
                self?.delegate?.didShowMenuWithArrow()
        }) 
    }
    
    open func hide() {
        if let panGesture_ = self.panGesture {
            baseView.removeGestureRecognizer(panGesture_)
        }
        
        if self.animationType == MenuWithArrowAnimationType.scale {
            self.baseView.layoutIfNeeded()
            baseView.addConstraintAlignRightToView(vRelated: baseView.superview!, constant: 0)
        }
        
        let transformHide: CGAffineTransform = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: durationAnimation, animations: { [weak self] _ in
            guard let strongSelf = self else { return }
            
            if strongSelf.animationType == MenuWithArrowAnimationType.scale {
                // scale animation
                strongSelf.baseView.setNeedsLayout()
                strongSelf.baseView.layoutIfNeeded()
            } else {
                // translation animation
                strongSelf.baseView.transform = transformHide
            }
            
            strongSelf.menuView.transform = transformHide
            strongSelf.menuView.alpha = 0.0
            
        }, completion: { [weak self] (isComplete) in
            self?.isShowing = false
            self?.vButtonOutSide.removeFromSuperview()
            self?.delegate?.didHideMenuWithArrow()
        }) 
    }
}

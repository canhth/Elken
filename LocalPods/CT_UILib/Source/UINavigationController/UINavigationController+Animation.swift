//
//  UINavigationController+Animation.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 12/7/15.
//  Copyright © 2015 misfit. All rights reserved.
//

import UIKit

public extension UINavigationController {
    public func mfl_animationPushToViewController(_ viewController: UIViewController,
        duration: TimeInterval = 0.3,
        type: String = kCATransitionMoveIn,
        subType: String = kCATransitionFromBottom,
        timingFunc: CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)) {
            let animation = CATransition()
            animation.duration = duration
            animation.type = type
            animation.subtype = subType
            animation.timingFunction = timingFunc
            self.pushViewController(viewController, animated: false)
            self.view.layer.add(animation, forKey: nil)
    }
    
    public func mfl_animationPop(duration: TimeInterval = 0.3,
        type: String = kCATransitionMoveIn,
        subType: String = kCATransitionFromBottom,
        timingFunc: CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)) {
            let animation = CATransition()
            animation.duration = duration
            animation.type = type
            animation.subtype = subType
            animation.timingFunction = timingFunc
            self.view.layer.add(animation, forKey: nil)
            self.popViewController(animated: false)
    }
    
    public func mfl_animateToViewController(_ viewController: UIViewController) {
        mfl_animationPushToViewController(viewController, duration: 0.3, type: kCATransitionMoveIn, subType: kCATransitionFromRight)
    }
    
    public func mfl_animatePushFromBottomToViewController(_ viewController: UIViewController) {
        self.mfl_animationPushToViewController(viewController, duration: 0.3, type: kCATransitionMoveIn, subType: kCATransitionFromTop)
    }
    
    public func mfl_animatePopByFading() {
        self.mfl_animationPop(duration: 0.5, type: kCATransitionReveal, subType: kCATransitionFade)
    }
    
    public func mfl_animatePopFromTop() {
        self.mfl_animationPop(duration: 0.3, type: kCATransitionReveal, subType: kCATransitionFromBottom)
    }
    
    public func mfl_animatePopFromLeft() {
        self.mfl_animationPop(duration: 0.3, type: kCATransitionMoveIn, subType: kCATransitionFromLeft)
    }
    
    public func mfl_animatePopFromTopToViewController(_ viewController: UIViewController) {
        let indexOfSaveVC: Int = self.viewControllers.index(of: viewController) ?? 0
        var indexToPopNoAnimation: Int = self.viewControllers.count - 1
        while indexToPopNoAnimation > indexOfSaveVC + 1 {
            self.popViewController(animated: false)
            indexToPopNoAnimation -= 1
        }
        
        self.mfl_animationPop(duration: 0.3, type: kCATransitionReveal, subType: kCATransitionFromBottom)
    }
    
    public func mfl_animationPopToViewControllerClass(_ viewControllerClass: AnyClass) -> Bool {
        if let viewController = self.mfl_viewControllerOfClass(viewControllerClass) {
            self.mfl_animatePopFromTopToViewController(viewController)
            return true
        }
        
        return false
    }
    
    public func mfl_viewControllerOfClass(_ viewControllerClass: AnyClass) -> UIViewController? {
        for vc: UIViewController in self.viewControllers {
            if vc.isKind(of: viewControllerClass) {
                return vc
            }
        }
        return nil
    }
}

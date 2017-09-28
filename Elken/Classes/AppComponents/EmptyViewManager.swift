//
//  EmptyViewManager.swift
//  GameOn
//
//  Created by thcanh on 2/8/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import UIKit

class EmptyViewManager: UIView {

    static let sharedInstance = EmptyViewManager()
    
    let view = UIView()
    
    func showEmptyView(viewController: UIViewController, withMessage: String, backgroundColor: UIColor = UIColor.white) {
        if view.superview != nil {
            view.removeFromSuperview()
        }
        view.frame = viewController.view.frame
        view.frame.origin = CGPoint.zero
        view.backgroundColor =  backgroundColor
        
        let label = UILabel()
        label.frame = view.frame
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.setFontNameWithSize(size: 12, isBold: false)
        label.text = withMessage 
        view.addSubview(label) 
        viewController.view.addSubview(view)
        viewController.view.bringSubview(toFront: view)
        
    }
    
    
    func hideEmptyView() {
        UIView.animate(withDuration: 0.2) {
            if self.view.superview != nil {
                self.view.removeFromSuperview()
            }
        }
    }

}

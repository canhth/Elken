//
//  UIAlertController+Misfit.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 12/7/15.
//  Copyright © 2015 misfit. All rights reserved.
//

import Foundation

public typealias MFLAlertControllerHandler = (_ index: Int) -> Void

public extension UIAlertController {
    
    @discardableResult
    public static func mfl_showAlertController(fromController controller: UIViewController? = mfl_rootViewController,
        title: String,
        message: String,
        cancelTitle: String? = nil,
        cancelHandler: (() -> Void)? = nil,
        destructiveTitle: String? = nil,
        destructiveHandler: (() -> Void)? = nil,
        otherTitles: [String] = [String](),
        otherHandler: MFLAlertControllerHandler? = nil,
        type: UIAlertControllerStyle = .alert,
        completion: (() -> Void)? = nil) -> UIAlertController {
            var actions = [UIAlertAction]()
            
            if destructiveTitle != nil {
                let destructiveAction = UIAlertAction(title: destructiveTitle, style: .destructive) { (alertAction) -> Void in
                    destructiveHandler?()
                }
                actions.append(destructiveAction)
            }
            
            for (index, otherTitle) in otherTitles.enumerated() {
                let action = UIAlertAction(title: otherTitle, style: .default, handler: { (alertAction) -> Void in
                    otherHandler?(index)
                })
                
                actions.append(action)
            }
            
            if cancelTitle != nil {
                let cancelAction = UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
                    cancelHandler?()
                }
                
                if type == .alert {
                    actions.insert(cancelAction, at: 0)
                } else {
                    actions.append(cancelAction)
                }
            }
            
            return mfl_showAlertController(fromController: controller, title: title, message: message, actions: actions, type: type, completion: completion)
    }
    
    @discardableResult
    public static func mfl_showAlertController(fromController controller: UIViewController? = mfl_rootViewController,
        title: String,
        message: String,
        actions: [UIAlertAction],
        type: UIAlertControllerStyle = .alert,
        completion: (() -> Void)? = nil) -> UIAlertController {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: type)
            for action in actions {
                alertController.addAction(action)
            }
        
        // Fix crash and support style ActionSheet on iPad
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            if let contentView = controller?.view {
                alertController.popoverPresentationController?.sourceView = contentView
                
                // Set center for popover view
                alertController.popoverPresentationController?.sourceRect = CGRect(x: contentView.bounds.midX, y: contentView.bounds.midY,width: 0,height: 0)
                
                // Remove arrow
                alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            }
        }
            controller?.present(alertController, animated: true, completion: completion)
            return alertController
    }
    
}

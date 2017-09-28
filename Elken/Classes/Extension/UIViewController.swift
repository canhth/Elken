//
//  UIViewControllerExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class func instantiateFromStoryboard() -> Self
    {
        return instantiateFromStoryboardHelper(self, storyboardName: "Main")
    }
    
    class func instantiateFromStoryboard(_ storyboardName: String) -> Self
    {
        return instantiateFromStoryboardHelper(self, storyboardName: storyboardName)
    }
    
    
    func setupBackButton(isBlack style: Bool = false) {
        let image = UIImage(named: style ? "btn_back_black" : "btn_back")!
        let renderedImage = image.withRenderingMode(.alwaysOriginal)
        if let navControl = navigationController {
            if navControl.viewControllers.first != self {
                let backItem = UIBarButtonItem(image: renderedImage, style: .plain, target: self.navigationController, action: #selector(popViewController))
                self.navigationItem.leftBarButtonItem = backItem
            }
        }
    }
    
//    func popViewController(){
//        self.navigationController?.popViewController(animated: true)
//    }
    
    fileprivate class func instantiateFromStoryboardHelper<T>(_ type: T.Type, storyboardName: String) -> T
    {
        var storyboardId = ""
        let components = "\(type(of: type))".components(separatedBy: ".")
        
        if components.count > 1
        {
            storyboardId = components[0]
        }
        let storyboad = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboad.instantiateViewController(withIdentifier: storyboardId) as! T
        
        return controller
    }

    func popViewController() {
        Utils.getNavigationController().popViewController(animated: true)
    }
    
    func popToRootViewController() {
        Utils.getNavigationController().popToRootViewController(animated: true)
    }
    
    func popToViewController(_ viewController: UIViewController) {
        Utils.getNavigationController().popToViewController(viewController, animated: true)
    }
    
    func presentViewController(_ viewController: UIViewController) {
        Utils.getNavigationController().present(viewController, animated: true, completion: nil)
    }
    
  
    func setupAddBarButton() {
        let rightButton = UIButton(type: UIButtonType.custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        
        let image = UIImage(named: "add")!
        let renderedImage = image.withRenderingMode(.alwaysOriginal)
        rightButton.setImage(renderedImage, for: .normal)
        rightButton.addTarget(self, action: #selector(openAddEventScreen), for: UIControlEvents.touchUpInside)
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
  
    
    func openAddEventScreen() {
        
    }
    
    
    
    
    
}

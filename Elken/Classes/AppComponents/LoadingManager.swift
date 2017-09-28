//
//  LoadingManager.swift
//  GameOn
//
//  Created by thcanh on 1/14/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import Foundation
import CT_UILib

open class LoadingManager: Theme_ShowLoadingType {
    
    open static let sharedInstance = LoadingManager()
    
    public func loadingDimView() -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0x000000, a: 0.3)
        return view
    }
    
    public var preferredLoadingSize: CGSize? {
        return nil
    }
    
    public func animationView() -> UIImageView {
        let view = UIImageView()
        var animationImages = [UIImage]()
        for i in 1...9 {
            if let image = UIImage.initWithImageNamed("loader_0\(i)") {
                animationImages.append(image)
            }
        }
        
        for i in 10...69 {
            if let image = UIImage.initWithImageNamed("loader_\(i)") {
                animationImages.append(image)
            }
        }
        
        view.animationImages = animationImages
        view.animationDuration = 1.5
        view.animationRepeatCount = 0
        return view
    }

}

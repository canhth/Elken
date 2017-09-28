//
//  LoadingManager.swift
//  Portfolio
//
//  Created by Hung Le on 7/7/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import Foundation

class LoadingData: NSObject {
    fileprivate(set) var count: Int
    fileprivate(set) var disableInteraction: Bool
    fileprivate(set) var loadingView: UIView?
    fileprivate(set) var dimView: UIView?
    
    init(view: UIView, disable: Bool, dimView: UIView?) {
        self.loadingView = view
        self.count = 1
        self.disableInteraction = disable
        self.dimView = dimView
    }
}

class LoadingManager: NSObject {
    
    fileprivate var dict : [NSValue:LoadingData] = [:]
    
    static let sharedInstance = LoadingManager()

    func showLoadingView(_ viewController : UIViewController, animationView: UIImageView, atBottom: Bool = false, preferredSize: CGSize?, disableInteraction: Bool = false, dimView: UIView?, isShowWindow: Bool = false) {
        
        let iden = NSValue.init(nonretainedObject: viewController)
        if let data = dict[iden] {
            data.count += 1
        } else {
            let data: LoadingData = LoadingData(view: animationView, disable: disableInteraction, dimView: dimView)
            dict[iden] = data
            
            let dimContainerView = isShowWindow ? UIApplication.shared.keyWindow : (viewController.navigationController?.view ?? viewController.view)
            
            if let dimView = dimView, let dimContainerView = dimContainerView {
                dimContainerView.addSubview(dimView)
                dimView.snp.remakeConstraints({ (make) in
                    make.edges.equalTo(0)
                })
            }
            
            viewController.view.addSubview(animationView)
            
            animationView.snp.remakeConstraints { (make) -> Void in
                make.centerX.equalToSuperview()
                if atBottom {
                    make.bottom.equalTo(-20)
                } else {
                    make.centerY.equalToSuperview()
                }
                
                if let preferredSize = preferredSize {
                    make.size.equalTo(preferredSize)
                }
//                make.height.equalTo((animationView.animationImages?.first?.size.height) ?? 20)
//                make.width.equalTo((animationView.animationImages?.first?.size.width) ?? 20)
            }
            
            if disableInteraction {
                dimView?.alpha = 0
                UIView.animate(withDuration: 0.2, animations: {
                    dimView?.alpha = 1.0
                }) 
            }
            
            animationView.startAnimating()
        }
    }
    
    func hideLoadingView(_ viewController : UIViewController) {
        let iden = NSValue.init(nonretainedObject: viewController)
        if let data = dict[iden] {
            data.count -= 1
            if data.count <= 0 {
                data.loadingView?.removeFromSuperview()
                
                if let dimView = data.dimView {
                    dimView.alpha = 1.0
                    UIView.animate(withDuration: 0.2, animations: {
                        dimView.alpha = 0
                    }, completion: { [weak self] _ in
                        dimView.removeFromSuperview()
                        _ = self?.dict.removeValue(forKey: iden)
                    }) 
                } else {
                    dict.removeValue(forKey: iden)
                }
            }
        }
    }
}

public protocol Theme_ShowLoadingType {
    func loadingDimView() -> UIView?
    func animationView() -> UIImageView
    func showLoadingView(_ viewController: UIViewController, atBottom: Bool, disableInteraction: Bool, isShowWindow: Bool)
    func hideLoadingView(_ viewController: UIViewController)
    var preferredLoadingSize: CGSize? { get }
}

public extension Theme_ShowLoadingType {
    func showLoadingView(_ viewController: UIViewController, atBottom: Bool = false, disableInteraction: Bool = false, isShowWindow: Bool = false) {
        let dimView: UIView? = disableInteraction ? loadingDimView() : nil
        LoadingManager.sharedInstance.showLoadingView(viewController, animationView: animationView(), atBottom: atBottom, preferredSize: preferredLoadingSize, disableInteraction: disableInteraction, dimView: dimView, isShowWindow: isShowWindow)
    }
    
    func hideLoadingView(_ viewController: UIViewController) {
        LoadingManager.sharedInstance.hideLoadingView(viewController)
    }
}


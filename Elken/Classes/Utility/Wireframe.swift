//
//  Wireframe.swift
//  GameOn
//
//  Created by thcanh on 1/12/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
    import RxSwift
#endif

#if os(iOS)
    import UIKit
#elseif os(macOS)
    import Cocoa
#endif

enum RetryResult {
    case retry
    case cancel
}

protocol Wireframe {
    func open(_ url: URL)
    func promptFor<Action: CustomStringConvertible>(_ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action>
}


class DefaultWireframe: Wireframe {
    static let sharedInstance = DefaultWireframe()
    
    func open(_ url: URL) {
        #if os(iOS)
            UIApplication.shared.openURL(url)
        #elseif os(macOS)
            NSWorkspace.shared().open(url)
        #endif
    }
    
    #if os(iOS)
    fileprivate static func rootViewController() -> UIViewController {
    // cheating, I know
    return UIApplication.shared.keyWindow!.rootViewController!
    }
    #endif
    
    static func presentAlert(_ message: String) {
        #if os(iOS)
            let alertView = UIAlertController(title: "GameOn", message: message, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in
            })
            rootViewController().present(alertView, animated: true, completion: nil)
        #endif
    }
    
    func promptFor<Action : CustomStringConvertible>(_ message: String, cancelAction: Action, actions: [Action]) -> Observable<Action> {
        #if os(iOS)
            return Observable.create { observer in
                let alertView = UIAlertController(title: "GameOn", message: message, preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: cancelAction.description, style: .cancel) { _ in
                    observer.on(.next(cancelAction))
                })
                
                for action in actions {
                    alertView.addAction(UIAlertAction(title: action.description, style: .default) { _ in
                        observer.on(.next(action))
                    })
                }
                
                DefaultWireframe.rootViewController().present(alertView, animated: true, completion: nil)
                
                return Disposables.create {
                    alertView.dismiss(animated:false, completion: nil)
                }
            }
        #elseif os(macOS)
            return Observable.error(NSError(domain: "Unimplemented", code: -1, userInfo: nil))
        #endif
    }
}


extension RetryResult : CustomStringConvertible {
    var description: String {
        switch self {
        case .retry:
            return "Retry"
        case .cancel:
            return "Cancel"
        }
    }
}

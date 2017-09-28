//
//  KeyboardPresentingHandler.swift
//  Portfolio
//
//  Created by Khanh Pham on 6/22/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import Foundation
import UIKit

/// Handle keyboard present/dismiss by adjust content inset of main UIScrollView
open class KeyboardPresentingHandler: NSObject {
    
    /// Need only 1 instance for an app for current presenting view controller
    open static let sharedInstance = KeyboardPresentingHandler()
    
    fileprivate var scrollView: UIScrollView?
    fileprivate var backgroundView: UIView?
    
    fileprivate var tapGesture: UITapGestureRecognizer!
    
    fileprivate var bottomOffset: CGFloat = 0
    
    override init() {
        super.init()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackgroundView))
        
        // Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open func setupWithScrollView(_ scrollView: UIScrollView?, view: UIView?, bottomOffset: CGFloat = 0) {
        self.scrollView = scrollView
        
        view?.addGestureRecognizer(tapGesture)
        self.backgroundView = view
        
        self.bottomOffset = bottomOffset
    }
    
    func didTapBackgroundView() {
        self.backgroundView?.endEditing(true)
    }
    
    func keyboardWillAppear(_ aNotification: Notification){
        guard let scrollView = scrollView else {
            return
        }
        
        let userInfo: NSDictionary = aNotification.userInfo! as NSDictionary
        let keyboardSize = (userInfo.object(forKey: UIKeyboardFrameBeginUserInfoKey)! as AnyObject).cgRectValue.size
        let contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height - bottomOffset, 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWillDisappear(_ notification: Notification){
        guard let scrollView = scrollView else {
            return
        }
        
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
}

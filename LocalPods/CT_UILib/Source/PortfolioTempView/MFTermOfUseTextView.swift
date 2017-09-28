//
//  MFPrivacyPolicyFooterView.swift
//  Portfolio
//
//  Created by Khanh Pham on 8/29/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

public struct MFTermOfUseTextViewConfigs {
    public var termOfServiceText: String
    public var privacyPolicyText: String
    public var fullContentText: String
    
    public var privacyPolicyURL: URL
    public var termOfServiceURL: URL
    
    public var textAttributes: [String: AnyObject]
    public var linkTextAttributes: [String: AnyObject]
    
    public init(
        termOfServiceText: String,
        privacyPolicyText: String,
        fullContentText: String,
        privacyPolicyURL: URL,
        termOfServiceURL: URL,
        textAttributes: [String: AnyObject],
        linkTextAttributes: [String: AnyObject]) {
        self.termOfServiceText = termOfServiceText
        self.privacyPolicyText = privacyPolicyText
        self.fullContentText = fullContentText
        self.privacyPolicyURL = privacyPolicyURL
        self.termOfServiceURL = termOfServiceURL
        self.textAttributes = textAttributes
        self.linkTextAttributes = linkTextAttributes
    }
}

@IBDesignable
open class MFTermOfUseTextView: UITextView, UITextViewDelegate {
    
    fileprivate var configs: MFTermOfUseTextViewConfigs
    
    fileprivate var termOfUseRange: NSRange!
    fileprivate var privacyRange: NSRange!
    
    public init(configs: MFTermOfUseTextViewConfigs) {
        self.configs = configs
        super.init(frame: CGRect.zero, textContainer: nil)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("public init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        backgroundColor = UIColor.clear
        isScrollEnabled = false
        isEditable = false
        //selectable = false
        isUserInteractionEnabled = true
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
        delegate = self
        
        setupContent()
        //addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedBodyTextView(_:))))
    }
    
    fileprivate func setupContent() {
        
        let attributedString = NSMutableAttributedString(string: configs.fullContentText)
        
        // Apply style for label
        attributedString.addAttributes(configs.textAttributes, range: NSMakeRange(0, attributedString.length))
        
        // Make "privacy policy" as link button
        privacyRange = (configs.fullContentText as NSString).range(of: configs.privacyPolicyText)
        attributedString.addAttribute(NSLinkAttributeName, value: configs.privacyPolicyURL, range: privacyRange)
        
        // Make "terms of use" as link button
        termOfUseRange = (configs.fullContentText as NSString).range(of: configs.termOfServiceText)
        attributedString.addAttribute(NSLinkAttributeName, value: configs.termOfServiceURL, range: termOfUseRange)
        
        attributedString.addAttributes(configs.linkTextAttributes, range: privacyRange)
        attributedString.addAttributes(configs.linkTextAttributes, range: termOfUseRange)
        
        linkTextAttributes = configs.linkTextAttributes
        attributedText = attributedString
    }
    
    open func tappedBodyTextView(_ recognizer: UIGestureRecognizer) {
        guard let textView = recognizer.view as? UITextView else { return }
        
        let layoutManager = textView.layoutManager
        var location = recognizer.location(in: textView)
        if isRightToLeftLanguage {
            location.x -= textView.textContainerInset.right
        } else {
            location.x -= textView.textContainerInset.left
        }
        location.y -= textView.textContainerInset.top
        
        let isOverlappedRanges: (NSRange, _ otherRange: NSRange) -> Bool = { range, otherRange in
            if range.location + range.length < otherRange.location {
                return false
            }
            
            if range.location > otherRange.location + otherRange.length {
                return false
            }
            
            return true
        }
        
        let charIndex = layoutManager.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if charIndex < textView.textStorage.length {
            var range = NSMakeRange(0, 0)
            textView.attributedText.attribute(NSLinkAttributeName, at: charIndex, effectiveRange: &range)
            
            if isOverlappedRanges(range, privacyRange) {
                UIApplication.shared.openURL(configs.privacyPolicyURL)
            } else if isOverlappedRanges(range, termOfUseRange) {
                UIApplication.shared.openURL(configs.termOfServiceURL)
            }
        }
    }
    
    // MARK: - UITextViewDelegate
    open func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        UIApplication.shared.openURL(URL)
        return false
    }
}

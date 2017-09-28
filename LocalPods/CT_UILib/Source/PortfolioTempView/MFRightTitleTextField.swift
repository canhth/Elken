//
//  MFRightTitleTextField.swift
//  Portfolio
//
//  Created by Khanh Pham on 6/21/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

/// UITextField which display placeholder/title on the right when there is any text inputed.
///
/// This also has ability to display left border which a specified color to indicate invalid data inputed.
open class MFRightTitleTextField: UITextField {

    /// Customize default height of text field
    open var inputHeight: CGFloat = 60 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// Indicates textfield should show a floating label on the right when has text inputed or not. Default is true.
    open var shouldShowFloatingLabel: Bool = true
    
    /// Left and right padding of text field. Default is 20.0
    open var inputSidePadding: CGFloat = 20 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The margin between text content and leftView / floatingLabel if any
    open var textMargin: CGFloat = 10 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// Customize animate duration. Default is 0.3
    open var animateDuration: TimeInterval = 0.3
    
    /// Indicates field has error and should show indication
    open var hasError: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// The color of left border to indicates this field has error
    open var errorColor: UIColor = UIColor.white {
        didSet {
            setNeedsLayout()
        }
    }
    
    open var normalSignalColor: UIColor = UIColor.clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// Width of error indicator border
    open var errorBorderWidth: CGFloat = 3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    open var normalSignalBorderWidth: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// Title display when textfield has text inputed
    open var floatingTitle: String? {
        didSet {
            setFloatingLabelText(floatingTitle)
        }
    }
    
    /// The image display in leftView
    open var leftImage: UIImage? {
        didSet {
            leftView = leftImage.map { UIImageView(image: $0) }
            leftViewMode = leftView == nil ? .never : .always
            setNeedsLayout()
        }
    }
    
    /// Set placeholder and floatingTitle
    open func setPlaceholder(_ placeholder: String?, floatingTitle: String?) {
        self.placeholder = placeholder
        setFloatingLabelText(floatingTitle)
    }
    
    fileprivate let floatingLabel = UILabel()
    
    fileprivate let errorLayer = CALayer()
    fileprivate let normalSignalLayer = CALayer()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupComponents()
    }
    
    // MARK: - UITextField
    
    /// Set placeholder and also the floatingTitle
    override open var placeholder: String? {
        didSet {
            floatingTitle = placeholder
        }
    }
    
    override open var attributedPlaceholder: NSAttributedString? {
        didSet {
            if let attributedString = attributedPlaceholder {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = self.mf_textAlignment
            
                let floatingAttributedString = NSMutableAttributedString(attributedString: attributedString)
                floatingAttributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
                floatingLabel.attributedText = floatingAttributedString
            } else {
                floatingLabel.attributedText = attributedPlaceholder
            }
            
            setNeedsLayout()
        }
    }
    
    override open var font: UIFont? {
        didSet {
            floatingLabel.font = font
        }
    }
    
    override open var textColor: UIColor? {
        didSet {
            floatingLabel.textColor = textColor?.colorWithAlpha(0.7)
        }
    }
    
    override open var intrinsicContentSize : CGSize {
        var size = super.intrinsicContentSize
        size.height = inputHeight
        
        return size
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return calculateTextRectForBounds(bounds)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return calculateTextRectForBounds(bounds)
    }
    
    override open func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x = inputSidePadding
        return rect
    }
    
    override open func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x = bounds.width - inputSidePadding - rect.width
        return rect
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let animated = isFirstResponder
        if (text ?? "").isEmpty {   // Is nil or empty
            hideFloatingLabelAnimated(animated)
        } else if shouldShowFloatingLabel {
            showFloatingLabelAnimated(animated)
        }
        
        if hasError {
            configAndShowErrorLayer()
        } else {
            hideErrorLayer()
        }
        
    }
    
    // MARK: - Private
    
    fileprivate func setupComponents() {
        self.mf_textAlignment = .left
        
        floatingLabel.alpha = 0
        floatingLabel.numberOfLines = 3
        floatingLabel.adjustsFontSizeToFitWidth = true
        floatingLabel.mf_textAlignment = .right
        
        addSubview(floatingLabel)
        setFloatingLabelText(placeholder)
        
        layer.addSublayer(normalSignalLayer)
        layer.addSublayer(errorLayer)
        
        hideErrorLayer()
        
        /// Layout ------------------
        floatingLabel.mfl_removeConstraints()
            .mfl_layoutInParent(top: 0, trailing: -inputSidePadding, bottom: 0)
            .mfl_layoutLessThanOrEqual(width: 120)
    }
    
    fileprivate func setFloatingLabelText(_ text: String?) {
        floatingLabel.text = text
        setNeedsLayout()
    }
    
    fileprivate func showFloatingLabelAnimated(_ animated: Bool) {
        let animationOpts = UIViewAnimationOptions([UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseIn])
        UIView.animate(withDuration: animateDuration, delay: 0, options: animationOpts, animations: {
            self.floatingLabel.alpha = 1
            }, completion: nil)
    }
    
    fileprivate func hideFloatingLabelAnimated(_ animated: Bool) {
        let animationOpts = UIViewAnimationOptions([UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseIn])
        UIView.animate(withDuration: animateDuration, delay: 0, options: animationOpts, animations: {
            self.floatingLabel.alpha = 0
            }, completion: nil)
    }
    
    fileprivate func calculateTextRectForBounds(_ bounds: CGRect) -> CGRect {
        var leftMargin = inputSidePadding
        var rightMargin = inputSidePadding
        
        if shouldShowFloatingLabel && (text?.isEmpty == false) {
            let floatingLabelSize = floatingLabel.sizeThatFits(bounds.size)
            
            if self.isRightToLeftLanguage {
                // RTL languages: Arabic, Hebrew...
                // The placeholder has just jumped from right to left
                // --> Should reserve the LEFT space for placeholder
                leftMargin += min(self.bounds.width / 2 - 20, floatingLabelSize.width) + textMargin
            } else {
                // LTR languages: Eng...
                // The placeholder has just jumped from left to right
                // --> Should reserve the RIGHT space for placeholder
                rightMargin += min(self.bounds.width / 2 - 20, floatingLabelSize.width) + textMargin
            }
        } else {
            // Empty input --> do nothing
            // No need to float --> do nothing
        }
        
        if let leftView = leftView {
            if isRightToLeftLanguage {
                rightMargin += leftView.frame.width + textMargin
            } else {
                leftMargin += leftView.frame.width + textMargin
            }
        }
        
        return rectForBounds(bounds, marginLeft: leftMargin, marginRight: rightMargin)
    }
    
    fileprivate func rectForBounds(_ bounds: CGRect, marginLeft: CGFloat = 0, marginRight: CGFloat = 0) -> CGRect {
        return CGRect(x: marginLeft, y: 0, width: bounds.width - marginLeft - marginRight, height: bounds.height)
    }
    
    fileprivate func configAndShowErrorLayer() {
        errorLayer.frame = CGRect(origin: bounds.origin, size: CGSize(width: errorBorderWidth, height: bounds.height))
        errorLayer.backgroundColor = errorColor.cgColor
        errorLayer.isHidden = false
        normalSignalLayer.isHidden = true
    }
    
    fileprivate func hideErrorLayer() {
        normalSignalLayer.frame = CGRect(origin: bounds.origin, size: CGSize(width: normalSignalBorderWidth, height: bounds.height))
        normalSignalLayer.backgroundColor = normalSignalColor.cgColor
        normalSignalLayer.isHidden = false
        errorLayer.isHidden = true
    }

}

//
//  MFInputTextField.swift
//  Portfolio
//
//  Created by Khanh Pham on 9/6/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

open class MFInputTextField: UIView {
    
    fileprivate var textStyle = LabelStyleInfo(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.white)
    fileprivate var placeholderStyle = LabelStyleInfo(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.white)
    fileprivate var errorStyle = LabelStyleInfo(font: UIFont.systemFont(ofSize: 11), textColor: UIColor.red)
    
    open static let kInputFieldHeight = 50
    open static let kErrorMessageLabelHeight = 40
    
    open var hasError: Bool = false {
        didSet {
            errorIndicator.isHidden = !hasError
            errorMessageLabel.isHidden = !hasError
            if hasError == false {
                errorMessageLabel.text = ""
            }
        }
    }
    
    open var title: String = "" {
        didSet {
            textField.placeholder = title
            rightPlaceHolderLabel.text = title
        }
    }
    
    open var textField: UITextField = {
        let view = UITextField()
        view.autocorrectionType = .default
        return view
    }()
    
    open var rightPlaceHolderLabel: RichLabel = {
        let view = RichLabel()
        view.textAlignment = .right
        view.isHidden = true // By default
        return view
    }()
    
    open var clearButton: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor.lightGray
        view.isUserInteractionEnabled = true
        view.isHidden = true
        return view
    }()
    
    open var errorIndicator: RichLabel = {
        let label = RichLabel()
        label.isHidden = true // By default
        return label
    }()
    
    open var mainInputView: UIView = {
        let view = UIView()
        return view
    }()
    
    open var errorMessageLabel: RichLabel = {
        let label = RichLabel()
        label.textAlignment = .center
        return label
    }()
    
    open var inputHeight: CGFloat = CGFloat(MFInputTextField.kInputFieldHeight) {
        didSet {
            setNeedsLayout()
        }
    }
    
    open func updateTextStyle(_ style: LabelStyleInfo) {
        textStyle = style
        textField.textColor = style.textColor
        textField.font = style.font
    }
    
    open func updatePlaceholderStyle(_ style: LabelStyleInfo) {
        rightPlaceHolderLabel.textColor = style.textColor
        rightPlaceHolderLabel.font = style.font
        textField.attributedPlaceholder = NSAttributedString(string: title,
                                                             attributes:[NSForegroundColorAttributeName: style.textColor,
                                                                         NSFontAttributeName: style.font])
    }
    
    open func updateErrorStyle(_ style: LabelStyleInfo) {
        errorStyle = style
        // tnthuyen: Should we use .applyStyle(errorStyle)
        // In that case, how to change placeholder to adapt to the style
        errorIndicator.backgroundColor = style.textColor
        
        errorMessageLabel.textColor = style.textColor
        errorMessageLabel.font = style.font
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        mainInputView.addSubview(textField)
        mainInputView.addSubview(rightPlaceHolderLabel)
        mainInputView.addSubview(errorIndicator)
        mainInputView.addSubview(clearButton)
        
        self.addSubview(mainInputView)
        self.addSubview(errorMessageLabel)
        
        updateTextStyle(textStyle)
        updatePlaceholderStyle(placeholderStyle)
        updateErrorStyle(errorStyle)
        
        clearButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapClearButton(_:))))
        let tapGestureRecgonizer = UITapGestureRecognizer(target: self, action: #selector(tappedView(_:)))
        addGestureRecognizer(tapGestureRecgonizer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("public init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        // FIXME: need update layout contraints textField
        textField.snp.remakeConstraints { (make) -> Void in
            make.leading.equalTo(textField.superview!).offset(20)
            make.centerY.equalTo(textField.superview!)
            make.width.equalTo(textField.superview!).multipliedBy(0.66).offset(-20)
            make.height.equalTo(textField.superview!)
        }
        
        rightPlaceHolderLabel.snp.remakeConstraints { (make) -> Void in
            make.leading.equalTo(textField.snp.trailing)
            make.centerY.equalTo(rightPlaceHolderLabel.superview!)
            make.trailing.equalTo(rightPlaceHolderLabel.superview!).offset(-20)
            make.height.equalTo(rightPlaceHolderLabel.superview!)
        }
        
        clearButton.snp.remakeConstraints { (make) in
            make.trailing.equalTo(rightPlaceHolderLabel)
            make.centerY.equalTo(rightPlaceHolderLabel)
        }
        
        errorIndicator.snp.remakeConstraints { (make) -> Void in
            make.leading.equalTo(errorIndicator.superview!)
            make.width.equalTo(1)
            make.height.equalTo(errorIndicator.superview!)
            make.centerY.equalTo(errorIndicator.superview!)
        }
        
        mainInputView.snp.remakeConstraints { (make) -> Void in
            make.width.equalTo(mainInputView.superview!)
            make.height.equalTo(inputHeight)
            make.top.equalTo(mainInputView.superview!)
            make.centerX.equalTo(mainInputView.superview!)
        }
        
        errorMessageLabel.snp.remakeConstraints { (make) -> Void in
            make.centerX.equalTo(errorMessageLabel.superview!)
            make.height.equalTo(MFInputTextField.kErrorMessageLabelHeight)
            make.width.equalTo(errorMessageLabel.superview!)
            make.top.equalTo(mainInputView.snp.bottom)
        }
    }
    
    override open func layoutSubviews() {
        setupLayout()
        
        super.layoutSubviews()
    }
    
    open func tappedView(_ sender: AnyObject?) {
        self.textField.becomeFirstResponder()
    }
    
    open func didTapClearButton(_ sender: AnyObject?) {
        self.textField.text = ""
    }
}

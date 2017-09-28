//
//  MFGenderInputView.swift
//  Portfolio
//
//  Created by Khanh Pham on 6/22/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

public enum Gender: String {
    case male = "M"
    case female = "F"
    case other = "O"
    case na = "NA"
}

open class MFGenderInputView: UIControl {
    
    open var maleTitle: String? {
        didSet {
            updateTitles()
        }
    }
    
    open var femaleTitle: String? {
        didSet {
            updateTitles()
        }
    }
    
    open var otherTitle: String? {
        didSet {
            updateTitles()
        }
    }
    
    open var titleFont: UIFont? {
        didSet {
            updateLabelStyleInfo()
        }
    }
    
    open var titleColor: UIColor? {
        didSet {
            updateLabelStyleInfo()
        }
    }
    
    open var titleStyleInfo: LabelStyleInfo? {
        didSet {
            updateTitles()
        }
    }
    
    open var selectedTitleStyleInfo: LabelStyleInfo? {
        didSet {
            updateTitles()
        }
    }
    
    open var normalColor: UIColor = UIColor.lightGray {
        didSet {
            updateButtons()
        }
    }
    
    open var selectedColor: UIColor = UIColor.gray {
        didSet {
            updateButtons()
        }
    }
    
    /// Selected value
    open var selectedValue: Gender? {
        didSet {
            updateButtons()
            sendActions(for: .valueChanged)
        }
    }
    
    open var otherGenderAvailable: Bool = false {
        didSet {
            setupLayout()
        }
    }
    
    fileprivate func updateButtons() {
        maleGenderButton.normalColor = (selectedValue == .male ? selectedColor : normalColor)
        femaleGenderButton.normalColor = (selectedValue == .female ? selectedColor : normalColor)
        otherGenderButton.normalColor = (selectedValue == .other ? selectedColor : normalColor)
    }
    
    fileprivate func updateTitles() {
        if let titleInfo = titleStyleInfo {
            maleGenderButton.setAttributedTitle(NSAttributedString(string: maleTitle ?? "", attributes: titleInfo.getTextAttributes()), for: UIControlState())
            femaleGenderButton.setAttributedTitle(NSAttributedString(string: femaleTitle ?? "", attributes: titleInfo.getTextAttributes()), for: UIControlState())
            otherGenderButton.setAttributedTitle(NSAttributedString(string: otherTitle ?? "", attributes: titleInfo.getTextAttributes()), for: UIControlState())
        } else {
            maleGenderButton.setAttributedTitle(nil, for: UIControlState())
            femaleGenderButton.setAttributedTitle(nil, for: UIControlState())
            otherGenderButton.setAttributedTitle(nil, for: UIControlState())
        }
        
        if let titleInfo = selectedTitleStyleInfo {
            maleGenderButton.setAttributedTitle(NSAttributedString(string: maleTitle ?? "", attributes: titleInfo.getTextAttributes()), for: .selected)
            femaleGenderButton.setAttributedTitle(NSAttributedString(string: femaleTitle ?? "", attributes: titleInfo.getTextAttributes()), for: .selected)
            otherGenderButton.setAttributedTitle(NSAttributedString(string: otherTitle ?? "", attributes: titleInfo.getTextAttributes()), for: .selected)
        } else {
            maleGenderButton.setAttributedTitle(nil, for: .selected)
            femaleGenderButton.setAttributedTitle(nil, for: .selected)
            otherGenderButton.setAttributedTitle(nil, for: .selected)
        }
    }
    
    fileprivate func updateLabelStyleInfo() {
        if titleFont != nil && titleColor != nil {
            titleStyleInfo = LabelStyleInfo(font: titleFont!, textColor: titleColor!)
            selectedTitleStyleInfo = LabelStyleInfo(font: titleFont!, textColor: titleColor!)
        } else {
            titleStyleInfo = nil
            selectedTitleStyleInfo = nil
        }
    }
    

    fileprivate let maleGenderButton: BackgroundHighlightButton = {
        let button = BackgroundHighlightButton()
        button.titleLabel?.textAlignment = .center
        button.setTitle("Male", for: .normal)
        return button
    }()
    
    fileprivate let femaleGenderButton: BackgroundHighlightButton = {
        let button = BackgroundHighlightButton()
        button.titleLabel?.textAlignment = .center
        button.setTitle("Female", for: .normal)
        
        return button
    }()
    
    fileprivate let otherGenderButton: BackgroundHighlightButton = {
        let button = BackgroundHighlightButton()
        button.titleLabel?.textAlignment = .center
        
        return button
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("public init(coder:) has not been implemented")
    }
    
    public struct Configs {
        public var ContentPadding: CGFloat = 0
        public var ContentSpacing: CGFloat = 1
        public init(ContentPadding: CGFloat = 0, ContentSpacing: CGFloat = 1) {
            self.ContentPadding = ContentPadding
            self.ContentSpacing = ContentSpacing
        }
    }
    
    open var configs = Configs() {
        didSet {
            setupLayout()
        }
    }
    
    fileprivate func setupComponents() {
        addSubview(maleGenderButton)
        addSubview(femaleGenderButton)
        addSubview(otherGenderButton)
        
        setupLayout()
        
        maleGenderButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        femaleGenderButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        otherGenderButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
    }
    
    fileprivate func setupLayout() {
        maleGenderButton.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(configs.ContentPadding)
            make.right.equalTo(femaleGenderButton.snp.left).offset(-configs.ContentSpacing)
            make.top.equalTo(configs.ContentPadding)
            make.bottom.equalTo(-configs.ContentPadding)
        }
        
        if otherGenderAvailable {
            femaleGenderButton.snp.remakeConstraints { (make) -> Void in
                make.top.equalTo(configs.ContentPadding)
                make.right.equalTo(otherGenderButton.snp.left).offset(-configs.ContentSpacing)
                make.bottom.equalTo(-configs.ContentPadding)
                make.width.equalTo(maleGenderButton.snp.width)
            }
            
            otherGenderButton.snp.remakeConstraints { (make) -> Void in
                make.top.equalTo(configs.ContentPadding)
                make.right.equalTo(-configs.ContentPadding)
                make.bottom.equalTo(-configs.ContentPadding)
                make.width.equalTo(maleGenderButton.snp.width)
            }
        } else {
            femaleGenderButton.snp.remakeConstraints { (make) -> Void in
                make.top.equalTo(configs.ContentPadding)
                make.right.equalTo(-configs.ContentPadding)
                make.bottom.equalTo(-configs.ContentPadding)
                make.width.equalTo(maleGenderButton.snp.width)
            }
        }
    }
    
    
    func genderButtonTapped(_ button: BackgroundHighlightButton) {
        if button == maleGenderButton {
            selectedValue = .male
        } else if button == femaleGenderButton {
            selectedValue = .female
        } else if button == otherGenderButton {
            selectedValue = .other
        }
    }
    
}

//
//  TwoColumnPickerController.swift
//  Portfolio
//
//  Created by Thuyen Trinh on 3/3/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

public protocol TwoColumnPickerControllerDelegate: class {
    func twoColumnPickerController(
        _ controller: TwoColumnPickerController, didUpdatePickerColumnOneValue columnOneValue: String, didUpdatePickerColumnTwoValue columnTwoValue: String)
}


open class TwoColumnPickerController: UIViewController {
    fileprivate let kPaddingHeader: CGFloat = 28.0
    fileprivate let kPaddingFooter: CGFloat = 28.0
    
    open weak var delegate: TwoColumnPickerControllerDelegate?
    
    open var header: String = "" {
        didSet {
            headerLabel.text = header
        }
    }
    
    open var footer: String = "" {
        didSet {
            footerLabel.text = footer
        }
    }
    
    open var leftValues: [String] = [] {
        didSet {
            leftVerticalScrollView.values = leftValues
        }
    }
    
    open var selectedLeftValue: String = "" {
        didSet {
            leftVerticalScrollView.updateToValue(selectedLeftValue, animate: false)
        }
    }
    
    open var rightValues: [String] = [] {
        didSet {
            rightVerticalScrollView.values = rightValues
        }
    }
    
    open var selectedRightValue: String = "" {
        didSet {
            rightVerticalScrollView.updateToValue(selectedRightValue, animate: false)
        }
    }
    
    open var numberOfVisibleValues: Int = 3 {
        didSet {
            leftVerticalScrollView.updateToValue(selectedLeftValue, animate: false)
            rightVerticalScrollView.updateToValue(selectedRightValue, animate: false)
        }
    }
    
    /// Config picker
    open var pickerViewSettings: UISettings_PickerView = UISettings_PickerView.defaultSetting() {
        didSet {
            updatePickerSettings()
        }
    }
    
    open let headerLabel: RichLabel = {
        let label = RichLabel()
        label.textAlignment = .center
        return label
    }()
    
    open let footerLabel: RichLabel = {
        let label = RichLabel()
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let leftVerticalScrollView: VerticalScrollView = {
        let scrollView = VerticalScrollView()
        
        return scrollView
    }()
    
    fileprivate let rightVerticalScrollView: VerticalScrollView = {
        let scrollView = VerticalScrollView()
        
        return scrollView
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
        updatePickerSettings()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        leftVerticalScrollView.numberOfVisibleValues = numberOfVisibleValues
        rightVerticalScrollView.numberOfVisibleValues = numberOfVisibleValues
    }
    
    fileprivate func updatePickerSettings() {
        headerLabel.font = pickerViewSettings.labelStyle_Unit.font
        headerLabel.textColor = pickerViewSettings.labelStyle_Unit.textColor
        headerLabel.lineHeight = pickerViewSettings.labelStyle_Unit.lineHeight
        footerLabel.font = pickerViewSettings.labelStyle_ValueDescription.font
        footerLabel.textColor = pickerViewSettings.labelStyle_ValueDescription.textColor
        footerLabel.lineHeight = pickerViewSettings.labelStyle_ValueDescription.lineHeight
        leftVerticalScrollView.font = pickerViewSettings.labelStyle_SelectedValue.font
        leftVerticalScrollView.textColor = pickerViewSettings.labelStyle_SelectedValue.textColor
        rightVerticalScrollView.font = pickerViewSettings.labelStyle_SelectedValue.font
        rightVerticalScrollView.textColor = pickerViewSettings.labelStyle_SelectedValue.textColor
    }

    //MARK: - Layout
    
    fileprivate func setupView() {
        view.backgroundColor = UIColor.clear
        
        view.addSubview(headerLabel)
        view.addSubview(leftVerticalScrollView)
        view.addSubview(rightVerticalScrollView)
        view.addSubview(footerLabel)
        
        leftVerticalScrollView.delegate = self
        leftVerticalScrollView.layoutAlign = .right
        rightVerticalScrollView.delegate = self
        rightVerticalScrollView.layoutAlign = .left
    }
    
    fileprivate func setupLayout() {
        headerLabel.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp.top).offset(20)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(self.view.snp.width)
        }
        
        leftVerticalScrollView.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(self.headerLabel.snp.bottom).offset(kPaddingHeader)
            make.right.equalTo(self.rightVerticalScrollView.snp.left)
            make.width.equalTo(self.view.snp.width).multipliedBy(0.5)
            make.bottom.equalTo(self.footerLabel.snp.bottom).offset(-kPaddingFooter)
        }
        
        rightVerticalScrollView.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(self.leftVerticalScrollView.snp.top)
            make.left.equalTo(self.view.snp.centerX)
            make.width.equalTo(self.view.snp.width).multipliedBy(0.5)
            make.bottom.equalTo(self.leftVerticalScrollView.snp.bottom)
        }
        
        footerLabel.snp.remakeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(self.view.snp.width).multipliedBy(0.8)
            make.bottom.equalTo(self.view.snp.bottom).offset(-20)
            make.height.greaterThanOrEqualTo(24)
        }
    }
}

//MARK: - Delegate
extension TwoColumnPickerController: VerticalScrollViewDelegate {
    
    func verticalScrollView(_ view: VerticalScrollView, didUpdateToValue value: String) {
        let leftValue = leftVerticalScrollView.currentValue ?? selectedLeftValue
        let rightValue = rightVerticalScrollView.currentValue ?? selectedRightValue
        
        delegate?.twoColumnPickerController(
            self,
            didUpdatePickerColumnOneValue: leftValue,
            didUpdatePickerColumnTwoValue: rightValue
        )
    }
}

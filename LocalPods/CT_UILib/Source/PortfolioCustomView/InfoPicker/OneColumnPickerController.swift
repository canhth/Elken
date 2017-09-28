//
//  OneColumnPickerController.swift
//  Portfolio
//
//  Created by Thuyen Trinh on 3/3/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

public struct UISettings_PickerView {
    public var labelStyle_Unit: LabelStyleInfo = LabelStyleInfo(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.clear, lineHeightInIphone6Zeplin: 16)
    public var labelStyle_SelectedValue: LabelStyleInfo = LabelStyleInfo(font: UIFont.systemFont(ofSize: 60), textColor: UIColor.clear)
    public var labelStyle_UpcomingValue: LabelStyleInfo = LabelStyleInfo(font: UIFont.systemFont(ofSize: 60), textColor: UIColor.clear)
    public var labelStyle_ValueDescription: LabelStyleInfo = LabelStyleInfo(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.clear)
    
    public init(
        labelStyle_Unit: LabelStyleInfo,
        labelStyle_SelectedValue: LabelStyleInfo,
        labelStyle_UpcomingValue: LabelStyleInfo,
        labelStyle_ValueDescription: LabelStyleInfo
        )
    {
        self.labelStyle_Unit = labelStyle_Unit
        self.labelStyle_SelectedValue = labelStyle_SelectedValue
        self.labelStyle_UpcomingValue = labelStyle_UpcomingValue
        self.labelStyle_ValueDescription = labelStyle_ValueDescription
    }
    
    public static func defaultSetting() -> UISettings_PickerView {
        
        return UISettings_PickerView(
            labelStyle_Unit: LabelStyleInfo(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.lightGray, lineHeightInIphone6Zeplin: 16),
            labelStyle_SelectedValue: LabelStyleInfo(font: UIFont.systemFont(ofSize: 66), textColor: UIColor.gray),
            labelStyle_UpcomingValue: LabelStyleInfo(font: UIFont.systemFont(ofSize: 66), textColor: UIColor.lightGray),
            labelStyle_ValueDescription: LabelStyleInfo(font: UIFont.systemFont(ofSize: 14), textColor: UIColor.lightGray, lineHeightInIphone6Zeplin: 16)
        )
    }
}

public protocol OneColumnPickerControllerDelegate: class {
    func oneColumnPickerController(_ controller: OneColumnPickerController, didUpdatePickerValue value: String)
}

open class OneColumnPickerController: UIViewController {
    
    fileprivate let kPaddingHeader: CGFloat = 28.0
    fileprivate let kPaddingFooter: CGFloat = 28.0
    

    open weak var delegate: OneColumnPickerControllerDelegate?
    
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
    
    open var values: [String] = [] {
        didSet {
            verticalScrollView.values = values
        }
    }
    
    open var selectedValue: String = "" {
        didSet {
            verticalScrollView.updateToValue(selectedValue, animate: false)
        }
    }
    
    open var numberOfVisibleValues: Int = 3 {
        didSet {
            verticalScrollView.updateToValue(selectedValue, animate: false)
        }
    }
    
    open var pickerViewSettings: UISettings_PickerView = UISettings_PickerView.defaultSetting() {
        didSet {
            updatePickerSettings()
        }
    }
    
    open var headerLabel: RichLabel = {
        let label = RichLabel()
        label.textAlignment = .center
        return label
    }()
    
    open let footerLabel: RichLabel = {
        let label = RichLabel()
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let verticalScrollView: VerticalScrollView = {
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

        verticalScrollView.numberOfVisibleValues = numberOfVisibleValues
    }
    
    fileprivate func updatePickerSettings() {
        let text = headerLabel.text
        headerLabel = RichLabel(style: pickerViewSettings.labelStyle_Unit)
        headerLabel.text = text
        headerLabel.textAlignment = .center
        headerLabel.font = pickerViewSettings.labelStyle_Unit.font
        headerLabel.textColor = pickerViewSettings.labelStyle_Unit.textColor
        headerLabel.lineHeight = pickerViewSettings.labelStyle_Unit.lineHeight

        footerLabel.font = pickerViewSettings.labelStyle_ValueDescription.font
        footerLabel.textColor = pickerViewSettings.labelStyle_ValueDescription.textColor
        footerLabel.lineHeight = pickerViewSettings.labelStyle_ValueDescription.lineHeight
        verticalScrollView.font = pickerViewSettings.labelStyle_SelectedValue.font
        verticalScrollView.textColor = pickerViewSettings.labelStyle_SelectedValue.textColor
    }

    //MARK: - Layout
    
    fileprivate func setupView() {
        view.backgroundColor = UIColor.clear
        
        view.addSubview(headerLabel)
        view.addSubview(verticalScrollView)
        view.addSubview(footerLabel)
        
        verticalScrollView.delegate = self
    }
    
    fileprivate func setupLayout() {
        headerLabel.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(self.view.snp.top).offset(20)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(self.view.snp.width).multipliedBy(0.8)
            //make.height.equalTo(30)
        }
        
        verticalScrollView.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(self.headerLabel.snp.bottom).offset(kPaddingHeader)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.footerLabel.snp.bottom).offset(-kPaddingFooter)
        }
        
        footerLabel.snp.remakeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(self.view.snp.width).multipliedBy(0.8)
            make.bottom.equalTo(self.view.snp.bottom).offset(-20)
            make.height.greaterThanOrEqualTo(24)
        }
    }
}

//MARK: - VerticalScrollViewDelegate
extension OneColumnPickerController: VerticalScrollViewDelegate {
    
    func verticalScrollView(_ view: VerticalScrollView, didUpdateToValue value: String) {
        delegate?.oneColumnPickerController(self, didUpdatePickerValue: value)
    }
}

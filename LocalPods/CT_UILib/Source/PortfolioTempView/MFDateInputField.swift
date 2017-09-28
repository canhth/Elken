//
//  MFDateInputField.swift
//  Portfolio
//
//  Created by Khanh Pham on 6/22/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit
import RxSwift

open class MFDateInputField: MFRightTitleTextField {

    open var rac_pickedDate = Variable<Date?>(nil)
    
    open var selectedDate: Date? {
        didSet {
            if let date = selectedDate {
                datePicker.setDate(date, animated: false)
            }
            
            updateSelectedDateText()
        }
    }
    
    open var dateFormatter: DateFormatter = DateFormatter() {
        didSet {
            updateSelectedDateText()
        }
    }
    
    open var datePicker: UIDatePicker = {
        let datePicker = BirthdayPicker()
        return datePicker
    }()
    
    open var toolbarLabelStyleInfo = LabelStyleInfo(font: UIFont.systemFont(ofSize: 12), textColor: UIColor.black) {
        didSet {
            setupComponents()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupComponents()
    }
    
    fileprivate func setupComponents() {
        datePicker.backgroundColor = UIColor.white
        self.inputView = datePicker
        
        // TODO: Update style for picker toolbar
        let leftButtonStyle = MFToolBarButtonStyle(title: "Cancel", labelStyle: toolbarLabelStyleInfo, actionHandler: {
            self.tappedCancelPicker()
        })
        // TODO: Use LocalizedStrings
        let rightButtonStyle = MFToolBarButtonStyle(title: "Done", labelStyle: toolbarLabelStyleInfo, actionHandler: {
            self.tappedDonePicker()
        })
        let toolbar = MFToolbarFactory.createPickerToolbar(leftButtonStyle, rightButtonStyle: rightButtonStyle)
        inputAccessoryView = toolbar
    }
    
    fileprivate func updateSelectedDateText() {
        if let date = selectedDate {
            text = dateFormatter.string(from: date)
        } else {
            text = nil
        }
    }
    
    open func tappedCancelPicker() {
        resignFirstResponder()
    }
    
    open func tappedDonePicker() {
        selectedDate = datePicker.date
        rac_pickedDate.value = selectedDate
        updateSelectedDateText()
        delegate?.textFieldDidEndEditing?(self)
        resignFirstResponder()
    }

}

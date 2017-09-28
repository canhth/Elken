//
//  BirthdayPicker.swift
//  Portfolio
//
//  Created by Phan Anh Duy on 7/5/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

open class BirthdayPicker: UIDatePicker {
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        //self.maximumDate = UserAuthLocalValidator.calculateMaxValidBirthday()
        self.datePickerMode = .date
    }
}

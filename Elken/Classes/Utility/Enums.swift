//
//  Enums.swift
//  GameOn
//
//  Created by thcanh on 1/11/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import UIKit


// Type to create corresponding UIBarButtonItem
public enum BarButtonType {
    // setup with a title
    case withTitle(String, selector: Selector?)
    // setup with an image
    case withImage(UIImage?, selector: Selector?)
    // setup with a custom view (ex: UISwitch)
    // we dont know which action should be handled so let's add target for custom view in vc
    case withCustomView(UIView)
}



public enum Gender: String {
    case Male = "Male"
    case Female = "Female"
    case Other = "Other"
    case NA = "NA"
    
    public static func getGenderWithValue(_ value: Int) -> Gender {
        switch value {
        case 0:
            return .Male
        case 1:
            return .Female
        case 2:
            return .Other
        default:
            return .NA
        }
    }
    
    public static func getGenderStringWithValue(_ value: String) -> String {
        switch value.lowercased() {
        case "m", "male":
            return "Male"
        case "f", "female":
            return "Female"
        case "o", "other":
            return "Other"
        default:
            return "NA"
        }
    }
    
}




//
//  UITextField.swift
//  iOSSwiftCore
//
//  Created by Imac on 6/16/16.
//  Copyright © 2016 iOS_Devs. All rights reserved.
//

import UIKit

extension UITextField {
 
    // scale font
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let fontName = self.font!.fontName
        let fontSize = self.font!.pointSize
        self.font = UIFont(name: fontName, size: fontSize * CGFloat(RATIO.SCREEN))
    }
    
    @IBInspectable var localizeKey: String {
        
        get {
            return ""
        } set {
            self.text = NSLocalizedString(newValue, comment: "")
        }
    }
    
    @IBInspectable var placeholderLocalizeKey: String {
        
        get {
            return ""
        } set {
            self.placeholder = NSLocalizedString(newValue, comment: "")
        }
    }
}

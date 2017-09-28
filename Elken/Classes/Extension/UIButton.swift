//
//  UIButton.swift
//  iOSSwiftCore
//
//  Created by Mobile on 6/20/16.
//  Copyright © 2016 iOS_Devs. All rights reserved.
//

import UIKit

extension UIButton {
    
    // scale font
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let fontName = self.titleLabel!.font.fontName
        let fontSize = self.titleLabel!.font.pointSize
        self.titleLabel!.font = UIFont(name: fontName, size: fontSize * CGFloat(RATIO.SCREEN))
    }
    
    @IBInspectable var localizeKey: String {
        
        get {
            return ""
        } set {
            self.setTitle(NSLocalizedString(newValue, comment: ""), for: UIControlState())
        }
    }
    

    
}

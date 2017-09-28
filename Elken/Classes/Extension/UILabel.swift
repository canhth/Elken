//
//  UILabel.swift
//  MusicApp2
//
//  Created by toan.quach on 4/2/16.
//  Copyright © 2016 Dev iOS. All rights reserved.
//

import UIKit

extension UILabel {

    // scale font
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let fontName = self.font.fontName
        let fontSize = self.font.pointSize
        self.font = UIFont(name: fontName, size: fontSize * CGFloat(ScaleValue.FONT))
    }
    
    @IBInspectable var localizeKey: String {
        
        get {
            return ""
        } set {
            self.text = NSLocalizedString(newValue, comment: "")
        }
    }
    
    func setUnderLineText() {
        
        guard let text = self.text else { return }
        let textRange = NSMakeRange(0, text.characters.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
        // Add other attributes if needed
        self.attributedText = attributedText
        
    }
    
    

}

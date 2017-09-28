//
//  UILabel+Misfit.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 12/3/15.
//  Copyright © 2015 misfit. All rights reserved.
//

import UIKit

public extension UILabel {
    public convenience init(text: String,
        font: UIFont = UIFont.systemFont(ofSize: 14),
        color: UIColor = UIColor.black,
        isSizeToFit: Bool = true,
        alignment: NSTextAlignment = .left) {
            self.init(frame: CGRect.zero)
            self.font = font
            self.textColor = color
            self.textAlignment = alignment
            self.text = text
            if isSizeToFit {
                self.sizeToFit()
            }
    }
}

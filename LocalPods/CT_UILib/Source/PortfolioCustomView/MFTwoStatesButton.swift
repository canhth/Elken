//
//  MFTwoStatesButton.swift
//  Portfolio
//
//  Created by Khanh Pham on 6/10/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

open class MFTwoStatesButton: UIButton {
    open var normalImage: UIImage? {
        didSet {
            setBackgroundImage(normalImage, for: UIControlState())
        }
    }
    
    open var selectedImage: UIImage? {
        didSet {
            setBackgroundImage(selectedImage, for: .selected)
        }
    }
}

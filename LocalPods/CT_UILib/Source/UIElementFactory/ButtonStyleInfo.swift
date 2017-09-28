//
//  UIElementFactory.swift
//  Portfolio
//
//  Created by Nga Pham on 3/30/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

public struct ButtonStyleInfo {
    public var normalColor: UIColor
    public var pressedColor: UIColor
    public var deactivatedColor: UIColor
    public var borderLineColor: UIColor
    public var defaultHeight: CGFloat
    public var labelStyleInfo: LabelStyleInfo
    
    public init(
        normalColor: UIColor,
        pressedColor: UIColor,
        deactivatedColor: UIColor,
        borderLineColor: UIColor,
        defaultHeight: CGFloat = 60,
        labelStyleInfo: LabelStyleInfo){
        self.normalColor = normalColor
        self.pressedColor = pressedColor
        self.deactivatedColor = deactivatedColor
        self.defaultHeight = defaultHeight
        self.labelStyleInfo = labelStyleInfo
        self.borderLineColor = borderLineColor
    }
}

//
//  UIElementFactory.swift
//  Portfolio
//
//  Created by Nga Pham on 3/30/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

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

open class UIElementFactory: NSObject {
    
    static open func newRichLabel(style: LabelStyleInfo, isInvertedColor: Bool? = false) -> RichLabel {
        let label = RichLabel()
        label.textColor = (isInvertedColor! ? style.invertedTextColor : style.textColor)
        label.font = style.font
        label.charSpacing = style.charSpacing
        //label.lineSpacing = style.lineSpacing
        label.lineHeight = style.lineHeight
        
        label.subscriptFont = style.font.fontWithScale(CGFloat(style.scaleOfSubscriptFont))
        label.capitalizationOption = style.capitalizationOption
        label.mf_textAlignment = style.textAlignment
        label.numberOfLines = 0//nvuy: [FIXME] Change it to use numberOfLines on style. For now, we will re-config the numberOfLines of label after created. Pls find all code which used this function to review.
        label.paragraphLineBreakMode = style.paragraphLineBreakMode
        
        label.highlightedColor = style.highlightedColor
        label.alpha = style.alpha
        return label
    }
    
    static open func newCountingLabel(_ style: LabelStyleInfo, isInvertedColor: Bool? = false) -> CountingLabel {
        let label = CountingLabel()
        label.textColor = (isInvertedColor! ? style.invertedTextColor : style.textColor)
        label.font = style.font
        label.charSpacing = style.charSpacing
        label.lineHeight = style.lineHeight
        
        label.subscriptFont = style.font.fontWithScale(CGFloat(style.scaleOfSubscriptFont))
        label.capitalizationOption = style.capitalizationOption
        label.mf_textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byClipping
        
        label.highlightedColor = style.highlightedColor
        label.alpha = style.alpha
        return label
    }
    
    static open func newLinkButton(_ text: String, titleStyleInfo: LabelStyleInfo?, underLine: Bool = true) -> UIButton {
        let button = UIButton()
        
        var attributes: [String: AnyObject] = [:]
        
        if let style = titleStyleInfo {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = style.lineSpacing
            
            if let lineHeight = titleStyleInfo?.lineHeight, let font = titleStyleInfo?.font {
                paragraphStyle.lineHeightMultiple = lineHeight / font.pointSize
            }
            
            attributes[NSParagraphStyleAttributeName] = paragraphStyle
            attributes[NSKernAttributeName] = style.charSpacing as AnyObject
            attributes[NSForegroundColorAttributeName] = style.textColor
            attributes[NSFontAttributeName] = style.font
        }
        
        if underLine {
            attributes[NSUnderlineStyleAttributeName] = NSNumber(value: NSUnderlineStyle.styleSingle.rawValue as Int)
        }
        
        
        let attributedText = NSMutableAttributedString(
            string: text,
            attributes: attributes
        )
        button.setAttributedTitle(attributedText, for: UIControlState())
        button.scaleFontToFitWidth(withInsets: UIEdgeInsets.zero)
        button.verticallyAlignCenter()
        
        return button
    }
    
    static open func newButton(_ text: String, leftIcon: UIImage? = nil, style: ButtonStyleInfo) -> UIButton
    {
        let button = BackgroundHighlightButton()
        button.titleLabel?.mf_textAlignment = .center
        
        let labelStyleInfo = style.labelStyleInfo
        button.titleLabel?.font = labelStyleInfo.font
        button.normalColor = style.normalColor
        button.highlightColor = style.pressedColor
        button.deactivatedColor = style.deactivatedColor
        
        var styleEnable = labelStyleInfo
        styleEnable.textAlignment = .center
        button.setAttributedTitle(
            styleEnable.makeAttributedString(fromString: text.uppercased()),
            for: UIControlState())
        
        var styleDisable = styleEnable
        styleDisable.textColor = styleEnable.textColor.withAlphaComponent(0.33)
        button.setAttributedTitle(
            styleDisable.makeAttributedString(fromString: text.uppercased()),
            for: .disabled)
        button.mfl_height = 60
        
        // Icon
        if let leftIcon = leftIcon {
            let iconView = UIImageView(image: leftIcon)
            button.addSubview(iconView)
            iconView.snp.makeConstraints({ (make) -> Void in
                make.size.equalTo(iconView.mfl_imageSize)
                make.centerY.equalTo(button)
                make.left.equalTo(20)
            })
        }
        
        button.scaleFontToFitWidth(withInsets: UIEdgeInsets.zero)
        button.verticallyAlignCenter()
        
        return button
    }
    
    static public func normalButton(text: String, leftIcon: UIImage? = nil, style: ButtonStyleInfo, isUppercase: Bool = true) -> UIButton {
        let button = BackgroundHighlightButton()
        button.titleLabel?.mf_textAlignment = .center
        
        let labelStyleInfo = style.labelStyleInfo
        button.titleLabel?.font = labelStyleInfo.font
        button.normalColor = style.normalColor
        button.highlightColor = style.pressedColor
        button.deactivatedColor = style.deactivatedColor
        
        var styleEnable = labelStyleInfo
        styleEnable.textAlignment = .center
        button.setAttributedTitle(
            styleEnable.makeAttributedString(fromString: (isUppercase ? text.uppercased() : text)),
            for: UIControlState())
        
        var styleDisable = styleEnable
        styleDisable.textColor = styleEnable.textColor.withAlphaComponent(0.33)
        button.setAttributedTitle(
            styleDisable.makeAttributedString(fromString: (isUppercase ? text.uppercased() : text)),
            for: .disabled)
        button.mfl_height = 60
        
        // Icon
        if let leftIcon = leftIcon {
            let iconView = UIImageView(image: leftIcon)
            button.addSubview(iconView)
            iconView.snp.makeConstraints({ (make) -> Void in
                make.size.equalTo(iconView.mfl_imageSize)
                make.centerY.equalTo(button)
                make.left.equalTo(20)
            })
        }
        
        button.scaleFontToFitWidth(withInsets: UIEdgeInsets.zero)
        button.verticallyAlignCenter()
        
        return button
    }
    
    static open func newNavBarButton(title: String, style: LabelStyleInfo, vc: UIViewController, selector: Selector?) -> UIBarButtonItem {
        let button = self.newBarButton(title: title, style: style, vc: vc, selector: selector)
        
        return UIBarButtonItem(customView: button)
    }
    
    static open func newBarButton(title: String, style: LabelStyleInfo, vc: UIViewController, selector: Selector?) -> UIButton {
        let button = UIButton()
        
        let normalText = ThemeUtil.attributedText(
            title,
            font: style.font,
            lineHeight: style.lineHeight ?? 0.0,
            charSpacing: style.charSpacing,
            textColor: style.textColor
        )
        
        let selectedText = ThemeUtil.attributedText(
            title,
            font: style.font,
            lineHeight: style.lineHeight ?? 0.0,
            charSpacing: style.charSpacing,
            textColor: style.textColor.colorWithAlpha(0.5)
        )
        
        let disabledText = ThemeUtil.attributedText(
            title,
            font: style.font,
            lineHeight: style.lineHeight ?? 0.0,
            charSpacing: style.charSpacing,
            textColor: style.textColor.colorWithAlpha(0.2)
        )
        
        button.setAttributedTitle(normalText, for: UIControlState())
        button.setAttributedTitle(selectedText, for: .selected)
        button.setAttributedTitle(selectedText, for: .highlighted)
        button.setAttributedTitle(disabledText, for: .disabled)
        
        button.scaleFontToFitWidth(withInsets: UIEdgeInsets.zero)
        button.verticallyAlignCenter()
        button.sizeToFit()
        
        if let selector = selector {
            button.addTarget(vc, action: selector, for: .touchUpInside)
        }
        
        return button
    }
    
    static open func newNavTitleView(title: String, style: LabelStyleInfo) -> RichLabel {
        let titleLabel = UIElementFactory.newRichLabel(style: style)
        titleLabel.text = title
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.sizeToFit()
        
        return titleLabel
    }
    
    static open func newNavBarButton(buttonType type: BarButtonType, titleStyle: LabelStyleInfo, vc: UIViewController) -> UIBarButtonItem {
        var barButtonItem: UIBarButtonItem!
        
        switch type {
        case let .withTitle(buttonTitle, selector: selector):
            barButtonItem = newNavBarButton(title: buttonTitle, style: titleStyle, vc: vc, selector: selector)
        case let .withImage(image, selector: selector):
            barButtonItem = UIBarButtonItem(image: image, style: .plain, target: vc, action: selector ?? nil)
        case let .withCustomView(customView):
            barButtonItem = UIBarButtonItem(customView: customView)
        }
        
        return barButtonItem
    }
    
    static open func newDotLabel(_ labelStyle: LabelStyleInfo, spacingBetweenDotAndText: Double? = nil) -> MFDotLabel {
        let dotLabel = MFDotLabel()
        dotLabel.labelStyle = labelStyle
        if let spacing = spacingBetweenDotAndText {
            dotLabel.spacingBetweenDotAndText = spacing
        }
        
        return dotLabel
    }
}

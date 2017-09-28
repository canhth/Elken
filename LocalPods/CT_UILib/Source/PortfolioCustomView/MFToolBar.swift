//
//  MFToolBar.swift
//  Portfolio
//
//  Created by Thanh Duyet on 7/7/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

public typealias MFToolBarButtonStyle = (title: String?, labelStyle: LabelStyleInfo?, actionHandler: (() -> Void)?)

open class MFToolbar: UIView {
    fileprivate var leftButton = UIButton()
    fileprivate var rightButton = UIButton()
    
    open var leftButtonStyle: MFToolBarButtonStyle? = nil {
        didSet {
            if leftButtonStyle != nil {
                setupView()
                setupLayout()
            }
        }
    }
    
    open var rightButtonStyle: MFToolBarButtonStyle? = nil {
        didSet {
            if rightButtonStyle != nil {
                setupView()
                setupLayout()
            }
        }
    }
    
    open var seperationLineColor: UIColor = UIColor.lightGray {
        didSet {
            self.mfl_addBorder(pos: .top, lineWidth: 1, color: seperationLineColor)
            self.mfl_addBorder(pos: .bottom, lineWidth: 1, color: seperationLineColor)
        }
    }
    
    fileprivate var leftActionHandler: (() -> Void)? = nil
    fileprivate var rightActionHandler: (() -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        self.backgroundColor = UIColor.white
        
        leftButton.removeFromSuperview()
        rightButton.removeFromSuperview()
        
        let defaultStyle = LabelStyleInfo(font: UIFont.systemFont(ofSize: 12), textColor: UIColor.black)
        if let title = self.leftButtonStyle?.title {
            let labelStyle = self.leftButtonStyle?.labelStyle ?? defaultStyle
            leftButton = createBarButton(title, labelStyle: labelStyle)
        }
        
        if let title = self.rightButtonStyle?.title {
            let labelStyle = self.rightButtonStyle?.labelStyle ?? defaultStyle
            rightButton = createBarButton(title, labelStyle: labelStyle)
        }
        
        leftActionHandler = leftButtonStyle?.actionHandler
        rightActionHandler = rightButtonStyle?.actionHandler
        
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        
        leftButton.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
    }
    
    fileprivate func setupLayout() {
        leftButton.snp.remakeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.centerY.equalTo(self)
            make.width.greaterThanOrEqualTo(44)
            make.height.equalTo(self)
        }
        
        rightButton.snp.remakeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.centerY.equalTo(self)
            make.width.greaterThanOrEqualTo(44)
            make.height.equalTo(self)
        }
    }
    
    fileprivate func createBarButton(_ title: String, labelStyle: LabelStyleInfo) -> UIButton {
        let attributes = labelStyle.getTextAttributes()
        
        var buttonTitle = ""
        switch labelStyle.capitalizationOption {
        case .upper:
            buttonTitle = title.uppercased()
        case .lower:
            buttonTitle = title.lowercased()
        default:
            buttonTitle = title
        }
        
        let attributedString = NSAttributedString(string: buttonTitle, attributes: attributes)
        
        let button = UIButton()
        button.setAttributedTitle(attributedString, for: UIControlState())
        
        return button
    }
    
    // MARK: - Events
    func didTapLeftButton() {
        leftActionHandler?()
    }
    
    func didTapRightButton() {
        rightActionHandler?()
    }
}

open class MFToolbarFactory {
    open class func createPickerToolbar(_ leftButtonStyle: MFToolBarButtonStyle? = nil, rightButtonStyle: MFToolBarButtonStyle? = nil) -> MFToolbar {
        let pickerToolbar = MFToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        pickerToolbar.leftButtonStyle = leftButtonStyle
        pickerToolbar.rightButtonStyle = rightButtonStyle
        pickerToolbar.mfl_addBorder(pos: .top, lineWidth: 1, color: UIColor.lightGray.colorWithAlpha(0.2))
        pickerToolbar.mfl_addBorder(pos: .bottom, lineWidth: 1, color: UIColor.lightGray.colorWithAlpha(0.2))
        
        return pickerToolbar
    }
}

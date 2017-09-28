//
//  InputField.swift
//  Portfolio
//
//  Created by Khanh Pham on 5/9/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

//import UIKit
//import ReactiveCocoa
//import PortfolioContent
//
//public class InputField: UIView {
//    
//    public struct Configs {
//        static let ContentPadding: CGFloat = 20
//    }
//    
//    private var tapGesture: UITapGestureRecognizer!
//    
//    public func tapGestureSignalProducer() -> SignalProducer<AnyObject?, NSError> {
//        if tapGesture == nil {
//            tapGesture = UITapGestureRecognizer(target: self, action: #selector(_didTapView(_:)))
//            addGestureRecognizer(tapGesture)
//        }
//        
//        return rac_signalForSelector(#selector(InputField._didTapView(_:))).toSignalProducer()
//    }
//    
//    // Just declare to support RAC signal
//    public func _didTapView(gesture: UITapGestureRecognizer) {
//        
//    }
//}
//
//public enum ActionInputFieldStyle {
//    /// Input with ProfileImage on the left, title on the right
//    case ProfileImage
//    
//    /// Show title on the left and Disclosure Indicator image on the right
//    case Disclosure
//    
//    /// Show title on the right and value on the left
//    case Value
//}
//
///// Input field that show title and value, and support user tap to fire an action
//public class ActionInputField: InputField {
//    
//    /// Title of input. Assign value to this will update appropriate title label of this input.
//    public var title: String = "" {
//        didSet {
//            switch inputStyle {
//            case .ProfileImage, .Value:
//                rightPlaceHolderLabel?.text = title
//            case .Disclosure:
//                leftLabel?.text = title
//            }
//        }
//    }
//    
//    /// Indicate input style
//    private(set) var inputStyle: ActionInputFieldStyle
//    
//    /// Profile image view
//    private(set) var imageView: ProfilePictureView?
//    
//    /// Label on the left, use to show title or value
//    private(set) var leftLabel: RichLabel?
//    
//    /// Placeholder/title label on the right
//    private(set) var rightPlaceHolderLabel: RichLabel?
//    
//    /// Disclosure image view
//    private(set) var disclosureImageView: UIImageView?
//    
//    /// Creates an input field with given style.
//    public init(inputStyle: ActionInputFieldStyle, frame: CGRect = CGRect.zero) {
//        self.inputStyle = inputStyle
//        super.init(frame: frame)
//        
//        setupComponents()
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("public init(coder:) has not been implemented")
//    }
//    
//    // MARK: Setup input components
//    
//    private func setupComponents() {
//        switch inputStyle {
//        case .ProfileImage:
//            setupProfileImageInput()
//        case .Disclosure:
//            setupDisclosureInput()
//        case .Value:
//            setupValueInput()
//        }
//        
//    }
//    
//    private func setupProfileImageInput() {
//        imageView = ProfilePictureView(imageSize: UILayoutSettings_Settings.ProfileImageSizeSmall)
//        rightPlaceHolderLabel = UIElementFactory.newRichLabel(style: Theme.sharedInstance.labelStyleDict_General[.FormFieldTitleActive]!)
//        
//        addSubview(imageView!)
//        addSubview(rightPlaceHolderLabel!)
//        
//        imageView!.snp.remakeConstraints { (make) -> Void in
//            make.leading.equalTo(InputField.Configs.ContentPadding)
//            make.centerY.equalToSuperview()
//            make.size.equalTo(UILayoutSettings_Settings.ProfileImageSizeSmall)
//        }
//        
//        rightPlaceHolderLabel!.snp.remakeConstraints { (make) -> Void in
//            make.centerY.equalToSuperview()
//            make.trailing.equalTo(-InputField.Configs.ContentPadding)
//            make.height.equalTo(self)
//        }
//    }
//    
//    private func setupDisclosureInput() {
//        disclosureImageView = UIImageView()
//        leftLabel = UIElementFactory.newRichLabel(style: Theme.sharedInstance.labelStyleDict_General[.FormFieldEnteredValue]!)
//        
//        addSubview(disclosureImageView!)
//        addSubview(leftLabel!)
//        
//        leftLabel!.snp.remakeConstraints{ (make) in
//            make.leading.equalTo(InputField.Configs.ContentPadding)
//            make.centerY.equalToSuperview()
//            make.height.equalTo(self)
//        }
//        
//        disclosureImageView!.snp.remakeConstraints { (make) in
//            make.trailing.equalTo(-InputField.Configs.ContentPadding)
//            make.centerY.equalToSuperview()
//        }
//    }
//    
//    private func setupValueInput() {
//        leftLabel = UIElementFactory.newRichLabel(style: Theme.sharedInstance.labelStyleDict_General[.FormFieldTitleDefault]!)
//        
//        rightPlaceHolderLabel = UIElementFactory.newRichLabel(style: Theme.sharedInstance.labelStyleDict_General[.FormFieldTitleActive]!)
//        
//        addSubview(leftLabel!)
//        addSubview(rightPlaceHolderLabel!)
//        
//        leftLabel!.snp.remakeConstraints{ (make) in
//            make.leading.equalTo(InputField.Configs.ContentPadding)
//            make.centerY.equalToSuperview()
//            make.height.equalTo(self)
//        }
//        
//        rightPlaceHolderLabel!.snp.remakeConstraints { (make) -> Void in
//            make.centerY.equalToSuperview()
//            make.trailing.equalTo(-InputField.Configs.ContentPadding)
//            make.height.equalTo(self)
//        }
//    }
//}
//
//public enum Gender: String {
//    case Male = "M"
//    case Female = "F"
//    case Other = "O"
//    case NA = "NA"
//}
//
//public class GenderField: UIView {
//    
//    /// Selected value
//    public var selectedValue: Gender? {
//        didSet {
//            maleGenderButton.normalColor = (selectedValue == .Male ? genderButtonStyle.pressedColor : genderButtonStyle.normalColor)
//            femaleGenderButton.normalColor = (selectedValue == .Female ? genderButtonStyle.pressedColor : genderButtonStyle.normalColor)
//        }
//    }
//    
//    private let maleGenderButton: BackgroundHighlightButton = {
//        let button = UIElementFactory.newButton(localizedStrings.Onboarding_SignUp_Create_Account_Input_Male) as! BackgroundHighlightButton
//        button.accessibilityLabel = "male"
//        return button
//    }()
//    
//    private let femaleGenderButton: BackgroundHighlightButton = {
//        let button = UIElementFactory.newButton(localizedStrings.Onboarding_SignUp_Create_Account_Input_Female) as! BackgroundHighlightButton
//        button.accessibilityLabel = "female"
//        return button
//    }()
//    
//    override public init(frame: CGRect) {
//        super.init(frame: frame)
//        setupComponents()
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("public init(coder:) has not been implemented")
//    }
//    
//    private let genderButtonStyle = Theme.sharedInstance.buttonStyleDict[.SignupGender]!
//    
//    public struct Configs {
//        static let ContentPadding: CGFloat = 0
//        static let ContentSpacing: CGFloat = 1
//    }
//    
//    private func setupComponents() {
//        addSubview(maleGenderButton)
//        addSubview(femaleGenderButton)
//        
//        maleGenderButton.snp.remakeConstraints { (make) -> Void in
//            make.leading.equalTo(Configs.ContentPadding)
//            make.trailing.equalTo(femaleGenderButton.snp.leading).offset(-Configs.ContentSpacing)
//            make.top.equalTo(Configs.ContentPadding)
//            make.bottom.equalTo(Configs.ContentPadding)
//        }
//        
//        femaleGenderButton.snp.remakeConstraints { (make) -> Void in
//            make.top.equalTo(Configs.ContentPadding)
//            make.trailing.equalTo(Configs.ContentPadding)
//            make.bottom.equalTo(Configs.ContentPadding)
//            make.width.equalTo(maleGenderButton.snp.width)
//        }
//        
//        maleGenderButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
//        femaleGenderButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
//    }
//    
//    
//    public func genderButtonTapped(button: BackgroundHighlightButton) {
//        if button == maleGenderButton {
//            selectedValue = .Male
//        } else if button == femaleGenderButton {
//            selectedValue = .Female
//        }
//    }
//    
//    /// Forward tap event to outside
//    public func tapSignalProducer() -> SignalProducer<AnyObject?, NSError> {
//        return rac_signalForSelector(#selector(GenderField.genderButtonTapped(_:))).toSignalProducer()
//    }
//}
//
//public class SwitchInputView: UIView {
//    public var titleLabel: RichLabel!
//    public var switchControl: UISwitch!
//    
//    override public init(frame: CGRect) {
//        super.init(frame: frame)
//        setupComponents()
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("public init(coder:) has not been implemented")
//    }
//    
//    private func setupComponents() {
//        titleLabel = UIElementFactory.newRichLabel(style: Theme.sharedInstance.labelStyleDict_General[.FormFieldTitleDefault]!)
//        switchControl = UISwitch()
//        
//        addSubview(titleLabel)
//        addSubview(switchControl)
//        
//        titleLabel.snp.remakeConstraints{ (make) in
//            make.leading.equalTo(InputField.Configs.ContentPadding)
//            make.centerY.equalToSuperview()
//            make.height.equalTo(self)
//        }
//        
//        switchControl.snp.remakeConstraints { (make) -> Void in
//            make.centerY.equalToSuperview()
//            make.trailing.equalTo(-InputField.Configs.ContentPadding)
//        }
//    }
//}
//
//extension UIView {
//    
//    /// Set up chevron down image for picker input
//    public func setupPickerImage(fieldHeight fieldHeight: CGFloat?) {
//        let img = Theme.sharedInstance.image_iconChevronDown()
//        let imgView = UIImageView(image: img)
//        addSubview(imgView)
//        
//        imgView.snp.remakeConstraints { (make) in
//            make.trailing.equalTo(self).offset(-25)
//            if let height = fieldHeight {
//                make.centerY.equalTo(self.snp.top).offset(height * 0.5)
//            } else {
//                make.centerY.equalTo(self)
//            }
//        }
//    }
//}



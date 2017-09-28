//
//  RichLabel.swift
//  Portfolio
//
//  Created by Nga Pham on 4/1/16.
//  Copyright © 2016 Misfit. All rights reserved.
//



open class RichLabel: UILabel {
    
    open static let kHighlightedMarker: Character = "~"
    open static let kSubscriptMarker: Character = "_"
    
    open var lineSpacing: CGFloat?
    open var lineHeight: CGFloat?
    open var charSpacing: CGFloat?
    
    open var subscriptFont: UIFont?
    
    open var highlightedColor: UIColor?
    
    open var capitalizationOption: TextCapitalizationOption = .none
    open var mfl_contentInsets: UIEdgeInsets = UIEdgeInsets.zero
    open var paragraphLineBreakMode: NSLineBreakMode = .byWordWrapping
    
    open var secondaryCapitalizations: [String: TextCapitalizationOption] = [:]
    
    override open var text: String? {
        didSet {
            guard let text = text, !text.characters.isEmpty else { return }
            
            // Preprocess string: capitalization
            var swiftString = RichLabel.preprocessString(text, capitalizationOption: capitalizationOption)
            
            // Preprocess string: secondary capitalization
            secondaryCapitalizations.forEach { substring, secondaryCapitalizationOption in
                swiftString = RichLabel.preprocessString(swiftString, secondaryCapitalizationOption: secondaryCapitalizationOption, forSubstring: substring)
            }
            
            // Apply attributes
            applyAttributesToString(swiftString)
        }
    }
    
    override open func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, mfl_contentInsets))
    }
    
    public init() {
        super.init(frame: CGRect.zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public init(style: LabelStyleInfo) {
        super.init(frame: CGRect.zero)
        self.applyStyle(style)
    }
    
    public init(text: String?) {
        super.init(frame: CGRect.zero)
        self.text = text
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension RichLabel {
    
    public class func preprocessString(_ string: String, capitalizationOption: TextCapitalizationOption) -> String {
        var swiftString = string
        if capitalizationOption == .none {
            // Do nothing
        } else if capitalizationOption == .upper {
            swiftString = string.uppercased()
        } else if capitalizationOption == .lower {
            swiftString = string.lowercased()
        } else if capitalizationOption == .lowerThenCapitalizeFirstWordOfSentence {
            swiftString = string.lowercased().capitilizeEachWordOfSentence()
        } else if capitalizationOption == .capitalizeFirstWordOfSentence {
            swiftString = string.capitilizeEachWordOfSentence()
        } else if capitalizationOption == .lowerThenCapitalizeEachWord {
            swiftString = string.lowercased().capitalized
        } else if capitalizationOption == .capitalizeEachWord {
            swiftString = string.capitalized
        }
        
        return swiftString
    }
    
    public class func processAttributedString(_ srcAttributedString: NSAttributedString, delimiter: Character, applyAttributes: [String: AnyObject]) -> NSAttributedString {
        let string = srcAttributedString.string
        var isInBoldRange: Bool = false
        var startIndexInSourceString: Int = 0
        var startIndexInDestinationString: Int = 0
        
        let nsstring = NSString(string: string)
        let characters = Array(string.characters)
        let attributedString = NSMutableAttributedString()
        var rangeLength: Int = 0
        
        for i in 0..<characters.count {
            if characters[i] == delimiter {
                if isInBoldRange == false {
                    // Append normal part
                    if rangeLength > 0 {
                        attributedString.append(srcAttributedString.attributedSubstring(from: NSMakeRange(startIndexInSourceString, rangeLength)))
                    }
                    
                    isInBoldRange = true
                } else {
                    // Append bold part
                    if rangeLength > 0 {
                        // Append source attributes
                        attributedString.append(srcAttributedString.attributedSubstring(from: NSMakeRange(startIndexInSourceString, rangeLength)))
                        
                        // Then add new attributes
                        attributedString.addAttributes(applyAttributes, range: NSMakeRange(startIndexInDestinationString, rangeLength))
                    }
                    
                    isInBoldRange = false
                }
                
                startIndexInSourceString = i + 1
                startIndexInDestinationString += rangeLength
                
                rangeLength = 0
            } else {
                rangeLength += nsstring.range(of: String(characters[i])).length
            }
        }
        
        if isInBoldRange == false && rangeLength > 0 {
            // Crashed when load list contacts with some unexpected cases (ex: Hoàn Hồ)
            rangeLength = rangeLength > srcAttributedString.length ? srcAttributedString.length : rangeLength
            
            // Append normal part
            if rangeLength > 0 && rangeLength <= srcAttributedString.length {
                attributedString.append(srcAttributedString.attributedSubstring(from: NSMakeRange(startIndexInSourceString, rangeLength)))
            }
        }
        
        return attributedString
    }
    
    fileprivate func applyAttributesToString(_ string: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        if let lineHeight = self.lineHeight {
            paragraphStyle.lineHeightMultiple = lineHeight / self.font.pointSize
        }
        
        paragraphStyle.alignment = self.textAlignment
        paragraphStyle.lineBreakMode = self.paragraphLineBreakMode
        
        var defaultAttributes: [String: AnyObject] = [
            NSFontAttributeName: self.font,
            NSForegroundColorAttributeName: self.textColor,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        if let spacing = charSpacing {
            defaultAttributes[NSKernAttributeName] = spacing as AnyObject
        }
        
        var attributedStr = NSAttributedString(string: string, attributes: defaultAttributes)
        
        if let color = highlightedColor {
            attributedStr = RichLabel.processAttributedString(attributedStr, delimiter: RichLabel.kHighlightedMarker, applyAttributes: [NSForegroundColorAttributeName: color])
        }
        
        if let font = subscriptFont {
            attributedStr = RichLabel.processAttributedString(attributedStr, delimiter: "_", applyAttributes: [NSFontAttributeName: font])
        }
        
        self.attributedText = attributedStr
    }
    
    class func preprocessString(_ string: String, secondaryCapitalizationOption: TextCapitalizationOption, forSubstring substring: String) -> String {
        // Preprocess string: secondary capitalization
        let processedSubstring = preprocessString(substring, capitalizationOption: secondaryCapitalizationOption)
        return string.replacingOccurrences(of: substring, with: processedSubstring, options: [.caseInsensitive])
    }
}

public extension RichLabel {
    
    public func applyStyle(_ style: LabelStyleInfo) {
        self.textColor = style.textColor
        self.font = style.font
        self.charSpacing = style.charSpacing
        self.lineSpacing = style.lineSpacing
        self.lineHeight = style.lineHeight
        self.highlightedColor = style.highlightedColor
        self.subscriptFont = style.font.fontWithScale(CGFloat(style.scaleOfSubscriptFont))
        self.capitalizationOption = style.capitalizationOption
        self.mf_textAlignment = style.textAlignment
        self.alpha = style.alpha
        self.numberOfLines = style.numberOfLines
        self.paragraphLineBreakMode = style.paragraphLineBreakMode
    }
    
    public func updateText(_ text: String, withStyle style: LabelStyleInfo) {
        self.applyStyle(style)
        self.text = text
    }
}

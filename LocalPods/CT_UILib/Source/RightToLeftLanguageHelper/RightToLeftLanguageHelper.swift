//
//  RightToLeftLanguageHelper.swift
//  Portfolio
//
//  Created by Phan Anh Duy on 8/19/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

public protocol MFLayoutDirectionSuported: class {
    var isRightToLeftLanguage: Bool { get }
    func disableRightToLeftLanguage()
}

public protocol MFContentAlignmentSuported: class {
    var textAlignment: NSTextAlignment { get set }
}

public protocol MFContentAlignmentWithLayourDirectionSupported: MFLayoutDirectionSuported, MFContentAlignmentSuported { }

extension UIView: MFLayoutDirectionSuported {
    public var isRightToLeftLanguage: Bool {
        if #available(iOS 9.0, *) {
            return UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft
        } else {
            return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
        }
    }
    
    // NOTE: only support iOS 9 and later
    public func disableRightToLeftLanguage() {
        if #available(iOS 9.0, *) {
            self.semanticContentAttribute = .forceLeftToRight
        }
    }
}

//extension MFContentAlignmentSuported where Self: MFLayoutDirectionSuported {
public extension MFContentAlignmentWithLayourDirectionSupported {
    public var mf_textAlignment: NSTextAlignment {
        get {
            if !isRightToLeftLanguage {
                return self.textAlignment
            } else {
                switch self.textAlignment {
                case .left:     return .right
                case .right:    return .left
                case _:         return self.textAlignment
                }
            }
        }
        
        set {
            if !isRightToLeftLanguage {
                self.textAlignment = newValue
            } else {
                switch newValue {
                case .left:     self.textAlignment = .right
                case .right:    self.textAlignment = .left
                case _:         self.textAlignment = newValue
                }
            }
        }
    }
}

// MARK: - Text alignments
extension UILabel: MFContentAlignmentWithLayourDirectionSupported { }
extension UITextField: MFContentAlignmentWithLayourDirectionSupported { }

public extension MFLayoutDirectionSuported where Self: UIButton {
    public var mf_contentHorizontalAlignment: UIControlContentHorizontalAlignment {
        get {
            if !isRightToLeftLanguage { return self.contentHorizontalAlignment }
            else {
                switch self.contentHorizontalAlignment {
                case .left:     return .right
                case .right:    return .left
                case _:         return self.contentHorizontalAlignment
                }
            }
        }
        
        set {
            if !isRightToLeftLanguage { self.contentHorizontalAlignment = newValue }
            else {
                switch newValue {
                case .left:     self.contentHorizontalAlignment = .right
                case .right:    self.contentHorizontalAlignment = .left
                case _:         self.contentHorizontalAlignment = newValue
                }
            }
        }
    }
}

/// Discussion: tnthuyen:
/// Previously, I make extensions in such this way:

/*
extension MFLayoutDirectionSupported where Self: MFContentAlignmentSupported {
}

extension UILabel: MFContentAlignmentSupported { }
extension UITextField: MFContentAlignmentSupported { }
*/

/// UITextField is a subclass of UIView which already conformed to protocol MFLayoutDirectionSuported
/// Yet, XCode failed to compile, saying it does not conform to this protocollll (aka MFLayoutDirectionSupported)
/// Painfully, this code is compiled successfully in my colleages' computer (the same XCode version as mine)
/// --> Solution: another protocol: MFContentAlignmentWithLayourDirectionSupported
/// --> Not quite elegantttt
/// --> should blame XCode for this issue


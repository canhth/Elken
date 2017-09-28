//
//  MFLScreenSize.swift
//
//  Created by Nghia Nguyen on 12/3/15.
//

import UIKit

public enum MFLScreenType {
    case ip4S
    case ip5
    case ip6
    case ip6Plus
}

public struct MFLScreenSize {
    public static let IP4S = CGSize(width: 320, height: 480)
    public static let IP5 = CGSize(width: 320, height: 568)
    public static let IP6 = CGSize(width: 375, height: 667)
    public static let IP6Plus = CGSize(width: 414, height: 736)
    public static let Current = UIScreen.main.bounds.size
    
    public static let CurrentType : MFLScreenType = {
        if Current == IP5 {
            return .ip5
        }
        
        if Current == IP6 {
            return .ip6
        }
        
        if Current == IP6Plus {
            return .ip6Plus
        }
        
        return .ip4S
    }()
    
    public static var Layout = MFLScreenSize.IP6 {
        didSet {
            LayoutRatio = Current.height / MFLScreenSize.Layout.height
            
            let currentRatio = MFLScreenSize.Current.height / MFLScreenSize.Current.width
            let layoutRatio = MFLScreenSize.Layout.height / MFLScreenSize.Layout.width
            Ratio = currentRatio / layoutRatio
        }
    }
    
    
    fileprivate static var LayoutRatio = MFLScreenSize.Current.height / MFLScreenSize.Layout.height
    fileprivate static var Ratio: CGFloat = {
        let currentRatio = MFLScreenSize.Current.height / MFLScreenSize.Current.width
        let layoutRatio = MFLScreenSize.Layout.height / MFLScreenSize.Layout.width
        
        return currentRatio / layoutRatio
    }()
}

/**
 Standardize layout config depend on screen resolution.
 - Parameter num: layout config.
 - Returns: Config after standardize.
 */
public func ST(_ num: AnyObject, powValue: CGFloat = 1) -> CGFloat {
    return MFLScreenSize.LayoutRatio * (num as? CGFloat ?? 0) * pow(MFLScreenSize.Ratio, powValue)
}

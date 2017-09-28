//
//  UIView+Autolayout.swift
//  MisfitUILib
//
//  Created by Nghia Nguyen on 12/3/15.
//  Copyright © 2015 misfit. All rights reserved.
//

import UIKit
import SnapKit

//MARK: Border

public enum MFLEdgePos{
    case top
    case bottom
    case leading
    case trailing
    
    public static func getTagWithEdgePos(_ edge: MFLEdgePos) -> TagWithEdgePosition {
        switch edge {
        case .top:
            return .topTag
        case .bottom:
            return .bottomTag
        case .leading:
            return .leadingTag
        case .trailing:
            return .trailingTag
        }
    }
}

public enum TagWithEdgePosition: Int {
    case topTag = 101
    case bottomTag = 102
    case leadingTag = 103
    case trailingTag = 104
}

public extension UIView {
    
    @discardableResult
    public func mfl_addBorder(pos: MFLEdgePos, lineWidth: Double,
        offset1: Double = 0, offset2: Double = 0, color: UIColor) -> UIView {
        let border = UIView()
        border.backgroundColor = color
        
        self.addSubview(border)
        
        border.snp.makeConstraints { (make) -> Void in
            switch pos {
            case .top:
                make.top.equalTo(self)
            case .bottom:
                make.bottom.equalTo(self)
                
            case .leading:
                make.leading.equalTo(self)
            case .trailing:
                make.trailing.equalTo(self)
            }
            
            switch pos {
            case .top, .bottom:
                make.height.equalTo(lineWidth)
                make.leading.equalTo(self).offset(offset1)
                make.trailing.equalTo(self).offset(-offset2)
            case .leading, .trailing:
                make.width.equalTo(lineWidth)
                make.top.equalTo(self).offset(offset1)
                make.bottom.equalTo(self).offset(-offset2)
            }
        }
        return border;
    }
}

//MARK: Divide views
public enum MFLOrientationType {
    case horizontal
    case vertical
}

public extension UIView {
    public func mfl_divideViews(num: UInt, type: MFLOrientationType) -> [UIView] {
        var views = [UIView]()
        
        for i in 0..<num {
            let view = UIView()
            views.append(view)
            
            self.addSubview(view)
            
            view.snp.makeConstraints({ (make) -> Void in
                make.bottom.equalTo(self)
                
                switch type {
                case .horizontal:
                    make.width.equalTo(self)
                    make.height.equalTo(self).dividedBy(num)
                    if (i == 0) {
                        make.leading.equalTo(self)
                    } else {
                        make.leading.equalTo(views[Int(i)-1].snp.trailing)
                    }
                    
                case .vertical:
                    make.width.equalTo(self).dividedBy(num)
                    make.height.equalTo(self)
                    if (i == 0) {
                        make.top.equalTo(self)
                    } else {
                        make.top.equalTo(views[Int(i)-1].snp.bottom)
                    }
                }
            })
        }
        
        return views
    }
}

public extension UIView {
    public static func mfl_spaceOutAllViews(
        _ views: [UIView],
        offset: CGFloat,
        type: MFLOrientationType) {
        if views.count < 2 {
            return
        }
        
        var source = views.first!
        for i in 1..<views.count {
            let view = views[i]
            view.snp.makeConstraints({ (make) -> Void in
                
                switch type {
                case .horizontal:
                    make.leading.equalTo(source.snp.trailing).offset(offset)
                case .vertical:
                    make.top.equalTo(source.snp.bottom).offset(offset)
                }
            })
            
            source = view
        }
    }
    
    public static func mfl_alignAllViews(_ views: [UIView], edgePos: MFLEdgePos) {
        if views.count < 2 {
            return
        }
        
        let source = views.first!
        for i in 1..<views.count {
            let view = views[i]
            view.snp.makeConstraints({ (make) -> Void in
                switch edgePos {
                case .bottom:
                    make.bottom.equalTo(source)
                case .leading:
                    make.leading.equalTo(source)
                case .trailing:
                    make.trailing.equalTo(source)
                case .top:
                    make.top.equalTo(source)
                }
            })
        }
    }
    
    public static func mfl_equalsHeightForViews(_ views: [UIView]) {
        if views.count < 2 {
            return
        }
        
        let source = views.first!
        for i in 1..<views.count {
            let view = views[i]
            view.snp.makeConstraints({ (make) -> Void in
                make.height.equalTo(source)
            })
        }
    }
    
    public static func mfl_equalsWidthForViews(_ views: [UIView]) {
        if views.count < 2 {
            return
        }
        
        let source = views.first!
        for i in 1..<views.count {
            let view = views[i]
            view.snp.makeConstraints({ (make) -> Void in
                make.width.equalTo(source)
            })
        }
    }
}

//
//  UIView+Frame.swift
//
//  Created by Nghia Nguyen on 10/28/15.
//

import UIKit

public extension UIView {
    public var mfl_x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame = CGRect(x: newValue, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    public var mfl_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: newValue, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    public var mfl_width: CGFloat {
        get {
            return self.frame.size.width
        }
        
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newValue, height: self.frame.size.height)
        }
    }
    
    public var mfl_height: CGFloat {
        get {
            return self.frame.size.height
        }
        
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: newValue)
        }
    }
    
    //MARK: Align with view
    public func mfl_alignTopView(_ view: UIView, offset: CGFloat = 0) -> UIView {
        self.mfl_y = view.mfl_y + view.mfl_height + offset
        return self
    }
    
    public func mfl_alignLeadingView(_ view: UIView, offset: CGFloat = 0) -> UIView {
        self.mfl_x = view.mfl_x + view.mfl_width + offset
        return self
    }
    
    public func mfl_alignTrailingView(_ view: UIView, offset: CGFloat = 0) -> UIView {
        self.mfl_x = view.mfl_x - self.mfl_width + offset
        return self
    }
    
    public func mfl_alignBottomView(_ view: UIView, offset: CGFloat = 0) -> UIView {
        self.mfl_y = view.mfl_y - self.mfl_height + offset
        return self
    }
    
    public func mfl_centerVerticalView(_ view: UIView, offset: CGFloat = 0) -> UIView {
        self.center = CGPoint(x: self.center.x, y: view.center.y + offset)
        return self
    }
    
    public func mfl_centerHorizontalView(_ view: UIView, offset: CGFloat = 0) -> UIView {
        self.center = CGPoint(x: view.center.x + offset, y: self.center.y)
        return self
    }
    
    // MARK: Pin with view
    public func mfl_pinTopView(_ view: UIView, offset: CGFloat = 0) -> UIView {
        self.mfl_y = view.mfl_y + offset
        
        return self
    }
    
    public func mfl_pinBottomView(_ view: UIView, offset: CGFloat = 0) -> UIView {
        self.mfl_y = view.mfl_y + view.mfl_height - self.mfl_height + offset
        
        return self
    }
    
    public func mfl_pinLeadingView(_ view: UIView, offset: CGFloat = 0) -> UIView {
        self.mfl_x = view.mfl_x + offset
        
        return self
    }
    
    public func mfl_pinTrailingView(_ view: UIView, offset: CGFloat = 0) -> UIView {
        self.mfl_x = view.mfl_x + view.mfl_width - self.mfl_width + offset
        
        return self
    }

    //MARK: Layout with parent
    public func mfl_pinTopParent(_ offset: CGFloat = 0) -> UIView {
        self.mfl_y = offset
        return self
    }
    
    public func mfl_pinLeadingParent(_ offset: CGFloat = 0) -> UIView {
        self.mfl_x = offset
        return self
    }
    
    
    public func mfl_pinTrailingParent(_ offset: CGFloat = 0) -> UIView {
        guard let superview = self.superview else {
            return self
        }
        
        self.mfl_x = superview.mfl_width - self.mfl_width + offset
        return self
    }
    
    public func mfl_pinBottomParent(_ offset: CGFloat = 0) -> UIView {
        guard let superview = self.superview else {
            return self
        }
        
        self.mfl_y = superview.mfl_height - self.mfl_height + offset
        return self
    }
    
    @discardableResult
    public func mfl_centerHorizontalParent(_ offset: CGFloat = 0) -> UIView {
        guard let superview = self.superview else {
            return self
        }
        
        self.center.x = superview.mfl_width / 2 + offset
        return self
    }
    
    @discardableResult
    public func mfl_centerVerticalParent(_ offset: CGFloat = 0) -> UIView {
        guard let superview = self.superview else {
            return self
        }
        
        self.center.y = superview.mfl_height / 2 + offset
        return self
    }
}

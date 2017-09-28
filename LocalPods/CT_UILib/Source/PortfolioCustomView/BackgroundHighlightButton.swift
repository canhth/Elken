//
//  HighlightButton.swift
//  Fossil
//
//  Created by Matthew Yannascoli on 7/6/15.
//  Copyright (c) 2015 Fossil, Inc. All rights reserved.
//

import UIKit

open class BackgroundHighlightButton : UIButton {
    fileprivate let rectInsets : UIEdgeInsets
    
    open var highlightColor : UIColor = UIColor.clear
    open var deactivatedColor : UIColor = UIColor.clear
    open var normalColor : UIColor = UIColor.clear {
        didSet {
            self.backgroundColor = self.normalColor
        }
    }
    open var circularBackground : Bool = false {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        self.rectInsets = UIEdgeInsets.zero
        super.init(frame: frame)
        
        self.adjustsImageWhenHighlighted = false
    }
    
    public init(rectInsets: CGRect) {
        self.rectInsets = UIEdgeInsets.zero
        super.init(frame: CGRect.zero)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if self.circularBackground {
            self.layer.cornerRadius = CGFloat(self.bounds.size.width)/2.0
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.rectInsets = UIEdgeInsets.zero
        super.init(coder: aDecoder)
        self.adjustsImageWhenHighlighted = false
    }
    
    override open func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
    }
    
    override open var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            self.setHighLighted(newValue, animated:true)
        }
    }
    
    override open var isEnabled: Bool {
        get {
            return super.isEnabled
        }
        set {
            self.setEnabled(newValue, animated:true)
        }
    }
    
    func setEnabled(_ enabled:Bool, animated:Bool) {
        if enabled {
            self.transitionBackgroundToColor(self.normalColor, textAlpha: 1.0, animated:animated)
        }
        else {
            self.transitionBackgroundToColor(self.deactivatedColor, textAlpha: 1.0, animated:animated)
        }
        
        super.isEnabled = enabled
        
    }
    
    func setHighLighted(_ highlighted:Bool, animated:Bool) {
        if highlighted {
            self.transitionBackgroundToColor(self.highlightColor, textAlpha: 1.0, animated:animated)
        }
        else {
            self.setEnabled(self.isEnabled, animated:animated)
        }
        
        super.isHighlighted = highlighted
        
    }
    
    fileprivate func transitionBackgroundToColor(_ color: UIColor, textAlpha: CGFloat, animated:Bool) {
        
        let blk:()->() = {
            self.backgroundColor = color
            self.titleLabel?.alpha = textAlpha
        }
        
        if (animated) {
            UIView.animate(withDuration: 0.15, animations:blk)
        }
        else {
            blk()
        }
        
    }
    
    override open var alignmentRectInsets : UIEdgeInsets {
        return self.rectInsets
    }
    
    func animateBackgroundColor(_ color: UIColor) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.backgroundColor = color
            }, completion: { finished in
                UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
                    self.backgroundColor = self.normalColor
                    }, completion: { finished in
                        //
                })
        })
    }
}

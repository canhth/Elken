//
//  UIView+Constraint.swift
//
//  Created by Phan Anh Duy
//  Copyright (c) 2015 Phan Anh Duy. All rights reserved.
//

import UIKit

public extension UIView {
    /*
    Set width for view by using Constraint. If width Constraint does not exist => create new Constraint and add to view, if it existed => update
    */
    public func setConstraintWidth(width: CGFloat) {
        if let constraint = self.searchConstraintInView(self, view1: self, attribute1: NSLayoutAttribute.width, relation: NSLayoutRelation.equal, view2: nil, attribute2: NSLayoutAttribute.notAnAttribute) {
            // update constant
            constraint.constant = width;
        } else {
            // add width of constraint
            self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: width))
        }
    } // setConstraintWidth
    
    /*
    Set height for view by using Constraint. If height Constraint does not exist => create new Constraint and add to view, if it existed => update
    */
    public func setConstraintHeight(height: CGFloat) {
        if let constraint = self.searchConstraintInView(self, view1: self, attribute1: NSLayoutAttribute.height, relation: NSLayoutRelation.equal, view2: nil, attribute2: NSLayoutAttribute.notAnAttribute) {
            // update constant
            constraint.constant = height;
        } else {
            // add height of constraint
            self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height))
        }
    } // setConstraintHeight

    /*
    *  @discussion get width Constraint of view. If it does not exist, so we will get width of frame view
    */
    public func getConstraintWidth() -> CGFloat {
        if let constraint = self.searchConstraintInView(self, view1: self, attribute1: NSLayoutAttribute.width, relation: NSLayoutRelation.equal, view2: nil, attribute2: NSLayoutAttribute.notAnAttribute) {
            return constraint.constant;
        } else {
            return self.frame.size.width;
        }
    }

    /*
    *  @discussion get height Constraint of view. If it does not exist, so we will get height of frame view
    */
    public func getConstraintHeight() -> CGFloat {
        if let constraint = self.searchConstraintInView(self, view1: self, attribute1: NSLayoutAttribute.height, relation: NSLayoutRelation.equal, view2: nil, attribute2: NSLayoutAttribute.notAnAttribute) {
            return constraint.constant;
        } else {
            return self.frame.size.width;
        }
    }
    

    /*
    *  @discussion add constraint align left to related view with margin constant
    */
    public func addConstraintAlignLeftToView(vRelated: UIView, constant: CGFloat) {
        if let constraint = self.searchConstraintInView(vRelated, view1: self, attribute1: NSLayoutAttribute.leading, relation: NSLayoutRelation.equal, view2: vRelated, attribute2: NSLayoutAttribute.leading) {
            // update constant
            constraint.constant = constant;
        } else {
            // add new constraint
            vRelated.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: vRelated, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: constant));
        }
    }
    
    /*
    *  @discussion add constraint align right to related view with margin constant
    */
    public func addConstraintAlignRightToView(vRelated: UIView, constant: CGFloat) {
        if let constraint = self.searchConstraintInView(vRelated, view1: self, attribute1: NSLayoutAttribute.trailing, relation: NSLayoutRelation.equal, view2: vRelated, attribute2: NSLayoutAttribute.trailing) {
            // update constant
            constraint.constant = constant;
        } else {
            // add new constraint
            vRelated.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: vRelated, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: constant));
        }
    }

    /*
    *  @discussion add constraint align top to related view with margin constant
    */
    public func addConstraintAlignTopToView(vRelated: UIView, constant: CGFloat) {
        if let constraint = self.searchConstraintInView(vRelated, view1: self, attribute1: NSLayoutAttribute.top, relation: NSLayoutRelation.equal, view2: vRelated, attribute2: NSLayoutAttribute.top) {
            // update constant
            constraint.constant = constant;
        } else {
            // add new constraint
            vRelated.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: vRelated, attribute: NSLayoutAttribute.top, multiplier: 1, constant: constant));
        }
    }

    /*
    *  @discussion add constraint align bottom to related view with margin constant
    */
    public func addConstraintAlignBottomToView(vRelated: UIView, constant: CGFloat) {
        if let constraint = self.searchConstraintInView(vRelated, view1: self, attribute1: NSLayoutAttribute.bottom, relation: NSLayoutRelation.equal, view2: vRelated, attribute2: NSLayoutAttribute.bottom) {
            // update constant
            constraint.constant = constant;
        } else {
            // add new constraint
            vRelated.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: vRelated, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: constant));
        }
    }

    /*
    *  @discussion add constraint center x to related view with margin constant
    */
    public func addConstraintCenterXToView(vRelated: UIView, constant: CGFloat) {
        if let constraint = self.searchConstraintInView(vRelated, view1: self, attribute1: NSLayoutAttribute.centerX, relation: NSLayoutRelation.equal, view2: vRelated, attribute2: NSLayoutAttribute.centerX) {
            // update constant
            constraint.constant = constant;
        } else {
            // add new constraint
            vRelated.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: vRelated, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: constant));
        }
    }

    /*
    *  @discussion add constraint center y to related view with margin constant
    */
    public func addConstraintCenterYToView(vRelated: UIView, constant: CGFloat) {
        if let constraint = self.searchConstraintInView(vRelated, view1: self, attribute1: NSLayoutAttribute.centerY, relation: NSLayoutRelation.equal, view2: vRelated, attribute2: NSLayoutAttribute.centerY) {
            // update constant
            constraint.constant = constant;
        } else {
            // add new constraint
            vRelated.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: vRelated, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: constant));
        }
    }

    /*
    *  @discussion add constraint center to related view with margin constant
    */
    public func addConstraintCenterToView(vRelated: UIView, constant: CGFloat) {
        self.addConstraintCenterXToView(vRelated: vRelated, constant: constant);
        self.addConstraintCenterYToView(vRelated: vRelated, constant: constant);
    }

    /*
    *  @discussion add constraint fixed width
    */
    public func addConstraintFixedWidthConstant(constant: CGFloat) {
        if let constraint = self.searchConstraintInView(self, view1: self, attribute1: NSLayoutAttribute.width, relation: NSLayoutRelation.equal, view2: nil, attribute2: NSLayoutAttribute.notAnAttribute) {
            // update constant
            constraint.constant = constant;
        } else {
            // add new constraint
            self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0, constant: constant));
        }
    }

    /*
    *  @discussion add constraint fixed height
    */
    public func addConstraintFixedHeightConstant(constant: CGFloat) {
        if let constraint = self.searchConstraintInView(self, view1: self, attribute1: NSLayoutAttribute.height, relation: NSLayoutRelation.equal, view2: nil, attribute2: NSLayoutAttribute.notAnAttribute) {
            // update constant
            constraint.constant = constant;
        } else {
            // add new constraint
            self.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 0, constant: constant));
        }
    }

    /*
    *  @discussion add constraint top to followed view with margin constant
    */
    public func addConstraintAlignTopToFollowedView(vRelated: UIView, constant: CGFloat) {
        if let constraint = self.searchConstraintInView(self.superview!, view1: self, attribute1: NSLayoutAttribute.top, relation: NSLayoutRelation.equal, view2: vRelated, attribute2: NSLayoutAttribute.bottom) {
            // update constant
            constraint.constant = constant;
        } else {
            // add new constraint
            self.superview!.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: vRelated, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: constant));
        }
    }

    /*
    *  @discussion add constraint left to followed view with margin constant
    */
    public func addConstraintAlignLeftToFollowedView(vRelated: UIView, constant: CGFloat) {
        if let constraint = self.searchConstraintInView(self.superview!, view1: self, attribute1: NSLayoutAttribute.leading, relation: NSLayoutRelation.equal, view2: vRelated, attribute2: NSLayoutAttribute.trailing) {
            // update constant
            constraint.constant = constant;
        } else {
            // add new constraint
            self.superview!.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: vRelated, attribute: NSLayoutAttribute.right, multiplier: 1, constant: constant));
        }
    }
    
    /**
     Search constraint
     */
    fileprivate func searchConstraintInView(_ baseView: UIView!, view1: UIView?, attribute1: NSLayoutAttribute?, relation: NSLayoutRelation?, view2: UIView?, attribute2: NSLayoutAttribute?) -> NSLayoutConstraint? {
        // get all constraint of view
        var constraints: Array = baseView.constraints;
        let count: NSInteger = constraints.count;
        
        // search and find constraint
        for i in 0 ..< count {
            let constraint: NSLayoutConstraint = constraints[i] ;
            if (constraint.firstItem as? NSObject == view1
                && constraint.firstAttribute == attribute1
                && constraint.relation == relation
                && constraint.secondItem as? NSObject == view2
                && constraint.secondAttribute == attribute2) {
                // found constraint, return it
                return constraint;
            } // if
        } // for
        
        return nil;
    }
}

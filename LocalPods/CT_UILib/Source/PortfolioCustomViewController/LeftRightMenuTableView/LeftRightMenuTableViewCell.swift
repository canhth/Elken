//
//  LeftRightMenuTableViewCell.swift
//  PovertyChallenge
//
//  Created by david  beckz on 8/10/15.
//

import UIKit

open class LeftRightMenuTableViewCell: UITableViewCell {
    struct constants {
        static let durationAnimated: TimeInterval = 0.3
    }
    
    fileprivate(set) var vMain: UIView!
    fileprivate(set) var vLeft: UIView?
    fileprivate(set) var vRight: UIView?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /*!
     move main view to original transform to hide all left, right menu
     */
    open func closeMenu() {
        guard let vMain = vMain else { return }
        UIView.animate(withDuration: constants.durationAnimated, animations: { () -> Void in
            // close left and right menu
            vMain.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    /*!
     move main view to right to show left menu
     */
    open func openLeftMenu() {
        guard let vLeft = vLeft, let vMain = vMain else { return }
        UIView.animate(withDuration: constants.durationAnimated, animations: { () -> Void in
            vMain.transform = CGAffineTransform(translationX: vLeft.bounds.size.width + vLeft.frame.origin.x, y: 0)
        })
    }
    
    /*!
     move main view to left to show right menu
     */
    open func openRightMenu() {
        guard let vRight = vRight, let vMain = vMain else { return }
        UIView.animate(withDuration: constants.durationAnimated, animations: { () -> Void in
            vMain.transform = CGAffineTransform(translationX: -(self.contentView.bounds.size.width - vRight.frame.origin.x), y: 0)
        })
    }
    
    /**
     Double check self is opening menu left/ right ???
     */
    open func isOpeningMenu() -> Bool {
        if let vMain = vMain, vMain.transform.tx != 0 {
            return true
        } else {
            return false
        }
    }
    
    open func updateViewsAndAutoSwitchIfIsRTLLanguage(vMain: UIView? = nil, vRight: UIView? = nil, vLeft: UIView? = nil) {
        self.vMain = vMain
        self.vLeft = vLeft
        self.vRight = vRight
        if isRightToLeftLanguage {
            swapLeftViewAndRightView()
        }
    }
    
    fileprivate func swapLeftViewAndRightView() {
        let vTemp = vLeft
        vLeft = vRight
        vRight = vTemp
    }
}

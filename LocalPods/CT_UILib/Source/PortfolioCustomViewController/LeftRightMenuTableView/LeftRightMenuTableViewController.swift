//
//  LeftRightMenuTableViewController.swift
//  PovertyChallenge
//
//  Created by david  beckz on 8/10/15.
//

import UIKit

open class LeftRightMenuTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    struct constants {
        static let paddingMenu: CGFloat = 10.0
    }
    
    fileprivate var idxPathFocus: IndexPath?
    fileprivate var panGesture: UIPanGestureRecognizer!
    fileprivate var curTranslateX: CGFloat = 0
    
    open var isEnabledMenu: Bool = true
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        //
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open func setupController() {
        self.setupView()
        self.setupData()
    }
    
    fileprivate func setupView() {
        // initial pan gesture
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(LeftRightMenuTableViewController.handlePanGesture(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        self.tableView.addGestureRecognizer(panGesture)
    }
    
    fileprivate func setupData() {
        
    }
    
    /*!
    *   @discussion handle pan gesture
    */
    func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        var translation: CGPoint = gesture.translation(in: self.view)
        translation.x += curTranslateX
        
        let gesState: UIGestureRecognizerState = gesture.state
        let pPangesture: CGPoint = gesture.location(in: self.tableView)
        let idxPathGesture: IndexPath? = self.tableView.indexPathForRow(at: pPangesture)
        switch (gesState) {
        case .began:
            if let idxPathGesture = idxPathGesture {
                if let cell = self.tableView.cellForRow(at: idxPathGesture) as? LeftRightMenuTableViewCell {
                    if (cell.vLeft == nil && cell.vRight == nil) {
                        // Do nothing
                        curTranslateX = 0
                        idxPathFocus = nil
                    } else {
                        curTranslateX = cell.vMain.transform.tx
                        idxPathFocus = idxPathGesture
                    }
                }
            }
            break
            
        case .changed:
            if let idxPathFocus = idxPathFocus {
                if let cell = self.tableView.cellForRow(at: idxPathFocus) as? LeftRightMenuTableViewCell {
                    
                    // Exist vLeft, swiping from LEFT to RIGHT --> move vMain along with finger
                    if let vLeft = cell.vLeft, translation.x >= 0 && translation.x <= vLeft.bounds.size.width + vLeft.frame.origin.x + constants.paddingMenu {
                        cell.vMain.transform = CGAffineTransform(translationX: translation.x, y: 0)
                    }
                        // Exist vRight, swiping from RIGHT to LEFT --> move vMain along with finger
                    else if let vRight = cell.vRight, translation.x <= 0 && translation.x >= -(cell.contentView.bounds.size.width - vRight.frame.origin.x + constants.paddingMenu) {
                        // check right menu
                        cell.vMain.transform = CGAffineTransform(translationX: translation.x, y: 0)
                    }
                }
            }
            
            break
            
        case .ended:
            if let idxPathFocus = idxPathFocus {
                let cell = self.tableView.cellForRow(at: idxPathFocus) as! LeftRightMenuTableViewCell
                // Exist vLeft --> open the vLeft
                if let vLeft = cell.vLeft, translation.x >= (vLeft.bounds.size.width + vLeft.frame.origin.x ) / 2 {
                    cell.openLeftMenu()
                }
                // Exist vRight --> open the vRight
                else if let vRight = cell.vRight, translation.x <= -(cell.contentView.bounds.size.width - vRight.frame.origin.x) / 2 {
                    cell.openRightMenu()
                } else {
                    cell.closeMenu()
                }
                
                
                // out focus
                self.idxPathFocus = nil
            }
            
            break
            
        default:
            // Do nothing
            // out focus
            idxPathFocus = nil
            break
        }
    }
    
    open func gestureRecognizerShouldBegin(_ gesture: UIGestureRecognizer) -> Bool {
        if isEnabledMenu == true {
            let panGesture = gesture as? UIPanGestureRecognizer
            if let panGesture = panGesture, let containerView = gesture.view {
                let translation:CGPoint = panGesture.translation(in: containerView)
                
                // Check for horizontal gesture
                if (abs(translation.x) > abs(translation.y)) {
                    return true
                }
            }
        }
        
        self.closeLeftRightMenuOfAllCells()
        return false
    }
    
    /*!
     trigger close all cells to normal mode
     */
    open func closeLeftRightMenuOfAllCells() {
        let visiCells = self.tableView.visibleCells
        let iCount: Int = visiCells.count
        for i in 0 ..< iCount {
            if let cell = visiCells[mfl_atIndex: i] as? LeftRightMenuTableViewCell {
                // check menu show???
                if (cell.vMain.transform.tx != 0) {
                    // close left and right menu
                    cell.closeMenu()
                }
            }
        }
    }
}

extension Array {
        /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (mfl_atIndex index: Index) -> Iterator.Element? {
        if index < 0 || index >= self.count { return nil }
        return self[index]
    }
}

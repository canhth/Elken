//
//  AlertView.swift
//  Portfolio
//
//  Created by Khanh Pham on 3/16/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

public typealias AlertViewActionHandler = () -> Void

open class AlertView: UIView {
    fileprivate var messageLabelStyle = LabelStyleInfo(font: .systemFont(ofSize: 13), textColor: .white)
    fileprivate var actionLabelStyle = LabelStyleInfo(font: UIFont.boldSystemFont(ofSize: 13), textColor: .white)
    
    open func applyMessageLabelStyle(_ style: LabelStyleInfo) {
        self.messageLabelStyle = style
    }
    
    open func applyActionLabelStyle(_ style: LabelStyleInfo) {
        self.actionLabelStyle = style
    }
    
    open dynamic func setActionTitleFont(_ font: UIFont) {
        actionLabelStyle.font = font
    }
    
    open dynamic func setActionTitleColor(_ color: UIColor) {
        actionLabelStyle.textColor = color
        
        if let actionTitle = actionButton.titleLabel?.text {
            actionButton.setAttributedTitle(actionLabelStyle.makeAttributedString(fromString: actionTitle), for: UIControlState())
        }
    }
    
    open dynamic func setMessageFont(_ font: UIFont) {
        messageLabelStyle.font = font
    }
    
    open dynamic func setMessageTextColor(_ color: UIColor) {
        messageLabelStyle.textColor = color
        messageLabel.textColor = color
    }
    
    open dynamic func setContainerBackgroundColor(_ color: UIColor) {
        containerView?.backgroundColor = color
        containerBackgroundColor = color
    }
    
    open dynamic func setUseShadowForContainer(_ value: Bool) {
        if value {
            containerView.layer.shadowColor = UIColor.black.cgColor
            containerView.layer.shadowOpacity = 0.8
            containerView.layer.shadowRadius = 8
            containerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        } else {
            containerView.layer.shadowColor = nil
            containerView.layer.shadowOpacity = 0
            containerView.layer.shadowRadius = 0
            containerView.layer.shadowOffset = CGSize.zero
        }
    }
    
    fileprivate(set) var containerView: UIView!
    fileprivate(set) var actionButton: UIButton!
    fileprivate(set) var messageLabel: UILabel!
    fileprivate(set) var actionButtonHandler: AlertViewActionHandler?
    fileprivate(set) var dismissHandler: (() -> Void)?
    fileprivate(set) var isShowing = false
    fileprivate(set) var canDismiss = true
    
    fileprivate var containerBackgroundColor = UIColor(hex: 0x000000, a: 0.8)
    
    static let AlertHeight: CGFloat = 44.0
    static let AlertAnimDuration: TimeInterval = 0.25
    
    open static let sharedInstance = AlertView(frame: CGRect.zero)
    
    fileprivate static var dismissTimer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupComponents()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Show on top of a view.
     
     Parameter:
        - view: View will contain this alert.
        - message: Alert message
        - buttonTitle: Title of right action button. Specify nil will hide the action button.
        - actionHandler: The handle to handle TouchUpInside button event. Specify nill will hide the action button.
        - dismissDuration: alert will automatically hide after this value (include animation duration). Specify 0 or nil will prevent alert dismiss automatically. Default value is 5
     
     Return: AlertView instance
    */
    @discardableResult
    open class func showOnView(_ view: UIView, top: CGFloat = 0, withMessage message: String?, buttonTitle: String?, dismissDuration: TimeInterval? = 5, actionHandler: AlertViewActionHandler? = nil, dismissHandler: (() -> Void)? = nil) -> AlertView {
        
        let alert = sharedInstance
        
        // Remove from existing view
        alert.removeFromSuperview()
        
        alert.messageLabel.attributedText = message.map { alert.messageLabelStyle.makeAttributedString(fromString: $0) }
        
        if let btnTitle = buttonTitle, let btnHandler = actionHandler {
            alert.messageLabel.textAlignment = .left
            alert.actionButton.isHidden = false
            alert.actionButton.setAttributedTitle(alert.actionLabelStyle.makeAttributedString(fromString: btnTitle), for: UIControlState())
            alert.actionButtonHandler = btnHandler
        } else {
            alert.messageLabel.textAlignment = .center
            alert.actionButton.isHidden = true
            alert.actionButtonHandler = nil
        }
        alert.dismissHandler = dismissHandler
        alert.canDismiss = false
        
        view.addSubview(alert)
        alert.snp.remakeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        alert.actionButton.snp.remakeConstraints { (make) -> Void in
            make.right.equalTo(-10)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            if buttonTitle?.characters.count == 0 {
                make.width.equalTo(0)
            } else {
                make.width.greaterThanOrEqualTo(80)
            }
        }
        
        alert.messageLabel.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(24)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            if let buttonTitle = buttonTitle, !buttonTitle.isEmpty {
                make.right.lessThanOrEqualTo(alert.actionButton.snp.left).offset(-10)
            } else {
                make.right.equalTo(-10)
            }
        }
        
        alert.containerView.snp.remakeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(AlertHeight)
            make.top.equalTo(-AlertHeight)
        }
        alert.layoutSubviews()
        
        alert.containerView.snp.updateConstraints { (make) in
            make.top.equalTo(top)
        }
        
        alert.setNeedsLayout()
        UIView.animate(withDuration: AlertAnimDuration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            alert.layoutIfNeeded()
            }) { (_) -> Void in
                alert.isShowing = true
                mfl_delay(2, closure: {
                    alert.canDismiss = true
                })
        }
        
        dismissTimer?.invalidate()
        dismissTimer = nil
        if dismissDuration != nil && dismissDuration != 0 {
            dismissTimer = Timer.scheduledTimer(timeInterval: dismissDuration!, target: alert, selector: #selector(dismissTimerFired(_:)), userInfo: nil, repeats: false)
        }
        
        return alert
    }
    
    /**
     Dismiss this alert
    */
    open class func dismiss() {
        AlertView.dismissTimer?.invalidate()
        AlertView.dismissTimer = nil
        
        let alert = sharedInstance
        
        UIView.animate(withDuration: AlertView.AlertAnimDuration, animations: { () -> Void in
            alert.alpha = 0
            }, completion: { (_) -> Void in
                alert.removeFromSuperview()
                alert.alpha = 1
                alert.isShowing = false
                alert.dismissHandler?()
        }) 
        
    }
    
    func dismissTimerFired(_ sender: AnyObject?) {
        if isShowing {
            AlertView.dismiss()
        }
        
        AlertView.dismissTimer?.invalidate()
        AlertView.dismissTimer = nil
    }
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let pointInContainer = convert(point, to: containerView)
        if actionButton.frame.contains(pointInContainer) {
            return true
        }
        
        if canDismiss {
            AlertView.dismiss()
        }
        return false
    }
    
    
    // MARK: - Private methods
    
    fileprivate func setupComponents() {
        containerView = UIView()
        addSubview(containerView)
        
        backgroundColor = UIColor.clear
        
        messageLabel = UILabel()
        messageLabel.font = UIFont.systemFont(ofSize: 11)
        messageLabel.textColor = UIColor.white
        messageLabel.textAlignment = NSTextAlignment.left
        messageLabel.numberOfLines = 0
        
        actionButton = UIButton()
        actionButton.scaleFontToFitWidth(withInsets: UIEdgeInsets.zero)
        actionButton.addTarget(self, action: #selector(didTapActionButton(_:)), for: .touchUpInside)
        actionButton.setTitleColor(UIColor.white, for: UIControlState())
        actionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        containerView.addSubview(actionButton)
        containerView.addSubview(messageLabel)
        
        containerView.backgroundColor = containerBackgroundColor
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.8
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    func didTapActionButton(_ sender: AnyObject?) {
        actionButtonHandler?()
    }

}

func mfl_delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

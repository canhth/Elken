//
//  UIKit_Extensions.swift
//  Portfolio
//
//  Created by Thuyen Trinh on 3/30/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit
import SnapKit

public extension UIView {
    
    @discardableResult
    public func thenAddSubview(_ subview: UIView) -> UIView {
        self.addSubview(subview)
        return self
    }
    
    @discardableResult
    public func thenAddSubviews(_ subviews: UIView...) -> UIView {
        subviews.forEach { self.addSubview($0) }
        return self
    }
    
    @discardableResult
    public func thenAddSubviews(_ subviews: [UIView]) -> UIView {
        subviews.forEach { self.addSubview($0) }
        return self
    }
    
    @discardableResult
    public func mfl_removeConstraints() -> UIView {
        self.snp.removeConstraints()
        return self
    }

    @discardableResult
    public func mfl_layoutInParent(left: CGFloat? = nil, leading: CGFloat? = nil, top: CGFloat? = nil, right: CGFloat? = nil, trailing: CGFloat? = nil, centerX: CGFloat? = nil, centerY: CGFloat? = nil, bottom: CGFloat? = nil, widthScale: CGFloat? = nil, heightScale: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) -> UIView {
        snp.makeConstraints { make in
            if let leading = leading    { make.leading.equalTo(leading) }
            if let left = left      { make.left.equalTo(left) }
            if let right = right    { make.right.equalTo(right) }
            if let trailing = trailing  { make.trailing.equalTo(trailing) }
            if let top = top        { make.top.equalTo(top) }
            if let bottom = bottom    { make.bottom.equalTo(bottom) }
            if let centerX = centerX    { make.centerX.equalToSuperview().offset(centerX) }
            if let centerY = centerY    { make.centerY.equalToSuperview().offset(centerY) }
            if let widthScale = widthScale      { make.width.equalTo(self).multipliedBy(widthScale) }
            if let heightScale = heightScale    { make.height.equalTo(self).multipliedBy(heightScale) }
            if let width = width      { make.width.equalTo(width) }
            if let height = height    { make.height.equalTo(height) }
        }
        return self
    }
    
    @discardableResult
    public func mfl_layoutGreaterThanOrEqual(left: CGFloat? = nil, leading: CGFloat? = nil, top: CGFloat? = nil, right: CGFloat? = nil, trailing: CGFloat? = nil, centerX: CGFloat? = nil, centerY: CGFloat? = nil, bottom: CGFloat? = nil, widthScale: CGFloat? = nil, heightScale: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) -> UIView  {
        snp.makeConstraints { make in
            if let leading = leading    { make.leading.greaterThanOrEqualTo(leading) }
            if let left = left      { make.left.greaterThanOrEqualTo(left) }
            if let right = right    { make.right.greaterThanOrEqualTo(right) }
            if let trailing = trailing  { make.trailing.greaterThanOrEqualTo(trailing) }
            if let top = top        { make.top.greaterThanOrEqualTo(top) }
            if let bottom = bottom    { make.bottom.greaterThanOrEqualTo(bottom) }
            if let centerX = centerX    { make.centerX.greaterThanOrEqualToSuperview().offset(centerX) }
            if let centerY = centerY    { make.centerY.greaterThanOrEqualToSuperview().offset(centerY) }
            if let widthScale = widthScale      { make.width.greaterThanOrEqualTo(self).multipliedBy(widthScale) }
            if let heightScale = heightScale    { make.height.greaterThanOrEqualTo(self).multipliedBy(heightScale) }
            if let width = width      { make.width.greaterThanOrEqualTo(width) }
            if let height = height    { make.height.greaterThanOrEqualTo(height) }
        }
        return self
    }
    
    @discardableResult
    public func mfl_layoutLessThanOrEqual(left: CGFloat? = nil, leading: CGFloat? = nil, top: CGFloat? = nil, right: CGFloat? = nil, trailing: CGFloat? = nil, centerX: CGFloat? = nil, centerY: CGFloat? = nil, bottom: CGFloat? = nil, widthScale: CGFloat? = nil, heightScale: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) -> UIView {
        snp.makeConstraints { make in
            if let leading = leading    { make.leading.lessThanOrEqualTo(leading) }
            if let left = left      { make.left.lessThanOrEqualTo(left) }
            if let right = right    { make.right.lessThanOrEqualTo(right) }
            if let trailing = trailing  { make.trailing.lessThanOrEqualTo(trailing) }
            if let top = top        { make.top.lessThanOrEqualTo(top) }
            if let bottom = bottom    { make.bottom.lessThanOrEqualTo(bottom) }
            if let centerX = centerX    { make.centerX.lessThanOrEqualToSuperview().offset(centerX) }
            if let centerY = centerY    { make.centerY.lessThanOrEqualToSuperview().offset(centerY) }
            if let widthScale = widthScale      { make.width.lessThanOrEqualTo(self).multipliedBy(widthScale) }
            if let heightScale = heightScale    { make.height.lessThanOrEqualTo(self).multipliedBy(heightScale) }
            if let width = width      { make.width.lessThanOrEqualTo(width) }
            if let height = height    { make.height.lessThanOrEqualTo(height) }
        }
        return self
    }
    
    @discardableResult
    public func mfl_layoutInParent(widthScale: CGFloat? = nil, heightScale: CGFloat? = nil) -> UIView {
        snp.makeConstraints { make in
            if let widthScale = widthScale  { make.width.equalTo(self).dividedBy(widthScale) }
            if let heightScale = widthScale { make.width.equalTo(self).dividedBy(heightScale) }
        }
        return self
    }
    
    @discardableResult
    public func mfl_topSpacing(toView otherView: UIView, spacing: CGFloat = 0) -> UIView {
        snp.makeConstraints { (make) in
            make.top.equalTo(otherView.snp.bottom).offset(spacing)
        }
        return self
    }
    
    @discardableResult
    public func mfl_bottomSpacing(toView otherView: UIView, spacing: CGFloat = 0) -> UIView {
        snp.makeConstraints { (make) in
            make.bottom.equalTo(otherView.snp.top).offset(spacing)
        }
        return self
    }
    
    @discardableResult
    public func mfl_leftSpacing(toView otherView: UIView, spacing: CGFloat = 0) -> UIView {
        snp.makeConstraints { (make) in
            make.left.equalTo(otherView.snp.right).offset(spacing)
        }
        return self
    }
    
    @discardableResult
    public func mfl_rightSpacing(toView otherView: UIView, spacing: CGFloat = 0) -> UIView {
        snp.makeConstraints { (make) in
            make.right.equalTo(otherView.snp.left).offset(spacing)
        }
        return self
    }
    
    @discardableResult
    public func mfl_leadingSpacing(toView otherView: UIView, spacing: CGFloat = 0) -> UIView {
        snp.makeConstraints { (make) in
            make.leading.equalTo(otherView.snp.trailing).offset(spacing)
        }
        return self
    }
    
    @discardableResult
    public func mfl_trailingSpacing(toView otherView: UIView, spacing: CGFloat = 0) -> UIView {
        snp.makeConstraints { (make) in
            make.trailing.equalTo(otherView.snp.leading).offset(spacing)
        }
        return self
    }
    
    @discardableResult
    public func mfl_alignCenterX(toView otherView: UIView, offset: CGFloat) -> UIView {
        snp.makeConstraints { (make) in
            make.centerX.equalTo(otherView).offset(offset)
        }
        return self
    }
    
    @discardableResult
    public func mfl_alignCenterY(toView otherView: UIView, offset: CGFloat) -> UIView {
        snp.makeConstraints { (make) in
            make.centerY.equalTo(otherView).offset(offset)
        }
        return self
    }
    
    @discardableResult
    public func mfl_heightEqualTo(height: CGFloat) -> UIView {
        snp.makeConstraints { (make) in
            make.height.equalTo(height)
        }
        return self
    }
    
    @discardableResult
    public func mfl_addBorder(pos: MFLEdgePos, lineWidth: Double, edgeOffset: Double, offset1: Double = 0, offset2: Double = 0, color: UIColor) -> UIView {
        let border = UIView()
        border.backgroundColor = color
        border.tag = MFLEdgePos.getTagWithEdgePos(pos).rawValue
        self.addSubview(border)
        
        border.snp.makeConstraints { (make) -> Void in
            switch pos {
            case .top:
                make.top.equalTo(self).offset(edgeOffset)
            case .bottom:
                make.bottom.equalTo(self).offset(-edgeOffset)
                
            case .leading:
                make.leading.equalTo(self).offset(edgeOffset)
            case .trailing:
                make.trailing.equalTo(self).offset(-edgeOffset)
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

public extension UIView {
    public class func animateFading(_ outViews: [UIView], willShow inViews: [UIView], duration: Double = 0.2) {
        let outViews = outViews.filter { !inViews.contains($0) }
        let inViews = inViews.filter { return $0.isHidden }
        
        for view in outViews {
            view.isHidden = true
        }
        
        for view in inViews {
            view.alpha = 0
            view.isHidden = false
        }
        
        UIView.animate(withDuration: duration, animations: { () -> Void in
            for view in inViews {
                view.alpha = 1
            }
            }, completion: { (_) -> Void in
                
        })
        
    }
}

public extension UILabel {
    @nonobjc static let kUnderlineLayerName = "underlineLayer"
    @nonobjc static let kTopDashedLineLayerName = "kTopDashedLineLayerName"
    
    public func mfl_removeUnderline() {
        guard let subLayers = self.layer.sublayers else { return }
        guard let underlineLayer = subLayers.filter({ $0.name == UILabel.kUnderlineLayerName }).first else { return }
        
        if let index = subLayers.index(of: underlineLayer) {
            self.layer.sublayers?.remove(at: index)
        }
    }
    
    public func mfl_addDashedUnderline() {
        mfl_removeUnderline()
        
        self.sizeToFit()
        
        self.layoutIfNeeded()
        let cgColor = self.textColor.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        shapeLayer.name = UILabel.kUnderlineLayerName
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: 0)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.lineDashPattern = [1, 3]
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: shapeRect.minX, y: shapeRect.midY))
        path.addLine(to: CGPoint(x: shapeRect.maxX, y: shapeRect.midY))
        shapeLayer.path = path.cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    public func mfl_removeTopDashedLine() {
        guard let subLayers = self.layer.sublayers else { return }
        guard let topDashedLineLayer = subLayers.filter({ $0.name == UILabel.kTopDashedLineLayerName }).first else { return }
        
        if let index = subLayers.index(of: topDashedLineLayer) {
            self.layer.sublayers?.remove(at: index)
        }
    }
    
    public func mfl_addTopDashedLine(_ color: UIColor) {
        mfl_removeUnderline()
        
        self.layoutIfNeeded()
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        shapeLayer.name = UILabel.kUnderlineLayerName
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: 0)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: 0)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.lineDashPattern = [1, 3]
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: shapeRect.minX, y: shapeRect.midY))
        path.addLine(to: CGPoint(x: shapeRect.maxX, y: shapeRect.midY))
        shapeLayer.path = path.cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    // warning: - color is nil, underline will be colored textcolor
    //          - width is nil, width underline will be width of text
    public func mfl_addUnderLine(_ color: UIColor? = nil,height: CGFloat = 1, width: CGFloat? = nil, padding: CGFloat = 0) {
        mfl_removeUnderline()

        self.layoutIfNeeded()
        
        if let textString = self.text {
            var widthUnderLine: CGFloat = 0
            if let width_ = width {
                widthUnderLine = width_
            } else {
                let stringsize = textString.size(attributes: [NSFontAttributeName: self.font])
                widthUnderLine = stringsize.width
            }
            
            let underLineLayer = CALayer()
            underLineLayer.name = UILabel.kUnderlineLayerName
            underLineLayer.backgroundColor = color?.cgColor ?? self.textColor.cgColor
            
            var underlineFrame = CGRect(x: 0, y: self.bounds.size.height - padding - height, width: widthUnderLine, height: height)
            switch self.textAlignment {
            case .center:
                underlineFrame.origin.x = self.bounds.midX - underlineFrame.midX
                break
            case .right:
                underlineFrame.origin.x = self.bounds.size.width - underlineFrame.size.width
                break
            default:    // otherwise
                underlineFrame.origin.x = 0
                break
            }
            
            underLineLayer.frame = underlineFrame
            self.layer.addSublayer(underLineLayer)
        }
    }
    
    public func scaleFontToFitWidth(minScaleFactor: CGFloat = 0.7) {
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = minScaleFactor
    }
    
    public func verticallyAlignCenter() {
        self.baselineAdjustment = .alignCenters
    }
}

// MARK: - UIButton
private var pTouchAreaEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero
extension UIButton {
    // Ref: http://stackoverflow.com/questions/808503/uibutton-making-the-hit-area-larger-than-the-default-hit-area
    public var touchAreaEdgeInsets: UIEdgeInsets {
        get {
            if let value = objc_getAssociatedObject(self, &pTouchAreaEdgeInsets) as? NSValue {
                var edgeInsets = UIEdgeInsets.zero
                value.getValue(&edgeInsets)
                return edgeInsets
            }
            else {
                return UIEdgeInsets.zero
            }
        }
        set(newValue) {
            var newValueCopy = newValue
            let objCType = NSValue(uiEdgeInsets: UIEdgeInsets.zero).objCType
            let value = NSValue(&newValueCopy, withObjCType: objCType)
            objc_setAssociatedObject(self, &pTouchAreaEdgeInsets, value, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if UIEdgeInsetsEqualToEdgeInsets(self.touchAreaEdgeInsets, UIEdgeInsets.zero) || !self.isEnabled || self.isHidden {
            return super.point(inside: point, with: event)
        }
        
        let relativeFrame = self.bounds
        let hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.touchAreaEdgeInsets)
        
        return hitFrame.contains(point)
    }
    
    public func scaleFontToFitWidth(withInsets insets: UIEdgeInsets, minScaleFactor: CGFloat = 0.7) {
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.minimumScaleFactor = minScaleFactor
        self.contentEdgeInsets = insets
        self.contentVerticalAlignment = .center
    }
    
    public func verticallyAlignCenter() {
        self.titleLabel?.baselineAdjustment = .alignCenters
    }
    
    //FIXME: thcanh - Set accessibility identifier of button when it's nil
    #if DEBUG || STAGING
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.accessibilityIdentifier == nil {
            // Set default value of accessibility Label if needed
            if self.accessibilityLabel == nil {
                self.accessibilityLabel = "unknowAccessibilityUIButton"
            }
            self.accessibilityIdentifier = self.accessibilityLabel ?? "unknowAccessibilityIdUIButton"
        }
    }
    #endif
}

// MARK: - UIApplication
public extension UIApplication {
    
    public class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
    public class func topViewControllerIgnorePopover(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController, presented.modalPresentationStyle != .popover {
            return topViewController(presented)
        }
        return base
    }
}

// MARK: - UIWindow
public extension UIWindow {
    
    /// Visible view controller from rootViewController
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    public static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}

// MARK: - UIEdgeInsets
public extension UIEdgeInsets {
    public static func insetBy(_ inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
}

// MARK: - UIViewController
public extension UIViewController {
    // get top viewcontroller of self
    public func topViewController() -> UIViewController {
        var topVC = self
        while let presentedVC = topVC.presentedViewController {
            topVC = presentedVC
        }
        return topVC
    }
    
    public func dismissViewControllerRecursive(animated flag: Bool, completion: (() -> Void)?) {
        var vc = self.presentingViewController
        while let _ = vc?.presentingViewController {
            vc = vc?.presentingViewController
        }
        
        if let presentingVC = vc {
            presentingVC.dismiss(animated: flag, completion: completion)
        } else {
            // Found no presenting view controller
            completion?()
        }
    }
    
    public func dismissToViewControllerRecursive(viewController: UIViewController.Type, animated flag: Bool, completion: (() -> Void)?) {
        var vc = self.presentingViewController
        while let presentingViewController = vc?.presentingViewController {
            if presentingViewController.isKind(of: viewController) == true {
                break
            } else {
                vc = vc?.presentingViewController
            }
        }
        
        if let presentingVC = vc {
            presentingVC.dismiss(animated: flag, completion: completion)
        } else {
            // Found no presenting view controller
            completion?()
        }
    }
    
    /*
     *  only dismiss viewcontroller when it hasnot presented any viewcontrollers
     *  Note: if this viewcontroller has presented another viewcontroller, so waiting for that it hasnot presented any viewcontrollers
     */
    public func dismisViewControllerPreventPresented(animated flag: Bool, completion: (() -> Void)?) {
        DispatchQueue.global(qos: .default).async(execute: {
            // waiting for that this viewcontroller hasnot presented any viewcontrollers
            while let _ = self.presentedViewController {
                sleep(1)
            }
            
            DispatchQueue.main.async(execute: {
                self.dismiss(animated: flag, completion: completion)
            })
        });
    }
    
    public func isPresentedModally() -> Bool {
        if presentingViewController != nil { return true }
        if presentingViewController?.presentedViewController == self { return true }
        if navigationController?.presentingViewController?.presentedViewController == navigationController  { return true }
        if tabBarController?.presentingViewController is UITabBarController { return true }
        return false
    }
    
    public func popOrDismissIfPresentedModally(animated: Bool = true) {
        if isPresentedModally() {
            dismiss(animated: animated, completion: nil)
        } else {
            _ = navigationController?.popViewController(animated: animated)
        }
    }
    
    public var isPresentedModal: Bool {
        if let navi = self.navigationController {
            if self == navi.viewControllers.first {
                return true
            }
        }
        return false
    }
    
    func popToViewController<T: UIViewController>(type: T.Type, animated: Bool) -> Bool {
        if let controllers = self.navigationController?.viewControllers {
            let endIndex = controllers.count - 1
            for i in (0..<endIndex).reversed() {
                let controller = controllers[i]
                if type(of: controller) == type {
                    _ = self.navigationController?.popToViewController(controller, animated: animated)
                    return true
                }
            }
        }
        return false
    }
}


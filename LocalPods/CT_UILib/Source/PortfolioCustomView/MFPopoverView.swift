//
//  MFPopoverView.swift
//  Portfolio
//
//  Created by Khanh Pham on 6/5/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

class MFPopoverView: UIView {

    var showFromRect: CGRect!
    var message: String!
    var popupColor: UIColor!
    var textAttributes: [String: AnyObject]!
    
    var arrowWidth: CGFloat = 10
    var arrowHeight: CGFloat = 6
    var arrowMargin: CGFloat = 4
    var popupMargin: CGFloat = 10
    var popupPadding: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    func setupDefaults() {
        let textStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = .left
        textAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 11),
            NSForegroundColorAttributeName: UIColor(white: 56.0 / 255.0, alpha: 1.0),
            NSParagraphStyleAttributeName: textStyle]
        
        popupColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // Calculate text size
        let drawingOptions: NSStringDrawingOptions = [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading]
        
        let textSize: CGSize = NSString(string: message).boundingRect(with: CGSize(width: rect.width - 2 * (popupPadding + popupMargin), height: 10000), options: drawingOptions, attributes: textAttributes, context: nil).size
        
        // Popup
        ctx.saveGState()
        let popupFrame = CGRect(origin: CGPoint(x: rect.minX + popupMargin, y: showFromRect.origin.y - arrowMargin - textSize.height - 2 * (popupPadding)), size: CGSize(width: textSize.width + 2 * (popupPadding), height: textSize.height + 2 * (popupPadding)) )
        let popupPath = UIBezierPath(roundedRect: popupFrame, cornerRadius: 5)
        popupColor.setFill()
        popupPath.fill()
        ctx.restoreGState()
        
        // Arrow
        let arrowFrame = CGRect(x: showFromRect.origin.x + ((showFromRect.size.width - arrowWidth) * 0.5), y: showFromRect.origin.y - arrowMargin, width: arrowWidth, height: arrowHeight)
        ctx.saveGState()
        ctx.translateBy(x: arrowFrame.origin.x, y: arrowFrame.origin.y)
        
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: 0, y: 0))
        arrowPath.addLine(to: CGPoint(x: arrowFrame.width * 0.5, y: arrowFrame.height))
        arrowPath.addLine(to: CGPoint(x: arrowFrame.width, y: 0))
        arrowPath.close()
        popupColor.setFill()
        arrowPath.fill()
        ctx.restoreGState()
        
        // Text
        let textFrame = CGRect(origin: CGPoint(x: popupFrame.origin.x + popupPadding, y: popupFrame.origin.y + popupPadding), size: textSize)
        ctx.saveGState()
        ctx.clip(to: textFrame);
        message.draw(in: textFrame, withAttributes: textAttributes)
        ctx.restoreGState()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        dismiss()
        return false
    }
    
    func dismiss() {
        removeFromSuperview()
    }
    
    class func showFromRect(_ rect: CGRect, inView view: UIView, message: String, backgroundColor: UIColor? = nil, textAttributes: [String: AnyObject]? = nil) -> MFPopoverView {
        let popup = MFPopoverView()
        popup.message = message
        
        if backgroundColor != nil {
            popup.backgroundColor = backgroundColor!
        }
        
        if textAttributes != nil {
            popup.textAttributes = textAttributes
        }
        
        popup.showFromRect = rect
        popup.backgroundColor = UIColor.clear
        
        view.addSubview(popup)
        popup.translatesAutoresizingMaskIntoConstraints = false
        let viewDict = ["popUp": popup]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[popUp]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: viewDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[popUp]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: viewDict))
        
        return popup
    }

}

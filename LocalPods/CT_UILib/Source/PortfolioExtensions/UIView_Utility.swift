//
//  UIView_Utility.swift
//  Portfolio
//
//  Created by Phan Anh Duy on 6/9/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

// MARK: - Extension UIView
public extension UIView {
    // MARK:- constants
    fileprivate struct constants {
        static let circleBoderLayerName = "circleLayerName"
    }
    
    public func removeSubviews() {
        for vTemp in subviews {
            vTemp.removeFromSuperview();
        }
    }
    
    public func screenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        var image: UIImage?
        // NOTE: UIGraphicsGetCurrentContext return NIL whenever self.bound.size = zero
        if let curContext = UIGraphicsGetCurrentContext() {
            self.layer.render(in: curContext)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
    public func addCircleBorder(_ color: UIColor? = nil, isDashed: Bool = true, width: CGFloat = 1) {
        let borderColor = color != nil ? color?.cgColor : UIColor.gray.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: width, y: width, width: frameSize.width - 2*width, height: frameSize.height - 2*width)
        
        shapeLayer.name = constants.circleBoderLayerName
        shapeLayer.bounds = shapeRect
        shapeLayer.position = self.bounds.center
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = borderColor
        shapeLayer.lineWidth = width
        if isDashed {
            shapeLayer.lineJoin = kCALineJoinRound
            shapeLayer.lineDashPattern = [2,3]
        }
        shapeLayer.path = UIBezierPath(arcCenter: center, radius: (shapeRect.width * 0.5), startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true).cgPath
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
    public func removeCircleBorder() {
        guard let subLayers = self.layer.sublayers else { return }
        guard let underlineLayer = subLayers.filter({ $0.name == constants.circleBoderLayerName }).first else { return }
        
        if let index = subLayers.index(of: underlineLayer) {
            self.layer.sublayers?.remove(at: index)
        }
    }

    public func didEnabled(_ enabled: Bool) {
        if enabled {
            alpha = 1.0
        } else {
            alpha = 0.3
        }
    }
}

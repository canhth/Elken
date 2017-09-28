//
//  ThreeDotsAnimationView.swift
//  Portfolio
//
//  Created by Khanh Pham on 3/31/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import Foundation
import UIKit

open class ThreeDotsAnimationView: UIView {
    
    open var dotColor: UIColor = UIColor.lightGray {
        didSet {
            configure()
        }
    }
    
    open var dotWidth: CGFloat = 15.0 {
        didSet {
            configure()
        }
    }
    
    open var dotSpacing: CGFloat = 10.0 {
        didSet {
            configure()
        }
        
    }
    
    open var numberOfDots: Int = 3 {
        didSet {
            configure()
        }
    }
    
    open var animating: Bool = false {
        didSet {
            if animating {
                animate()
            } else {
                stopAnimate()
            }
        }
    }
    
    fileprivate let dotLayer = CALayer()
    fileprivate let replicatorLayer = CAReplicatorLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeComponents()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        initializeComponents()
        print("awakeFromNib")
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initializeComponents()
        print("prepareForInterfaceBuilder")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
    fileprivate func initializeComponents() {
        setup()
        configure()
    }
    
    fileprivate func setup() {
        replicatorLayer.addSublayer(dotLayer)
        layer.addSublayer(replicatorLayer)
    }
    
    fileprivate func configure() {
        replicatorLayer.frame = bounds
        replicatorLayer.instanceCount = numberOfDots
        replicatorLayer.instanceDelay = 0.2
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(dotWidth + dotSpacing, 0, 0)
        
        dotLayer.frame = CGRect(x: 0, y: 0, width: dotWidth, height: dotWidth)
        dotLayer.cornerRadius = dotWidth * 0.5
        dotLayer.position = CGPoint(x: bounds.midX - (CGFloat(numberOfDots) * 0.5 - 0.5) * (dotWidth + dotSpacing), y: bounds.midY)
        dotLayer.backgroundColor = dotColor.cgColor
    }
    
    func animate() {
        
        let mainAnim = CAAnimationGroup()
        
        let duration = 0.5
        
        let jumpAnim = CABasicAnimation(keyPath: "position.y")
        jumpAnim.toValue = dotLayer.position.y - 20
        jumpAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.toValue = 0.5
        
        mainAnim.animations = [jumpAnim, opacityAnim]
        mainAnim.duration = duration
        mainAnim.repeatCount = Float.infinity
        mainAnim.autoreverses = true
        mainAnim.isRemovedOnCompletion = false
        
        dotLayer.add(mainAnim, forKey: "MainAnimation")
    }
    
    func stopAnimate() {
        dotLayer.removeAnimation(forKey: "MainAnimation")
    }
}

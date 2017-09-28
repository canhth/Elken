//
//  ProgressView.swift
//  Portfolio
//
//  Created by Khanh Pham on 3/4/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

open class ProgressView: UIView {
    
    // Background color of circle
    open var ellipseColor: UIColor = UIColor.lightGray {
        didSet {
            configure()
        }
    }
    
    // Background color of circle
    open var progressEllipseColor: UIColor = UIColor.gray {
        didSet {
            configure()
        }
    }
    
    open var completeEllipseColor: UIColor = UIColor.lightGray {
        didSet {
            
        }
    }
    
    open var ellipseWidth: CGFloat = 4.0 {
        didSet {
            configure()
        }
    }
    
    open var progressEllipseWidth: CGFloat = 8.0 {
        didSet {
            configure()
        }
    }
    
    // Value from 0 to 1
    open var progress: Double = 0.0 {
        didSet {
            updateProgress()
        }
    }
    
    open var completeImage: UIImage? {
        didSet {
            completeImageView.image = completeImage
        }
    }
    
    open var numberOfCircles = 16
    
    open var replicatorLayer = CAReplicatorLayer()
    open var circleLayer = CALayer()
    open var progressReplicatorLayer = CAReplicatorLayer()
    open var progressCircleLayer = CALayer()
    
    open var completeImageView = UIImageView()
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("public init(coder:) has not been implemented")
//    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        replicatorLayer.frame = self.bounds
        progressReplicatorLayer.frame = self.bounds
        configure()
        
//        circleLayer.frame = CGRect(x: CGRectGetMidX(self.bounds) - ellipseWidth / 2.0, y: 0, width: ellipseWidth, height: ellipseWidth)
    }
    
    fileprivate func setup() {
        layer.addSublayer(replicatorLayer)
        replicatorLayer.addSublayer(circleLayer)
        layer.addSublayer(progressReplicatorLayer)
        progressReplicatorLayer.addSublayer(progressCircleLayer)
        configure()
        
        completeImageView.isHidden = true
        addSubview(completeImageView)
        completeImageView.snp.remakeConstraints { (make) -> Void in
            make.center.equalToSuperview()
        }
    }
    
    fileprivate func configure() {
        configureReplicatorLayer()
        configureCircleLayer()
        
        configureProgressReplicatorLayer()
        configureProgressCircleLayer()
    }
    
    fileprivate func configureReplicatorLayer() {
        replicatorLayer.frame = self.bounds
        replicatorLayer.instanceDelay = 1.0 / Double(numberOfCircles)
        replicatorLayer.instanceCount = numberOfCircles
        
        let angle = Float(.pi * 2.0) / Float(numberOfCircles)
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0, 0, 1.0)
    }
    
    fileprivate func configureCircleLayer() {
        circleLayer.backgroundColor = ellipseColor.cgColor
        let y = abs(progressEllipseWidth - ellipseWidth) - (ellipseWidth / 2.0)
        circleLayer.frame = CGRect(x: self.bounds.midX - ellipseWidth / 2.0, y: y, width: ellipseWidth, height: ellipseWidth)
        circleLayer.cornerRadius = ellipseWidth / 2
        circleLayer.opacity = 1
    }
    
    fileprivate func configureProgressReplicatorLayer() {
        progressReplicatorLayer.frame = self.bounds
        progressReplicatorLayer.instanceDelay = 1.0 / Double(numberOfCircles)
        
        let angle = Float(.pi * 2.0) / Float(numberOfCircles)
        progressReplicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0, 0, 1.0)
        
        updateProgress()
    }
    
    fileprivate func configureProgressCircleLayer() {
        progressCircleLayer.backgroundColor = progressEllipseColor.cgColor
        let y = abs(progressEllipseWidth - ellipseWidth) - (progressEllipseWidth / 2.0)
        progressCircleLayer.frame = CGRect(x: self.bounds.midX - progressEllipseWidth / 2.0, y: y, width: progressEllipseWidth, height: progressEllipseWidth)
        progressCircleLayer.cornerRadius = progressEllipseWidth / 2
        progressCircleLayer.opacity = 1
    }
    
    open func updateProgress() {
        let instanceCount = instanceCountForProgress()
        progressReplicatorLayer.isHidden = instanceCount == 0
        progressReplicatorLayer.instanceCount = instanceCount + 1
    }
    
    open func makeCompleted() {
        progress = 1.0
        completeImageView.isHidden = false
        progressCircleLayer.backgroundColor = completeEllipseColor.cgColor
    }
    
    fileprivate func instanceCountForProgress() -> Int {
        let count = Int(floor(progress * Double(numberOfCircles)))
        
        return count
    }
    
}

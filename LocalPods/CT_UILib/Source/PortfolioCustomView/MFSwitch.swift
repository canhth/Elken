//
//  MFSwitch.swift
//  Portfolio
//
//  Created by Hung Le on 8/9/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import Foundation

public protocol MFSwitchDelegate: class {
    func switchChangeValue(_ isOn: Bool)
}

open class MFSwitch: UIControl {
    fileprivate var imageView = UIImageView()
    
    open weak var delegate: MFSwitchDelegate?
    
    open var touchAreaEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    
    open var onImage: UIImage?
    open var offImage: UIImage?
    
    open var isOn: Bool = true {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        imageView.isUserInteractionEnabled = true
        self.addSubview(imageView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MFSwitch.didTapped(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = UIEdgeInsetsInsetRect(bounds, touchAreaEdgeInsets)
        return rect.contains(point)
    }
    
    func setupLayout() {
        imageView.snp.remakeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        UIView.transition(with: self.imageView, duration: 0.15, options: .transitionCrossDissolve, animations: { () -> Void in
            if self.isOn {
                self.imageView.image = self.onImage
            } else {
                self.imageView.image = self.offImage
            }
        }) { (finished) -> Void in
            //
        }
        
    }
    
    func didTapped(_ sender: UITapGestureRecognizer) {
        isOn = !self.isOn
        self.delegate?.switchChangeValue(isOn)
        self.sendActions(for: .valueChanged)
    }
    
}

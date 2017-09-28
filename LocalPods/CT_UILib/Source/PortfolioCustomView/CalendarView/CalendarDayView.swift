//
//  CalendarDayView.swift
//  Portfolio
//
//  Created by Thuyen Trinh on 3/9/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

open class DayCircleView: UIView {
    
    open static let DiameterScaleFromIphone6: CGFloat = {
        let screenType = MFLScreenSize.CurrentType
        if screenType == .ip6Plus {
            return 1.1
        } else if screenType == .ip4S || screenType == .ip5 {
            return 0.6
        } else {
            return 1
        }
    }()

    open var diameterInIphone6: CGFloat = 0 {
        didSet { setNeedsLayout() }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let inset = (self.frame.width - diameterInIphone6 * DayCircleView.DiameterScaleFromIphone6) / 2
        self.bounds = self.frame.insetBy(dx: inset, dy: inset)
        self.layer.cornerRadius = self.frame.width / 2
    }
}

// Create BaseCalendarDayCell to customize without inherit from CelendarDayCell
open class BaseCalendarDayCell: UICollectionViewCell {
    open func configureCell(_ date: Date, optionalData: AnyObject?) { }
    open func configureLongPressState(_ isPress: Bool) { }
    open func prepareForAnimateAppearing(_ shouldAnimate: Bool) { }
    open func animateAppearing(_ delay: TimeInterval) { }
}

open class CalendarDayCell: BaseCalendarDayCell {

    open var date: Date = Date(timeIntervalSince1970: 0) {
        didSet {
            dateLabel.text = "\(date.day())"
        }
    }

    override open func configureCell(_ date: Date, optionalData: AnyObject?) {
        self.date = date
    }
    
    override open func configureLongPressState(_ isPressing: Bool) {
        
    }
    
    override open func animateAppearing(_ delay: TimeInterval) {
        self.circleView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.2, delay: delay, options: .curveLinear
            , animations: {
                self.circleView.isHidden = false
                self.circleView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
    }
    
    override open func prepareForAnimateAppearing(_ shouldAnimate: Bool = false) {
        self.circleView.isHidden = shouldAnimate
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        
        self.circleView.isHidden = false
        dateLabel.text = ""
    }
    
    open let circleView: DayCircleView = {
        let view = DayCircleView()
        view.diameterInIphone6 = 20
        return view
    }()
    
    open let dateLabel: UILabel = {
        let style = LabelStyleInfo(
            font: UIFont.systemFont(ofSize: 12 * kFontSizeScaleFromIPhone6),
            textColor: UIColor.lightGray,
            charSpacing: 0,
            lineSpacing: 1
        )
        let label = UILabel()
        label.textColor = style.textColor
        label.font = style.font
        label.textAlignment = .center
        return label
    }()
    
    open let toDayIndicatorView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    open var toDayIndicatorViewHeight: Double {
        return 1.5
    }
    
    open var toDayIndicatorViewWidth: Double {
        return 16
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupLayout()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        circleView.layer.cornerRadius = circleView.frame.width / 2
    }
    
    
    fileprivate func setupView() {
        addSubview(circleView)
        addSubview(dateLabel)
        addSubview(toDayIndicatorView)
    }
    
    fileprivate func setupLayout() {
        circleView.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(self.snp.top)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(self.circleView.snp.width)
            make.bottom.equalTo(self.dateLabel.snp.top)
        }
        
        dateLabel.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom).offset(-2)
        }
        
        toDayIndicatorView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self)
            make.width.equalTo(toDayIndicatorViewWidth)
            make.height.equalTo(toDayIndicatorViewHeight)
        }
    }
}

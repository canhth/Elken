//
//  MFChartDescriptionView.swift
//  Portfolio
//
//  Created by Khanh Pham on 6/29/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

open class MFChartDescriptionView: UIView {
    public enum MFChartDescriptionViewType: Int {
        case circle = 1
        case square = 2
    }
    
    open var labelStyleInfo: LabelStyleInfo? {
        didSet {
            guard let info = labelStyleInfo else { return }
            descriptionLabels.forEach { (label) in
                label.applyStyle(info)
            }
        }
    }
    
    open var infos: [(value: String, color: UIColor)] = [] {
        didSet {
            if infos.count == oldValue.count && columnViews.count > 0 {
                // Just update info
                (0..<infos.count).forEach { index in
                    descriptionLabels[index].text = infos[index].value
                    descriptionCircleViews[index].backgroundColor = infos[index].color
                }
            } else {
                // Re-setup
                setup()
                layoutIfNeeded()
            }
        }
    }
    
    open fileprivate(set) var columnViews: [UIView] = []
    open fileprivate(set) var descriptionLabels: [RichLabel] = []
    open fileprivate(set) var descriptionCircleViews: [UIView] = []
    open var descriptionType: MFChartDescriptionViewType = .circle
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if self.descriptionType == .circle {
            // Make circle views circle
            descriptionCircleViews.forEach { $0.layer.cornerRadius = $0.frame.width / 2 }
        }
    }
    
    fileprivate func setup() {
        setupView()
        setupLayout()
    }
    
    fileprivate func setupView() {
        let labelStyle = labelStyleInfo ?? LabelStyleInfo(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.black)
        
        columnViews.forEach { $0.removeFromSuperview() }
        
        // Create columns and add to self
        columnViews = infos.map { _ in UIView() }
        columnViews.forEach { self.addSubview($0) }
        descriptionLabels = infos.map { (info, _) in
            let label = RichLabel(style: labelStyle)
            label.text = info
            return label
        }
        
        descriptionCircleViews = infos.map { (_, color) in
            let circleView = UIView()
            circleView.backgroundColor = color
            return circleView
        }
        
        columnViews.enumerated().forEach { index, columnView in
            columnView.addSubview(descriptionLabels[index])
            columnView.addSubview(descriptionCircleViews[index])
        }
    }
    
    fileprivate func setupLayout() {
        // Column views
        guard let firstColumView = columnViews.first, let lastColumnView = columnViews.last else { return }
        firstColumView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.left.equalTo(self)
        }
        
        lastColumnView.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.right.equalTo(self)
        }
        
        (1..<columnViews.count).forEach { index in
            let previousColumnView = columnViews[index - 1]
            columnViews[index].snp.makeConstraints({ (make) in
                make.top.equalTo(firstColumView)
                make.bottom.equalTo(firstColumView)
                make.width.equalTo(firstColumView)
                make.left.equalTo(previousColumnView.snp.right)
            })
        }
        
        // Inside each column view
        columnViews.enumerated().forEach { index, columnView in
            descriptionLabels[index].snp.makeConstraints({ (make) in
                make.top.equalTo(columnView)
                make.bottom.equalTo(columnView)
                 make.leading.greaterThanOrEqualTo(17)
                make.centerX.equalTo(columnView)
            })
            descriptionCircleViews[index].snp.makeConstraints({ (make) in
                make.width.equalTo(10)
                make.height.equalTo(10)
                make.centerY.equalTo(descriptionLabels[index])
                make.right.equalTo(descriptionLabels[index].snp.left).offset(-7)
            })
        }
    }
    
}

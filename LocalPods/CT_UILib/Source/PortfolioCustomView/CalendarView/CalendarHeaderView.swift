//
//  CalendarHeaderView.swift
//  Portfolio
//
//  Created by Thuyen Trinh on 3/10/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

open class CalendarHeaderView: UIView {
    
    open var labelStyle: LabelStyleInfo? = LabelStyleInfo(
        font: UIFont.systemFont(ofSize: 12 * kFontSizeScaleFromIPhone6),
        textColor: UIColor.lightGray,
        charSpacing: 0,
        lineSpacing: 1
        )
        
        {
        didSet {
            symbolLabels.forEach { (label) in
                label.font = labelStyle?.font
                label.textColor = labelStyle?.textColor
            }
        }
    }

    open var symbols: [String] = [] {
        didSet {
            setup()
        }
    }
    
    fileprivate var symbolLabels: [UILabel] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        setupView()
        setupLayout()
    }
    
    func setupView() {
        // Remove symbolLabels
        symbolLabels.forEach { $0.removeFromSuperview() }
        
        // Create columns and add to self
        symbolLabels = symbols.map { symbol in
            let style = self.labelStyle ?? LabelStyleInfo(font: UIFont.systemFont(ofSize: 13), textColor: UIColor.lightText)
            let label = UILabel()
            label.text = symbol
            label.textColor = style.textColor
            label.font = style.font
            label.textAlignment = .center
            return label
        }
        
        // Add subviews
        symbolLabels.forEach { self.addSubview($0) }
    }
    
    func setupLayout() {
        let numberOfColumns = symbols.count
        
        if let firstColumnView = symbolLabels.first, let lastColumnView = symbolLabels.last {
            firstColumnView.snp.makeConstraints({ (make) -> Void in
                make.left.equalTo(self.snp.left)
                make.top.equalTo(self.snp.top)
                make.bottom.equalTo(self.snp.bottom)
            })
            
            lastColumnView.snp.makeConstraints({ (make) -> Void in
                make.right.equalTo(self.snp.right)
                make.top.equalTo(self.snp.top)
                make.bottom.equalTo(self.snp.bottom)
            })
            
            (1..<numberOfColumns).forEach { index in
                let previousColumnView = self.symbolLabels[index - 1]
                self.symbolLabels[index].snp.makeConstraints({ (make) -> Void in
                    make.top.equalTo(self.snp.top)
                    make.bottom.equalTo(self.snp.bottom)
                    make.width.equalTo(firstColumnView.snp.width)
                    make.left.equalTo(previousColumnView.snp.right)
                })
            }
        }
    }
}

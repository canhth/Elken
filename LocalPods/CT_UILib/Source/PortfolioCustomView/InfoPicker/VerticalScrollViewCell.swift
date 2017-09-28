//
//  VerticalScrollViewCell.swift
//  Portfolio
//
//  Created by Thuyen Trinh on 3/3/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

class VerticalScrollViewCell: UICollectionViewCell {
    fileprivate var valueLabel = UILabel(frame: CGRect.zero)
    
    struct Constants {
        static let REUSE_IDENTIFIER = "VerticalScrollViewCellReuseIdentifier"
    }
    
    var valueText: String = "" {
        didSet { self.setNeedsLayout() }
    }
    
    var font: UIFont = UISettings_PickerView.defaultSetting().labelStyle_SelectedValue.font {
        didSet { self.setNeedsLayout() }
    }
    
    var textColor: UIColor = UISettings_PickerView.defaultSetting().labelStyle_SelectedValue.textColor {
        didSet { self.setNeedsLayout() }
    }
    
    var layoutAlign: VerticalScrollViewLayoutAlign = .center {
        didSet {
            setupLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        valueLabel.text = valueText
        valueLabel.font = font
        valueLabel.textColor = textColor
    }
    
    fileprivate func setupView() {
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = font
        valueLabel.textColor = textColor
        valueLabel.textAlignment = .center
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.numberOfLines = 0
        contentView.addSubview(valueLabel)
    }
    
    fileprivate func setupLayout() {
        switch layoutAlign {
        case .center:
            valueLabel.snp.remakeConstraints { (make) -> Void in
                make.center.equalTo(self.contentView)
                make.height.equalTo(self.contentView.snp.height)
                make.width.equalTo(self.contentView.snp.width).multipliedBy(0.8)
            }
        case .left:
            valueLabel.snp.remakeConstraints { (make) -> Void in
                make.left.equalTo(self.contentView)
                make.centerY.equalTo(self.contentView)
                make.height.equalTo(self.contentView.snp.height)
                make.width.equalTo(self.contentView.snp.width).multipliedBy(0.8)
            }
        case .right:
            valueLabel.snp.remakeConstraints { (make) -> Void in
                make.right.equalTo(self.contentView)
                make.centerY.equalTo(self.contentView)
                make.height.equalTo(self.contentView.snp.height)
                make.width.equalTo(self.contentView.snp.width).multipliedBy(0.8)
            }
        }
    }
}

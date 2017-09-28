//
//  MFRadioButtonCell.swift
//  Portfolio
//
//  Created by Thanh Duyet on 7/2/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

open class MFRadioButtonCell: UITableViewCell {
    open static let Identifier = "\(type(of: self).self)"
    
    open fileprivate(set) var radioButton: RadioButton = {
        return RadioButton()
    }()
    
    open var selectedColor: UIColor! {
        didSet {
            radioButton.selectedColor = selectedColor
        }
    }
    
    open var labelStyle: LabelStyleInfo? = nil {
        didSet {
            radioButton.labelStyle = labelStyle
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        
        radioButton.isSelected = false
    }
    
    fileprivate func setupView() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(radioButton)
    }
    
    fileprivate func setupLayout() {
        radioButton.snp.remakeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
}

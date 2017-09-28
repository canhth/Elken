//
//  MFDotLabel.swift
//  Portfolio
//
//  Created by Thanh Duyet on 8/31/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

open class MFDotLabel: UIView {
    
    open var labelStyle: LabelStyleInfo? = nil {
        didSet {
            if let style = labelStyle {
                dotLabel.applyStyle(style)
                textLabel.applyStyle(style)
                textLabel.numberOfLines = 0
                textLabel.mf_textAlignment = .left
            }
        }
    }
    
    open var text: String? = nil {
        didSet {
            textLabel.text = text
        }
    }
    
    open var spacingBetweenDotAndText: Double = 10.0 {
        didSet {
            setupLayout()
        }
    }
    
    fileprivate let dotLabel: RichLabel = {
        let view = RichLabel()
        view.text = "•"
        return view
    }()
    
    fileprivate let textLabel = RichLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        addSubview(dotLabel)
        addSubview(textLabel)
    }
    
    fileprivate func setupLayout() {
        dotLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(self)
//            make.centerY.equalTo(textLabel).offset(0)
            make.top.equalTo(textLabel).offset(3.5)
            make.width.equalTo(dotLabel.font.estimatedHeightForOneLineText())
        }
        
        textLabel.snp.remakeConstraints { (make) in
            make.leading.equalTo(dotLabel.snp.trailing).offset(spacingBetweenDotAndText)
            make.trailing.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
}

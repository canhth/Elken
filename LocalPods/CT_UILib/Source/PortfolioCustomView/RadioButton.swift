//
//  RadioButton.swift
//  Portfolio
//
//  Created by Thanh Duyet on 5/10/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

open class RadioButton: UIView {
    open var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    open var isSelected: Bool = false {
        didSet {
            titleLabel.isEnabled = isSelected
            animateShowFillCircle()
        }
    }
    
    fileprivate var titleLabel: RichLabel = {
        let view = RichLabel()
        view.textAlignment = .left
        return view
    }()
    
    fileprivate let circleView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    fileprivate let fillCircleView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.brown.cgColor
        view.alpha = 0
        return view
    }()
    
    open var selectedColor: UIColor = UIColor.brown {
        didSet {
            fillCircleView.layer.backgroundColor = selectedColor.cgColor
        }
    }
    
    open var labelStyle: LabelStyleInfo? = nil {
        didSet {
            if let style = labelStyle {
                titleLabel.applyStyle(style)
            }
        }
    }
    
    override init(frame: CGRect) {
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
        fillCircleView.layer.cornerRadius = fillCircleView.frame.width / 2
    }
    
    fileprivate func setupView() {
        self.addSubview(titleLabel)
        self.addSubview(circleView)
        self.addSubview(fillCircleView)
    }
    
    fileprivate func setupLayout() {
        titleLabel.snp.remakeConstraints { (make) -> Void in
            make.left.equalTo(self).offset(30)
            make.centerY.equalTo(self)
            make.height.equalTo(ThemeUtil.estimatedHeightForOneLineText(font: titleLabel.font))
            
        }
        
        circleView.snp.remakeConstraints { (make) -> Void in
            make.right.equalTo(-30)
            make.centerY.equalTo(self)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        fillCircleView.snp.remakeConstraints { (make) -> Void in
            make.center.equalTo(circleView)
            make.height.equalTo(circleView).multipliedBy(0.7)
            make.width.equalTo(fillCircleView.snp.height)
        }
    }
    
    fileprivate func animateShowFillCircle() {
        UIView.animate(withDuration: 0.3, animations: {
            self.fillCircleView.alpha = self.isSelected ? 1 : 0
        }) 
    }
}

//
//  MFColumnsInfoView.swift
//  Portfolio
//
//  Created by Thanh Duyet on 6/8/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

//public typealias MFColumnInfo = MFColumnInfo(value: String, valueDescription: String)

public enum MFColumnInfoIndicator {
    case circle(fillColor: UIColor?, strokeColor: UIColor?, strokeWidth: CGFloat?)
    case squareBullet(fillColor: UIColor?, strokeColor: UIColor?, strokeWidth: CGFloat?)
}


public struct MFColumnInfo {
    public var value: String = ""
    public var valueDescription: String = ""
    public var indicator: MFColumnInfoIndicator?
    public var valueTextColor: UIColor?
    
    public init(value: String, valueDescription: String, circleColor: UIColor? = nil) {
        self.value = value
        self.valueDescription = valueDescription
        if let circleColor = circleColor {
            self.indicator = MFColumnInfoIndicator.circle(fillColor: circleColor, strokeColor: nil, strokeWidth: nil)
        }
    }
    
    public init(value: String, valueDescription: String, indicator: MFColumnInfoIndicator?) {
        self.value = value
        self.valueDescription = valueDescription
        self.indicator = indicator
    }
}

open class MFOneColumnInfoView: UIView {
    
    open var value: String = "" {
        didSet { valueLabel.text = value }
    }
    
    open func animateValue(fromValue: Double, toValue: Double, duration: TimeInterval, textFormatBlock: ((Double) -> String)?) {
        valueLabel.textFormatBlock = textFormatBlock
        valueLabel.countFrom(fromValue, toValue: toValue, duration: duration) {
            self.value = textFormatBlock?(toValue) ?? ""
        }
    }
    
    open var valueDescription: String = "" {
        didSet { valueDescriptionLabel.text = valueDescription }
    }
    
    open var indicator: MFColumnInfoIndicator? = nil {
        didSet {
            drawIndicator()
            relayoutContent()
        }
    }
    
    fileprivate var valueLabel: CountingLabel!
    fileprivate var valueDescriptionLabel: RichLabel!
    fileprivate var indicatorView = UIView()
    fileprivate var topView = UIView()
    fileprivate var bottomView = UIView()
    fileprivate var isTopView: Bool = false
    
    // Style
    fileprivate var valueLabelStyle: LabelStyleInfo!
    fileprivate var descriptionLabelStyle: LabelStyleInfo!
    
    //dhphat: FIXME by default valueLabel, valueDescription is topView, if we want to change center, we should pass isTopView is false
    public init(valueLabelStyle: LabelStyleInfo, descriptionLabelStyle: LabelStyleInfo, isTopView: Bool = true) {
        super.init(frame: CGRect.zero)
        
        self.isTopView = isTopView
        self.valueLabelStyle = valueLabelStyle
        self.descriptionLabelStyle = descriptionLabelStyle
        
        setupView()
        relayoutContent()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("public init(coder:) has not been implemented")
    }
    
    open func setupView() {
        valueLabel = CountingLabel(style: valueLabelStyle)
        valueDescriptionLabel = RichLabel(style: descriptionLabelStyle)

        self.addSubview(topView)
        self.addSubview(bottomView)
        self.addSubview(valueLabel)
        self.addSubview(valueDescriptionLabel)
        self.addSubview(indicatorView)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        guard let indicator = indicator else { return }
        switch indicator {
        case .circle(fillColor: _, strokeColor: _, strokeWidth: _):
            indicatorView.layer.cornerRadius = indicatorView.frame.width / 2
            
        case .squareBullet(fillColor: _, strokeColor: _, strokeWidth: _):
            indicatorView.layer.cornerRadius = 0
        }
    }

    fileprivate func relayoutContent() {
        if indicator != nil {
            valueLabel.mfl_removeConstraints()
                .mfl_layoutInParent(leading: 0, top: 0, trailing: 0)
            indicatorView.mfl_removeConstraints()
                .mfl_layoutInParent(width: 10, height: 10)
                .mfl_layoutGreaterThanOrEqual(leading: 3)
                .mfl_alignCenterY(toView: valueDescriptionLabel, offset: 0)
            valueDescriptionLabel.mfl_removeConstraints()
                .mfl_layoutInParent(centerX: 0)
                .mfl_topSpacing(toView: valueLabel, spacing: 5)
                .mfl_leadingSpacing(toView: indicatorView, spacing: 5)
        } else {
//            valueLabel.mfl_removeConstraints()
//                .mfl_layoutInParent(leading: 0, top: 0, trailing: 0)
//            valueDescriptionLabel.mfl_removeConstraints()
//                .mfl_layoutInParent(leading: 5, centerX: 0)
//                .mfl_topSpacing(toView: valueLabel, spacing: 5)
            if isTopView {
                valueLabel.mfl_removeConstraints().snp.remakeConstraints({ (make) in
                    make.top.equalTo(self)
                    make.width.lessThanOrEqualTo(self)
                    make.centerX.equalTo(self)
                })

                valueDescriptionLabel.mfl_removeConstraints().snp.remakeConstraints({ (make) in
                    make.width.lessThanOrEqualTo(self)
                    make.top.equalTo(valueLabel.snp.bottom).offset(6)
                    make.centerX.equalTo(self)
                })
            } else {
                topView.snp.remakeConstraints({ (make) in
                    make.height.greaterThanOrEqualTo(5)
                    make.top.equalTo(self)
                })

                bottomView.snp.remakeConstraints({ (make) in
                    make.height.equalTo(topView)
                    make.bottom.equalTo(self)
                })

                valueLabel.mfl_removeConstraints().snp.remakeConstraints({ (make) in
                    make.top.equalTo(topView.snp.bottom)
                    make.width.lessThanOrEqualTo(self)
                    make.bottom.equalTo(valueDescriptionLabel.snp.top).offset(-6)
                    make.centerX.equalTo(self)
                })

                valueDescriptionLabel.mfl_removeConstraints().snp.remakeConstraints({ (make) in
                    make.width.lessThanOrEqualTo(self)
                    make.top.equalTo(valueLabel.snp.bottom).offset(6)
                    make.centerX.equalTo(self)
                    make.bottom.equalTo(bottomView.snp.top)
                })
            }
        }
    }
    
    fileprivate func drawIndicator() {
        guard let indicator = indicator else { return }
        switch indicator {
        case let .circle(fillColor: fillColor, strokeColor: strokeColor, strokeWidth: strokeWidth):
            indicatorView.layer.cornerRadius = indicatorView.frame.width / 2
            indicatorView.layer.backgroundColor = fillColor?.cgColor
            indicatorView.layer.borderColor = strokeColor?.cgColor
            indicatorView.layer.borderWidth = strokeWidth ?? 0
            
        case let .squareBullet(fillColor: fillColor, strokeColor: strokeColor, strokeWidth: strokeWidth):
            indicatorView.layer.cornerRadius = 0
            indicatorView.layer.backgroundColor = fillColor?.cgColor
            indicatorView.layer.borderColor = strokeColor?.cgColor
            indicatorView.layer.borderWidth = strokeWidth ?? 0
        }
    }
}

open class MFColumnsInfoView: UIView {
    
    open var infos: [MFColumnInfo] = [] {
        didSet {
            if infos.count == oldValue.count && columnViews.count > 0 {
                // Just update info
                (0..<infos.count).forEach { index in
                    columnViews[index].value = infos[index].value
                    columnViews[index].valueDescription = infos[index].valueDescription
                    columnViews[index].indicator = infos[index].indicator
                }
            } else {
                // Re-setup
                setup()
            }
        }
    }
    
    open func updateInternalInfos(_ infos: [MFColumnInfo]) {
        self.infos = infos
    }
    

    open func appleValueStyle(style: LabelStyleInfo) {

        self.valueLabelStyle = style
        // Re-setup
        setup()
    }
    
    /**
     This will animate counting from 0 to specfied value for each column.
     
     - Parameter animationValues: Each item represent animation for each column:
     - value: The final value. Specify nil for this value will skip updating of this column.
     - textFormatBlock: Format text that will be displayed when counting
     
     - Parameter animateDuration: Specify 0 or nil will disable animation
     */
    open func animateUpdateValues(_ animationValues: [(value: Double?, textFormatBlock: ((Double) -> String)?)], animateDuration: Double) {
        for (idx, animationValue) in animationValues.enumerated() {
            guard let newValue = animationValue.value else {
                continue
            }
            
            self.columnViews[idx].animateValue(fromValue: 0, toValue: newValue, duration: animateDuration, textFormatBlock: animationValue.textFormatBlock)
        }
    }
    
    fileprivate var columnViews: [MFOneColumnInfoView] = []
    
    //Style
    open var separatorLineColor: UIColor = UIColor.clear
    fileprivate var valueLabelStyle: LabelStyleInfo!
    fileprivate var descriptionLabelStyle: LabelStyleInfo!
    

    fileprivate var isTopView: Bool!
    
    public init(valueLabelStyle: LabelStyleInfo, descriptionLabelStyle: LabelStyleInfo, isTopView: Bool = true) {

        super.init(frame: CGRect.zero)
        self.isTopView = isTopView
        self.valueLabelStyle = valueLabelStyle
        self.descriptionLabelStyle = descriptionLabelStyle
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("public init(coder:) has not been implemented")
    }
    
    open func setup() {
        setupView()
        setupLayout()
    }
    
    open func setupView() {
        // Remove columnViews
        columnViews.forEach { $0.removeFromSuperview() }
        
        // Create columns and add to self
        let numberOfColumns = infos.count
        columnViews = (0..<numberOfColumns).map { index in
            let columnView = MFOneColumnInfoView(valueLabelStyle: self.valueLabelStyle, descriptionLabelStyle: self.descriptionLabelStyle, isTopView: isTopView)
            if index != numberOfColumns - 1 {
                columnView.mfl_addBorder(pos: .trailing, lineWidth: 1.0, color: separatorLineColor)
            }
            
            columnView.value = infos[index].value
            columnView.valueDescription = infos[index].valueDescription
            
            return columnView
        }
        
        // Add subviews
        columnViews.forEach { self.addSubview($0) }
    }
    
    open func setupLayout() {
        let numberOfColumns = infos.count
        
        if let firstColumnView = columnViews.first, let lastColumnView = columnViews.last {
            firstColumnView.snp.makeConstraints({ (make) -> Void in
                make.leading.equalTo(self.snp.leading)
                make.top.equalTo(self.snp.top)
                make.bottom.equalTo(self.snp.bottom)
            })
            
            lastColumnView.snp.makeConstraints({ (make) -> Void in
                make.trailing.equalTo(self.snp.trailing)
                make.top.equalTo(self.snp.top)
                make.bottom.equalTo(self.snp.bottom)
            })
            
            (1..<numberOfColumns).forEach { index in
                let previousColumnView = self.columnViews[index - 1]
                self.columnViews[index].snp.makeConstraints({ (make) -> Void in
                    make.top.equalTo(self.snp.top)
                    make.bottom.equalTo(self.snp.bottom)
                    make.width.equalTo(firstColumnView.snp.width)
                    make.leading.equalTo(previousColumnView.snp.trailing)
                })
            }
        }
    }
}

//
//  DonutColorPickerViewController.swift
//  Pods
//
//  Created by Nguyen Van Uy on 2/20/17.
//
//
//import Foundation

public struct DonutColorPiece {
    private(set) var middleAngle: Double
    private(set) var startAngle: Double
    private(set) var endAngle: Double
    var color: UIColor
    var colorName: String?
    var width: CGFloat = 5
    private(set) var tag: AnyObject?
    private(set) var borderColor: UIColor
    private(set) var borderWidth: CGFloat
    private(set) var totalPiecesInCake: Int
    public private(set) var pieceIndex: Int
    private(set) var arcTouchAreaLayerPath: UIBezierPath
    private(set) var arcDonutPiecePath: UIBezierPath
    
    init(totalPiecesInCake: Int, pieceIndex: Int, pieceColor: UIColor, pieceColorName: String? = nil, width: CGFloat = 5, colorOfPieceBorder: UIColor = UIColor.clear, widthOfPieceBorder: CGFloat = 0, tag: AnyObject? = nil) {
        self.totalPiecesInCake = totalPiecesInCake
        self.pieceIndex = pieceIndex
        self.color = pieceColor
        self.colorName = pieceColorName
        self.width = width
        self.borderColor = colorOfPieceBorder
        self.borderWidth = widthOfPieceBorder
        self.tag = tag
        
        let angle = 2.0 * .pi / Double(totalPiecesInCake)
        self.startAngle = Double(pieceIndex) * angle - (.pi / 2)
        self.middleAngle = startAngle + angle / 2
        self.endAngle = startAngle + angle
        self.arcTouchAreaLayerPath = UIBezierPath()
        self.arcDonutPiecePath = UIBezierPath()
    }
    
    public mutating func updateAllArcLayerPath(_ boundFrame: CGRect, pCenter: CGPoint, radius: CGFloat) {
        updateArcTouchAreaLayerPath(boundFrame, pCenter: pCenter, radius: radius)
        updateArcDonutPiecePath(boundFrame, pCenter: pCenter, radius: radius)
    }
    
    private mutating func updateArcTouchAreaLayerPath(_ boundFrame: CGRect, pCenter: CGPoint, radius: CGFloat) {
        let arcPath = UIBezierPath()
        arcPath.move(to: pCenter)
        arcPath.addArc(withCenter: pCenter, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        arcPath.addLine(to: pCenter)
        arcPath.close()
        
        arcTouchAreaLayerPath = arcPath
    }
    
    private mutating func updateArcDonutPiecePath(_ boundFrame: CGRect, pCenter: CGPoint, radius: CGFloat) {
        let arcPath = UIBezierPath(arcCenter: pCenter, radius: radius - width/2, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        arcDonutPiecePath = arcPath
    }
}

public protocol DonutColorPickerDelegate: DonutColorPickerDelegateOptional {
    func didSelectedColorPiece(_ colorPiece: DonutColorPiece)
}

// MARK:- Protocol Optional
public protocol DonutColorPickerDelegateOptional: class {
    func willChangeColor(_ colorPiece: DonutColorPiece) -> UIColor?
    func willChangeColorForState(_ isEnabled: Bool, colorPiece: DonutColorPiece) -> UIColor?
}

public extension DonutColorPickerDelegateOptional {
    // it's fired to change color hour hand watch
    func willChangeColor(_ colorPiece: DonutColorPiece) -> UIColor? {
        return nil
    }
    
    func willChangeColorForState(_ isEnabled: Bool, colorPiece: DonutColorPiece) -> UIColor? {
        return nil
    }
}

open class DonutColorPickerViewController: UIViewController, UIGestureRecognizerDelegate {
    // MARK:- Configs
    struct configs {
        
    }
    
    // MARK: Variables
    fileprivate var colorHourHand: UIColor!
    fileprivate var font: UIFont?
    open weak var delegate: DonutColorPickerDelegate?
    open var duration: TimeInterval = 0.3
    open var paddingColorCake: CGFloat = 5
    open var paddingHourHand: CGFloat = 5
    open var paddingView: CGFloat = 10
    
    fileprivate var vContent: UIView!
    fileprivate var curColorPiece: DonutColorPiece!
    fileprivate var viewHourHand: UIView!
    fileprivate var keyHourHand: UIView!
    fileprivate var originHourHand: UIView!
    fileprivate var lblSelectedColor: UILabel!
    fileprivate var vColorCake: UIView!
    fileprivate var gesture: UITapGestureRecognizer!
    fileprivate var isEnableGesture = true
    var arrColorPieces: [DonutColorPiece]!
    
    public convenience init(arrColors: [UIColor], colorHourHand: UIColor!, font: UIFont?) {
        self.init()
        arrColorPieces = []
        var index = 0
        for color in arrColors {
            let borderColor = color.isEqual(UIColor(hex: 0xFFFFFF)) ? UIColor.gray : color
            arrColorPieces.append(DonutColorPiece(totalPiecesInCake: arrColors.count, pieceIndex: index, pieceColor: color, width: 12, colorOfPieceBorder: borderColor, widthOfPieceBorder: 0.6))
            index = index + 1
        }
        self.colorHourHand = colorHourHand
        self.font = font
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        //
        self.setupComponents()
        self.setupLayout()
    }
    
    // MARK:- Setup functions
    
    fileprivate func setupComponents(){
        self.vContent = UIView()
        self.vContent.backgroundColor = UIColor.clear
        
        self.viewHourHand = UIView(frame: CGRect.zero)
        self.viewHourHand.backgroundColor = UIColor.clear
        
        self.keyHourHand = UIView(frame: CGRect.zero)
        self.keyHourHand.backgroundColor = self.colorHourHand
        
        self.originHourHand = UIView(frame: CGRect.zero)
        self.originHourHand.backgroundColor = self.colorHourHand
        
        self.lblSelectedColor = UILabel(frame: CGRect.zero)
        self.lblSelectedColor.isHidden = true
        self.lblSelectedColor.textAlignment = NSTextAlignment.center
        self.lblSelectedColor.textColor = self.colorHourHand
        if let _ = self.font {
            self.lblSelectedColor.font = self.font!
        }
        
        self.vColorCake = UIView(frame: CGRect())
        self.vColorCake.backgroundColor = UIColor.clear
        self.gesture = UITapGestureRecognizer()
        self.gesture.delegate = self
        self.gesture.numberOfTapsRequired = 1
        self.gesture.numberOfTouchesRequired = 1
        self.gesture.addTarget(self, action: #selector(handleTouchWatchFace(_:)))
        self.vColorCake.addGestureRecognizer(gesture)
    }
    
    fileprivate func setupLayout() {
        self.view.addSubview(self.vContent)
        self.view.addSubview(self.vColorCake)
        self.vContent.addSubview(self.viewHourHand)
        self.viewHourHand.addSubview(self.keyHourHand)
        self.viewHourHand.addSubview(self.originHourHand)
        self.vContent.addSubview(self.lblSelectedColor)
        
        self.vContent.snp.remakeConstraints { (make) in
            make.top.equalTo(self.vContent.superview!).offset(self.paddingView)
            make.leading.equalTo(self.vContent.superview!).offset(self.paddingView)
            make.trailing.equalTo(self.vContent.superview!).offset(-self.paddingView)
            make.bottom.equalTo(self.vContent.superview!).offset(-self.paddingView)
        }
        
        //
        self.viewHourHand.snp.makeConstraints { (make) in
            make.width.equalTo(self.viewHourHand.superview!.snp.width)
            make.height.equalTo(self.viewHourHand.superview!.snp.height).dividedBy(30)
            make.center.equalTo(self.viewHourHand.superview!.snp.center)
        }
        
        self.keyHourHand.snp.makeConstraints { (make) in
            // NOTE: duyetnt
            // We don't need to change the following 'right' to 'trailing'
            make.left.equalTo(self.keyHourHand.superview!.snp.centerX).offset(-self.paddingHourHand)
            make.top.equalTo(self.keyHourHand.superview!.snp.top).offset(0)
            make.bottom.equalTo(self.keyHourHand.superview!.snp.bottom).offset(0)
            make.width.equalTo(self.keyHourHand.superview!.snp.width).dividedBy(3)
        }
        
        self.originHourHand.snp.makeConstraints { (make) in
            make.center.equalTo(self.originHourHand.superview!.snp.center)
            make.height.equalTo(self.keyHourHand.snp.height).multipliedBy(2.4)
            make.width.equalTo(self.originHourHand.snp.height)
        }
        
        self.lblSelectedColor.snp.makeConstraints { (make) in
            make.edges.equalTo(self.lblSelectedColor.superview!)
        }
        
        self.vColorCake.snp.remakeConstraints { (make) in
            make.edges.equalTo(self.vColorCake.superview!)
        }
        
        self.view.layoutIfNeeded()
    }
    
    //SelectedColor is a color on list color which are inputed before.
    // MARK:- General functions
    open func showHourHand(_ selectedColor: UIColor, isEnableDonutColorPicker: Bool = true) {
        self.view.layoutIfNeeded()
        
        self.keyHourHand.layer.cornerRadius = self.keyHourHand.bounds.size.height / 2.0
        self.keyHourHand.layer.shouldRasterize = true
        self.keyHourHand.layer.rasterizationScale = UIScreen.main.scale
        
        self.originHourHand.layer.cornerRadius = self.originHourHand.bounds.size.height / 2.0
        self.originHourHand.layer.shouldRasterize = true
        self.originHourHand.layer.rasterizationScale = UIScreen.main.scale
        
        let selectedColorPiece = arrColorPieces.filter() {$0.color == selectedColor }.first!
        
        self.updateHourHand(selectedColorPiece, isAnimated: false)
        
        let boundFrame = self.view.bounds
        let pCenter = self.view.bounds.center
        let radius = self.view.bounds.size.height / 2.0
        for i in 0..<arrColorPieces.count {
            arrColorPieces[i].updateAllArcLayerPath(boundFrame, pCenter: pCenter, radius: radius)
        }
        
        drawColorPieces(isEnable: isEnableDonutColorPicker)
    }
    
    fileprivate func updateHourHand(_ selectedColorPiece: DonutColorPiece, isAnimated: Bool) {
        self.curColorPiece = selectedColorPiece
        self.lblSelectedColor.text = "\(self.curColorPiece.pieceIndex)"
        
        if isAnimated {
            self.animateToColorPiece(self.curColorPiece)
            self.delegate?.didSelectedColorPiece(self.curColorPiece)
        } else {
            self.transformColorCake(self.curColorPiece)
        }
        
        //
        if let color = self.delegate?.willChangeColor(self.curColorPiece) {
            self.updateColorHourHand(color)
        } else {
            self.updateColorHourHand(self.colorHourHand)
        }
    }
    
    fileprivate func animateToColorPiece(_ colorPiece: DonutColorPiece) {
        UIView.animate(withDuration: self.duration, animations: { [weak self] in
            self?.transformColorCake(colorPiece)
        })
    }
    
    fileprivate func transformColorCake(_ colorPiece: DonutColorPiece) {
        self.viewHourHand.transform = CGAffineTransform(rotationAngle: CGFloat(colorPiece.middleAngle))
    }
    
    fileprivate func updateColorHourHand(_ color: UIColor) {
        self.keyHourHand.backgroundColor = color
        self.originHourHand.backgroundColor = color
        self.lblSelectedColor.textColor = color
    }
    
    open func didEnabled(_ enabled: Bool) {
        self.isEnableGesture = enabled
        
        // NOTE: duyetnt
        // In Diesel, the watchface is darker so we can see a black dash behind hour hand
        // when decreasing alpha of it -> change color without alphgryea
        if let colorPiece = curColorPiece, let color = delegate?.willChangeColorForState(enabled, colorPiece: colorPiece) {
            updateColorHourHand(color)
        } else {
            self.lblSelectedColor.didEnabled(enabled)
            self.keyHourHand.didEnabled(enabled)
            self.originHourHand.didEnabled(enabled)
            self.drawColorPieces(isEnable: enabled)
        }
    }
    
    // MARK:- UIGestureRecognizerDelegate
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    open func handleTouchWatchFace(_ gestureRecognizer: UITapGestureRecognizer) {
        if isEnableGesture && gesture == gestureRecognizer && gestureRecognizer.state == .ended {
            
            self.selectHourHandByPosition(gestureRecognizer.location(ofTouch: 0, in: self.vColorCake))
        }
    }
    
    fileprivate func selectHourHandByPosition(_ position: CGPoint) {
        for colorPiece in arrColorPieces {
            if colorPiece.arcTouchAreaLayerPath.contains(position) {
                self.updateHourHand(colorPiece, isAnimated: true)
                return
            }
        }
    }
    
    fileprivate func drawColorPieces(isEnable: Bool = true) {
        // reset sublayers in watchview
        for arcLayer in self.vColorCake.layer.sublayers ?? [] {
            arcLayer.removeFromSuperlayer()
        }
        
        // generate colors
        for colorPiece in self.arrColorPieces {
            //draw border
            if colorPiece.borderWidth > 0 {
                let borderLayer = CAShapeLayer()
                borderLayer.path = colorPiece.arcDonutPiecePath.cgPath
                borderLayer.fillColor = UIColor.clear.cgColor
                borderLayer.strokeColor = (isEnable ? colorPiece.borderColor : colorPiece.borderColor.colorWithAlpha(0.3)).cgColor
                borderLayer.lineWidth = colorPiece.width
                self.vColorCake.layer.addSublayer(borderLayer)
            }
            
            let arcLayer = CAShapeLayer()
            arcLayer.path = colorPiece.arcDonutPiecePath.cgPath
            arcLayer.fillColor = UIColor.clear.cgColor
            arcLayer.strokeColor = (isEnable ? colorPiece.color : colorPiece.color.colorWithAlpha(0.3)).cgColor
            arcLayer.lineWidth = colorPiece.borderWidth <= 0 ? colorPiece.width : colorPiece.width - (colorPiece.borderWidth * 2)
            self.vColorCake.layer.addSublayer(arcLayer)
        }
        
        //nvuy: [DEBUGING] Call it here to fill area of all piece
        //drawTouchAreaColorPieces()
    }
    
    // MARK: Draw arc hour hand for testing
    fileprivate func drawTouchAreaColorPieces() {
        var idx = 0
        for colorPiece in self.arrColorPieces {
            // initial arc hour hand layer
            let arcLayer = CAShapeLayer()
            arcLayer.fillColor = UIColor(hex: Int(arc4random()), a: 0.5).cgColor
            idx += 1
            arcLayer.path = colorPiece.arcTouchAreaLayerPath.cgPath
            self.vColorCake.layer.addSublayer(arcLayer)
        }
    }
}

extension UIColor {
    func isEqualToColor(otherColor: UIColor) -> Bool {
        if self == otherColor {
            return true
        }
        
        let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()
        let convertColorToRGBSpace : ((_ color : UIColor) -> UIColor?) = { (color) -> UIColor? in
            if color.cgColor.colorSpace?.model == CGColorSpaceModel.monochrome {
                let oldComponents = color.cgColor.components
                let components : [CGFloat] = [ oldComponents![0], oldComponents![0], oldComponents![0], oldComponents![1] ]
                let colorRef = CGColor(colorSpace: colorSpaceRGB, components: components)
                let colorOut = UIColor(cgColor: colorRef!)
                return colorOut
            }
            else {
                return color;
            }
        }
        
        let selfColor = convertColorToRGBSpace(self)
        let otherColor = convertColorToRGBSpace(otherColor)
        
        if let selfColor = selfColor, let otherColor = otherColor {
            return selfColor.isEqual(otherColor)
        }
        else {
            return false
        }
    }
}

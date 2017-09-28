//
//  HourHandWatchViewController.swift
//  Portfolio
//
//  Created by Phan Anh Duy on 7/24/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

public let M_PI_6 = .pi/2 / 3.0 // about 30 degrees

public enum HourHandWatch: Int {
    case first    = 1
    case second   = 2
    case third    = 3
    case fourth   = 4
    case fifth    = 5
    case sixth    = 6
    case seventh  = 7
    case eighth   = 8
    case ninth    = 9
    case tenth    = 10
    case eleventh = 11
    case twelfth  = 12
    
    public var degree: CGFloat {
        switch self {
        case .first:
            return 30
        case .second:
            return 60
        case .third:
            return 90
        case .fourth:
            return 120
        case .fifth:
            return 150
        case .sixth:
            return 180
        case .seventh:
            return 210
        case .eighth:
            return 240
        case .ninth:
            return 270
        case .tenth:
            return 300
        case .eleventh:
            return 330
        case .twelfth:
            return 360
        }
    }
    
    public var angle: Double {
        switch self {
        case .first:
            return 10 * M_PI_6
        case .second:
            return 11 * M_PI_6
        case .third:
            return 0
        case .fourth:
            return M_PI_6
        case .fifth:
            return 2 * M_PI_6
        case .sixth:
            return 3 * M_PI_6
        case .seventh:
            return 4 * M_PI_6
        case .eighth:
            return 5 * M_PI_6
        case .ninth:
            return 6 * M_PI_6
        case .tenth:
            return 7 * M_PI_6
        case .eleventh:
            return 8 * M_PI_6
        case .twelfth:
            return 8.989 * M_PI_6 //nvuy: For align center of 12
        }
    }
    
    public func arcLayerPath(_ boundFrame: CGRect, pCenter: CGPoint, radius: CGFloat) -> UIBezierPath {
        var startAngle: Double = 0
        var endAngle: Double = 0
        
        switch self {
        case .first:
            startAngle = 9.5 * M_PI_6
            endAngle = 10.5 * M_PI_6
        case .second:
            startAngle = 10.5 * M_PI_6
            endAngle =  11.5 * M_PI_6
        case .third:
            startAngle = 11.5 * M_PI_6
            endAngle =  0.5 * M_PI_6
        case .fourth:
            startAngle = 0.5 * M_PI_6
            endAngle =  1.5 * M_PI_6
        case .fifth:
            startAngle = 1.5 * M_PI_6
            endAngle =  2.5 * M_PI_6
        case .sixth:
            startAngle = 2.5 * M_PI_6
            endAngle =  3.5 * M_PI_6
        case .seventh:
            startAngle = 3.5 * M_PI_6
            endAngle =  4.5 * M_PI_6
        case .eighth:
            startAngle = 4.5 * M_PI_6
            endAngle =  5.5 * M_PI_6
        case .ninth:
            startAngle = 5.5 * M_PI_6
            endAngle =  6.5 * M_PI_6
        case .tenth:
            startAngle = 6.5 * M_PI_6
            endAngle =  7.5 * M_PI_6
        case .eleventh:
            startAngle = 7.5 * M_PI_6
            endAngle =  8.5 * M_PI_6
        case .twelfth:
            startAngle = 8.5 * M_PI_6
            endAngle =  9.5 * M_PI_6
        }
        
        let arcPath = UIBezierPath()
        arcPath.move(to: pCenter)
        arcPath.addArc(withCenter: pCenter, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        arcPath.addLine(to: pCenter)
        arcPath.close()
        
        return arcPath
    }
}

public protocol HourHandWatchDelegate: HourHandWatchDelegateOptional {
    func didSelectedHourHandWatch(_ hourHand: HourHandWatch);
}

// MARK:- Protocol Optional
public protocol HourHandWatchDelegateOptional: class {
    func willChangeColorHoudHandWatch(_ hourHand: HourHandWatch) -> UIColor?
    func willChangeColorHourHandWatchForState(_ isEnabled: Bool, hourHand: HourHandWatch) -> UIColor?
}

public extension HourHandWatchDelegateOptional {
    // it's fired to change color hour hand watch
    func willChangeColorHoudHandWatch(_ hourHand: HourHandWatch) -> UIColor? {
        return nil
    }
    
    func willChangeColorHourHandWatchForState(_ isEnabled: Bool, hourHand: HourHandWatch) -> UIColor? {
        return nil
    }
}

open class HourHandWatchViewController: UIViewController, UIGestureRecognizerDelegate {
    // MARK:- Configs
    struct configs {
        
    }
    
    // MARK: Variables
    fileprivate var imageWatch: UIImage?
    fileprivate var colorHourHand: UIColor!
    fileprivate var font: UIFont?
    open weak var delegate: HourHandWatchDelegate?
    open var duration: TimeInterval = 0.3
    open var paddingWatchFace: CGFloat = 5
    open var paddingHourHand: CGFloat = 5
    open var paddingView: CGFloat = 10
    
    fileprivate var vContent: UIView!
    fileprivate var curHourHand: HourHandWatch!
    fileprivate var imgBackground: UIImageView!
    fileprivate var viewHourHand: UIView!
    fileprivate var keyHourHand: UIView!
    fileprivate var lblHourHand: UILabel!
    fileprivate var btnHourHand: UIButton!
    fileprivate var vWatchFace: UIView!
    fileprivate var gesture: UITapGestureRecognizer!
    fileprivate var arrHoursArcPath = [(UIBezierPath, HourHandWatch)]()
    fileprivate var isEnableGesture = true
    
    public convenience init(imageWatch: UIImage?, colorHourHand: UIColor!, font: UIFont?) {
        self.init()
    
        self.imageWatch = imageWatch
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
        
        self.imgBackground = UIImageView(image: self.imageWatch)
        self.imgBackground.contentMode = UIViewContentMode.scaleAspectFit
        
        self.viewHourHand = UIView(frame: CGRect.zero)
        self.viewHourHand.backgroundColor = UIColor.clear
        
        self.keyHourHand = UIView(frame: CGRect.zero)
        self.keyHourHand.backgroundColor = self.colorHourHand
        
        self.lblHourHand = UILabel(frame: CGRect.zero)
        self.lblHourHand.textAlignment = NSTextAlignment.center
        self.lblHourHand.textColor = self.colorHourHand
        if let _ = self.font {
            self.lblHourHand.font = self.font!
        }
        
        self.btnHourHand = UIButton(type: UIButtonType.custom)
        self.btnHourHand.backgroundColor = UIColor.clear
        self.btnHourHand.addTarget(self, action: #selector(btnHourHand_Tapped(_:)), for: UIControlEvents.touchUpInside)
        
        self.vWatchFace = UIView(frame: CGRect())
        self.vWatchFace.backgroundColor = UIColor.clear
        self.gesture = UITapGestureRecognizer()
        self.gesture.delegate = self
        self.gesture.numberOfTapsRequired = 1
        self.gesture.numberOfTouchesRequired = 1
        self.gesture.addTarget(self, action: #selector(handleTouchWatchFace(_:)))
        self.vWatchFace.addGestureRecognizer(gesture)
    }
    
    fileprivate func setupLayout() {
        
        self.view.addSubview(self.vContent)
        self.vContent.snp.remakeConstraints { (make) in
            make.top.equalTo(self.vContent.superview!).offset(self.paddingView)
            make.leading.equalTo(self.vContent.superview!).offset(self.paddingView)
            make.trailing.equalTo(self.vContent.superview!).offset(-self.paddingView)
            make.bottom.equalTo(self.vContent.superview!).offset(-self.paddingView)
        }
        
        self.vContent.addSubview(self.imgBackground)
        self.imgBackground.snp.makeConstraints { (make) in
            make.top.equalTo(self.imgBackground.superview!).offset(self.paddingWatchFace)
            make.leading.equalTo(self.imgBackground.superview!).offset(self.paddingWatchFace)
            make.trailing.equalTo(self.imgBackground.superview!).offset(-self.paddingWatchFace)
            make.bottom.equalTo(self.imgBackground.superview!).offset(-self.paddingWatchFace)
        }
        
        //
        self.vContent.addSubview(self.viewHourHand)
        self.viewHourHand.snp.makeConstraints { (make) in
            make.width.equalTo(self.viewHourHand.superview!.snp.width)
            make.height.equalTo(self.viewHourHand.superview!.snp.height).dividedBy(30)
            make.center.equalTo(self.viewHourHand.superview!.snp.center)
        }
        
        self.viewHourHand.addSubview(self.keyHourHand)
        self.keyHourHand.snp.makeConstraints { (make) in
            // NOTE: duyetnt
            // We don't need to change the following 'right' to 'trailing'
            make.right.equalTo(self.keyHourHand.superview!.snp.right).offset(-self.paddingHourHand)
            make.top.equalTo(self.keyHourHand.superview!.snp.top).offset(0)
            make.bottom.equalTo(self.keyHourHand.superview!.snp.bottom).offset(0)
            make.width.equalTo(self.keyHourHand.superview!.snp.width).dividedBy(5)
        }
        
        self.vContent.addSubview(self.lblHourHand)
        self.lblHourHand.snp.makeConstraints { (make) in
            make.edges.equalTo(self.lblHourHand.superview!)
        }
        
        self.view.addSubview(self.btnHourHand)
        self.btnHourHand.snp.makeConstraints { (make) in
            make.edges.equalTo(self.btnHourHand.superview!)
        }
        
        self.view.addSubview(self.vWatchFace)
        self.vWatchFace.snp.remakeConstraints { (make) in
            make.edges.equalTo(self.vWatchFace.superview!)
        }
        
        self.view.layoutIfNeeded()
        //
    }

    // MARK:- General functions
    open func showHourHand(_ hourhand: HourHandWatch) {
        self.view.layoutIfNeeded()
        
        self.keyHourHand.layer.cornerRadius = self.keyHourHand.bounds.size.height / 2.0
        self.keyHourHand.layer.shouldRasterize = true
        self.keyHourHand.layer.rasterizationScale = UIScreen.main.scale
        self.updateHourHand(hourhand, isAnimated: false)
        
        // reset
        arrHoursArcPath.removeAll()
        //
        let arrHours: [HourHandWatch] = [.first, .second, .third, .fourth, .fifth, .sixth, .seventh, .eighth, .ninth, .tenth, .eleventh, .twelfth]
        
        let boundFrame = self.vWatchFace.bounds
        let pCenter = self.vWatchFace.bounds.center
        let radius = self.vWatchFace.bounds.size.height / 2.0
        for hourwatch in arrHours {
            let arcPathHourHand = hourwatch.arcLayerPath(boundFrame, pCenter: pCenter, radius: radius)
            arrHoursArcPath.append((arcPathHourHand, hourwatch))
        }
        
        //nvuy: [DEBUGING] Call it here to fill area of all sector of watch face
        //drawArcHourHand()
    }
    
    func btnHourHand_Tapped(_ sender: UIButton) {
        var iHourHand = (self.curHourHand.rawValue + 1) % HourHandWatch.twelfth.rawValue
        if iHourHand == 0 {
            iHourHand = 12
        }
        
        if let nextHourHand = HourHandWatch(rawValue: iHourHand) {
            self.updateHourHand(nextHourHand, isAnimated: true)
        }
    }
    
    fileprivate func updateHourHand(_ hourHand: HourHandWatch, isAnimated: Bool) {
        self.curHourHand = hourHand
        self.lblHourHand.text = "\(self.curHourHand.rawValue)"
        
        if isAnimated {
            self.animateToHourHand(self.curHourHand)
            self.delegate?.didSelectedHourHandWatch(self.curHourHand)
        } else {
            self.transformHourHand(self.curHourHand)
        }
        
        // 
        if let color = self.delegate?.willChangeColorHoudHandWatch(self.curHourHand) {
            self.updateColorHourHand(color)
        } else {
            self.updateColorHourHand(self.colorHourHand)
        }
    }
    
    fileprivate func animateToHourHand(_ hourHand: HourHandWatch) {
        UIView.animate(withDuration: self.duration, animations: { [weak self] in
            self?.transformHourHand(hourHand)
        }) 
    }
    
    fileprivate func transformHourHand(_ hourHand: HourHandWatch) {
        self.viewHourHand.transform = CGAffineTransform(rotationAngle: CGFloat(hourHand.angle))
    }
    
    fileprivate func updateColorHourHand(_ color: UIColor) {
        self.keyHourHand.backgroundColor = color
        self.lblHourHand.textColor = color
    }
    
    open func didEnabled(_ enabled: Bool) {
        self.btnHourHand.isEnabled = enabled
        self.imgBackground.didEnabled(enabled)
        self.isEnableGesture = enabled

        // NOTE: duyetnt
        // In Diesel, the watchface is darker so we can see a black dash behind hour hand
        // when decreasing alpha of it -> change color without alphgryea
        if let hourHand = curHourHand, let color = delegate?.willChangeColorHourHandWatchForState(enabled, hourHand: hourHand) {
            updateColorHourHand(color)
        } else {
            self.lblHourHand.didEnabled(enabled)
            self.keyHourHand.didEnabled(enabled)
        }
    }
    
    // MARK:- UIGestureRecognizerDelegate
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    open func handleTouchWatchFace(_ gestureRecognizer: UITapGestureRecognizer) {
        if isEnableGesture && gesture == gestureRecognizer && gestureRecognizer.state == .ended {

            self.selectHourHandByPosition(gestureRecognizer.location(ofTouch: 0, in: self.vWatchFace))
        }
    }
    
    fileprivate func selectHourHandByPosition(_ position: CGPoint) {
        for (arcPath, hourWatch) in arrHoursArcPath {
            if arcPath.contains(position) {
                self.updateHourHand(hourWatch, isAnimated: true)
                return
            }
        }
    }
    
    // MARK: Draw arc hour hand for testing
    fileprivate func drawArcHourHand() {
        // reset sublayers in watchview
        for arcLayer in self.vWatchFace.layer.sublayers ?? [] {
            arcLayer.removeFromSuperlayer()
        }
        
        // generate colors 
        let colors = [UIColor.red, UIColor.black, UIColor.blue, UIColor.brown, UIColor.magenta, UIColor.gray, UIColor.yellow, UIColor.black, UIColor.green, UIColor.lightGray, UIColor.purple, UIColor.orange]
        var idx = 0
        for (arcPath,_) in self.arrHoursArcPath {
            // initial arc hour hand layer
            let arcLayer = CAShapeLayer()
            arcLayer.fillColor = colors[idx].colorWithAlpha(0.5).cgColor
            idx += 1
            arcLayer.path = arcPath.cgPath
            self.vWatchFace.layer.addSublayer(arcLayer)
        }
    }
}

//
//  VerticalScrollView.swift
//  Portfolio
//
//  Created by Thuyen Trinh on 3/3/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

protocol VerticalScrollViewDelegate: class {
    func verticalScrollView(_ view: VerticalScrollView, didUpdateToValue value: String)
}

enum VerticalScrollViewLayoutAlign {
    case center
    case left
    case right
}

class VerticalScrollView: UIView {
    weak var delegate: VerticalScrollViewDelegate?
    fileprivate var layoutInitialized: Bool = false
    fileprivate var updateToInitalProperties: (value: String?, animate: Bool)? = (nil, false)
    fileprivate(set) var currentValue: String?
    fileprivate var maxScrollDistance: CGFloat {
        let quarterValues = CGFloat(self.values.count) * 0.25
        return max(quarterValues, 20)
    }
    
    fileprivate var lineHeight: CGFloat = 20.0 {
        didSet {
            self.collectionView.reloadData()
            self.setNeedsLayout()
        }
    }
    
    var numberOfVisibleValues: Int = 3 {
        didSet {
            self.collectionView.reloadData()
            self.setNeedsLayout()
        }
    }
    
    var font: UIFont = UIFont.boldSystemFont(ofSize: 32) {
        didSet {
            self.collectionView.reloadData()
            self.setNeedsLayout()
        }
    }
    
    var textColor: UIColor = UIColor(hex: 0x3D3934) {
        didSet {
            self.collectionView.reloadData()
            self.setNeedsLayout()
        }
    }
    
    var layoutAlign: VerticalScrollViewLayoutAlign = .center
    
    var values: [String] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    fileprivate var gradientLayer = CAGradientLayer()
    fileprivate var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        return UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    }()
    
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
        
        // Re-calculate lineHeight
        self.lineHeight = self.mfl_height / CGFloat(numberOfVisibleValues)
        
        let inset = self.bounds.midY - self.lineHeight * 0.5
        self.collectionView.contentInset = UIEdgeInsetsMake(inset, 0, inset, 0)
        
        if !self.layoutInitialized {
            self.layoutInitialized = true
            
            if let updateToProperties = self.updateToInitalProperties {
                if let value = updateToProperties.value {
                    self.updateToValue(value, animate: updateToProperties.animate)
                }
            }
            
            self.layoutGradientMask()
        }
    }
    
    fileprivate func setupView() {
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.isPagingEnabled = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.register(
            VerticalScrollViewCell.self, forCellWithReuseIdentifier: VerticalScrollViewCell.Constants.REUSE_IDENTIFIER)
        self.addSubview(self.collectionView)
        
        //mask
        self.layer.mask = self.gradientLayer
    }
    
    fileprivate func setupLayout() {
        let views = ["collectionView" : self.collectionView]
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[collectionView]|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[collectionView]|", options: [], metrics: nil, views: views))
    }
    
    func updateToValue(_ value: String, animate: Bool = false) {
        //Layout has to be initialized before we can call updateToValue...
        if !self.layoutInitialized {
            self.updateToInitalProperties = (value: value, animate: animate)
            return
        }
        
        let pageIndex = self.indexForValue(value)
        if animate {
            //For some reason using scrollToItemAtIndexPath doesn't work for rows less than
            //the the height of the collectionView.  For now, for rows less that this value
            //we forgo the animation, and jump to the appropriate value by setting contentOffset.
            if pageIndex < Int(self.bounds.size.height/self.lineHeight) {
                self.collectionView.contentOffset.y = self.contentOffsetForPageIndex(pageIndex)
            }
            else {
                self.collectionView.scrollToItem(at: IndexPath(row: pageIndex, section: 0), at: .centeredVertically, animated: true)
            }
        }
        else {
            let offset = self.contentOffsetForPageIndex(pageIndex)
            self.collectionView.contentOffset.y = offset
        }
    }
}

// MARK: - Utilities
extension VerticalScrollView {
    
    fileprivate func indexForValue(_ value: String) -> Int {
        return self.values.index(of: value) ?? 0
    }
    
    fileprivate func contentOffsetForPageIndex(_ pageIndex: Int) -> CGFloat {
        return (CGFloat(pageIndex) * self.lineHeight) - self.collectionView.contentInset.top
    }
    
    fileprivate func valueForIndex(_ pageIndex: Int) -> String {
        
        if pageIndex >= self.values.count - 1 {
            return self.values[self.values.count - 1]
        }
        else if pageIndex < 0 {
            return self.values[0]
        }
        else {
            return self.values[pageIndex]
        }
    }
    
    fileprivate func normalizedVelocity(_ velocity: CGFloat) -> CGFloat {
        let baseVelocity = max(min(abs(velocity)/4, 1), 0)
        return pow(baseVelocity, 2.0)
    }
}

// MARK: - UICollectionViewDataSource
extension VerticalScrollView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.verticalScrollViewCell(collectionView, indexPath: indexPath)
        let value = self.values[indexPath.row]
        cell.valueText = value
        cell.textColor = self.textColor
        cell.font = self.font
        cell.layoutAlign = layoutAlign
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension VerticalScrollView: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let contentOffset: CGFloat = (self.collectionView.contentOffset.y + (self.collectionView.contentInset.top + self.lineHeight * 0.5)) * CGFloat(self.values.count)
        var pageIndex = Int(round(contentOffset)/self.collectionView.contentSize.height)
        
        let normalizedVelocity = self.normalizedVelocity(velocity.y)
        if velocity.y > 0 {
            pageIndex = pageIndex + Int(normalizedVelocity * self.maxScrollDistance)
        }
        else if velocity.y < 0 {
            pageIndex = pageIndex - Int(normalizedVelocity * self.maxScrollDistance)
        }
        
        targetContentOffset.pointee.y = self.contentOffsetForPageIndex(pageIndex)
        
        let destinationValue = self.valueForIndex(pageIndex)
        self.currentValue = destinationValue
        self.delegate?.verticalScrollView(self, didUpdateToValue: destinationValue)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.size.width, height: self.lineHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}


// MARK: Layout
extension VerticalScrollView {
    
    fileprivate func layoutGradientMask() {
        let partiallyClearColor = UIColor.white.withAlphaComponent(0.2).cgColor
        let fullColor = UIColor.white.cgColor
        
        self.gradientLayer.frame = self.bounds
        self.gradientLayer.colors = [
            partiallyClearColor,
            partiallyClearColor,
            fullColor,
            fullColor,
            partiallyClearColor,
            partiallyClearColor
        ]
        
        // (pos_1_1 -> pos_1_2): begin -> end of 1st inactive area
        // (pos_2_1 -> pos_2_2): begin -> end of active area
        // (pos_3_1 -> pos_3_2): begin -> end of 2nd inactive area
        let delta: CGFloat = 0
        let pos_1_1: CGFloat = 0
        let pos_1_2 = 0.5 - 1 / (2 * CGFloat(numberOfVisibleValues)) - delta
        let pos_2_1 = pos_1_2 + delta
        let pos_2_2 = 0.5 + 1 / (2 * CGFloat(numberOfVisibleValues))
        let pos_3_1 = pos_2_2 + delta
        let pos_3_2: CGFloat = 1
        self.gradientLayer.locations = [
            pos_1_1,
            pos_1_2,
            pos_2_1,
            pos_2_2,
            pos_3_1,
            pos_3_2
            ].map({ NSNumber(value: Double($0)) })
    }
    
    fileprivate func verticalScrollViewCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> VerticalScrollViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: VerticalScrollViewCell.Constants.REUSE_IDENTIFIER , for: indexPath) as! VerticalScrollViewCell
        
        return cell
    }
    
}

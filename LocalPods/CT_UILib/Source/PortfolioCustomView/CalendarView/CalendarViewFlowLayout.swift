//
//  CalendarViewFlowLayout.swift
//  Portfolio
//
//  Created by Thuyen Trinh on 3/10/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

class CalendarViewFlowLayout: UICollectionViewFlowLayout {

    fileprivate var boundsSize = CGSize.zero
    
    override func prepare() {
        boundsSize = self.collectionView!.bounds.size
    }
    
    override var collectionViewContentSize : CGSize {
//        let verticalItemsCount = Int(floor(boundsSize.height / itemSize.height))
//        let horizontalItemsCount = Int(floor(boundsSize.width / itemSize.width))
//        
//        let itemsPerPage = verticalItemsCount * horizontalItemsCount
        let numberOfPages = collectionView!.numberOfSections
        let newWidth = CGFloat(numberOfPages) * boundsSize.width
        return CGSize(width: newWidth, height: boundsSize.height)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let numberOfSections = collectionView!.numberOfSections
        let attributes = (0..<numberOfSections).flatMap { section -> [UICollectionViewLayoutAttributes] in
            let numberOfRows = self.collectionView!.numberOfItems(inSection: section)
            let attributesForSection = (0..<numberOfRows).map { row -> UICollectionViewLayoutAttributes in
                let indexPath = IndexPath(row: row, section: section)
                return self.computeLayoutAttributesForCellAtIndexPath(indexPath)
            }
            return attributesForSection
        }
        
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.computeLayoutAttributesForCellAtIndexPath(indexPath)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func computeLayoutAttributesForCellAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let row = indexPath.row
        let col = indexPath.section
        
        let bounds = self.collectionView!.bounds
        
        // NOTE: tnthuyen: Not yet reproduce the case in which `itemSize.height == 0` or `itemSize.width == 0`
        // Yet, should make the code self-defensive
        let verticalItemsCount = itemSize.height == 0 ? 0 : Int(floor(boundsSize.height / itemSize.height))
        let horizontalItemsCount = itemSize.width == 0 ? 0 : Int(floor(boundsSize.width / itemSize.width))
        
        var columnPosition = 0
        var rowPosition = 0
        
        if horizontalItemsCount != 0 && verticalItemsCount != 0 {
            columnPosition = row % horizontalItemsCount
            rowPosition = (row / horizontalItemsCount) % verticalItemsCount
        }
        
        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        var frame = CGRect.zero
        frame.origin.x = CGFloat(col) * bounds.size.width + CGFloat(columnPosition) * itemSize.width
        frame.origin.y = CGFloat(rowPosition) * itemSize.height
        frame.size = itemSize
        attr.frame = frame
        
        return attr
    }
}

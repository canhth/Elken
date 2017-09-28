//
//  VericalCenteringScrollView.swift
//  Portfolio
//
//  Created by Khanh Pham on 8/29/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

open class VericalCenteringScrollView: UIScrollView {
    override open var contentOffset: CGPoint {
        didSet {
            let contentSize = self.contentSize
            let scrollViewSize = self.bounds.size
            
            var contentOffset = self.contentOffset
            
            if contentSize.height < scrollViewSize.height
            {
                contentOffset.y = -(scrollViewSize.height - contentSize.height) / 2.0;
            }
            
            super.contentOffset = contentOffset
        }
    }
}

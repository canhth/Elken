//
//  UIImageView_Utility.swift
//  Portfolio
//
//  Created by david  beckz on 5/19/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import Foundation

public extension UIImageView {
    public override func didEnabled(_ enabled: Bool) {
        if enabled {
            alpha = 1.0
        } else {
            alpha = 0.3
        }
    }
   
    
    func validateUrl(_ urlString: String) -> Bool {
        let urlRegEx = "^(http|https).+"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
    }
}

//
//  ProfilePictureView.swift
//  Portfolio
//
//  Created by Khanh Pham on 5/10/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit
import CocoaLumberjack

open class ProfilePictureView: UIImageView {
    
    open var pictureImageSize: CGSize
    open var placeholderNameStyle = LabelStyleInfo.defaultStyle()
    open var placeholderImageBackgroundColor = UIColor(hex: 0xF3F3F3)
    open var placeholderImageBorderColor = UIColor.clear
    open var placeholderOffset: CGFloat = 0
    
    public init(imageSize: CGSize) {
        self.pictureImageSize = imageSize
        super.init(frame: CGRect(origin: CGPoint.zero, size: imageSize))
        configure()
    }
    
    public init(imageSize: CGSize, placeholderNameStyle: LabelStyleInfo) {
        self.pictureImageSize = imageSize
        self.placeholderNameStyle = placeholderNameStyle
        super.init(frame: CGRect(origin: CGPoint.zero, size: imageSize))
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("public init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
    fileprivate func configure() {
        contentMode = .scaleAspectFill
        layer.cornerRadius = min(bounds.width, bounds.height) * 0.5
        layer.masksToBounds = true
        
        backgroundColor = UIColor(hex: 0xd2d1cc)
    }
    
    open func loadProfileImage(preferredImageData imageData: Data?, profileURLString: String?, placeholderDisplayName: String) {
        // Display data from local if exist
        if let imageData = imageData {
            self.image = UIImage(data: imageData)
            return
        }
        
        // Not yet have imageData in local
        // --> Display the placeholder image --> Load from server
        let attributes = placeholderNameStyle.getTextAttributes(alignment: .center)
        
        if let lineHeight = placeholderNameStyle.lineHeight {
            placeholderOffset = (placeholderNameStyle.font.pointSize - lineHeight) / 2
        }
        
        let placeholderProfileImage = ProfileImageFactory.profileImageWithText(
            placeholderDisplayName,
            textAttributes: attributes,
            borderColor: placeholderImageBorderColor,
            backgroundColor: placeholderImageBackgroundColor,
            diameter: pictureImageSize.width+5,
            offset: placeholderOffset
        )
        
        image = placeholderProfileImage

        //TODO: Will move it later
//        if let profileURLString = profileURLString {
//            if let profileURL = URL(string: profileURLString) {
//                hnk_setImageFromURL(profileURL, placeholder: placeholderProfileImage, format: nil, failure: nil, success: nil)
//            } else {
//                DDLogDebug("ProfilePictureView. LoadProfileImage: Invalid profile picture URL: \(profileURLString)")
//            }
//        }
    }
    
}


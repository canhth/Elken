//
//  MFImageViewController.swift
//  Portfolio
//
//  Created by Khanh Pham on 7/6/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

open class MFImageViewController: UIViewController {
    
    open var dismissHandler: (() -> Void)?
    
    fileprivate var imageView: UIImageView!
    fileprivate var closeButton: UIButton!
    
    fileprivate var image: UIImage?
    fileprivate var closeImage: UIImage?
    
    public init(image: UIImage?, closeImage: UIImage?) {
        self.image = image
        self.closeImage = closeImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
    }
    
    fileprivate func setupComponents() {
        view.backgroundColor = UIColor.white
        
        imageView = UIImageView(image: image)
        closeButton = UIButton()
        closeButton.setImage(closeImage, for: UIControlState())
        closeButton.addTarget(self, action: #selector(didTapClose(_:)), for: .touchUpInside)
        
        view.addSubview(imageView)
        view.addSubview(closeButton)
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(14)
            make.top.equalTo(self.view).offset(20)
            make.height.greaterThanOrEqualTo(44)
            make.width.greaterThanOrEqualTo(44)
        }
    }
    
    func didTapClose(_ sender: AnyObject?) {
        dismiss(animated: true, completion: dismissHandler)
    }
    
}

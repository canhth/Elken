//
//  MFCheckBox.swift
//  Portfolio
//
//  Created by Thanh Duyet on 7/5/16.
//  Copyright © 2016 Misfit. All rights reserved.
//


open class MFCheckBox: UIButton {
    // Images
    open var checkedImage: UIImage? = nil {
        didSet {
            if self.isChecked {
                self.setImage(checkedImage, for: UIControlState())
            }
        }
    }
    
    open var uncheckedImage: UIImage? = nil {
        didSet {
            if !self.isChecked {
                self.setImage(uncheckedImage, for: UIControlState())
            }
        }
    }
    
    // Bool property
    open var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControlState())
            } else {
                self.setImage(uncheckedImage, for: UIControlState())
            }
        }
    }
    
    open var borderColor: UIColor = UIColor.black {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        self.isChecked = false
        
        self.layer.borderWidth = 1
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttonClicked(_ sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
            self.sendActions(for: .valueChanged)
        }
    }
}

//
//  FragmentButton.swift
//  Portfolio
//
//  Created by Phan Anh Duy on 9/5/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

public typealias FragmentButtonCompletion = (_ indexButton: Int) -> Void

open class FragmentButton: UIView {
    open var completion: FragmentButtonCompletion? = nil
    
    public convenience init(titleButtons: [String], textColor: UIColor, textFont: UIFont) {
       self.init()
        
        //
        var indexButton = 0
        for title in titleButtons {
            if title.characters.count > 0 {
                let btn = UIButton(type: UIButtonType.custom)
                btn.setTitle(title, for: UIControlState())
                btn.setTitleColor(textColor, for: UIControlState())
                btn.titleLabel?.font = textFont
                btn.backgroundColor = UIColor.clear
                btn.tag = indexButton
                btn.addTarget(self, action: #selector(btnTapped(_:)), for: UIControlEvents.touchUpInside)
                self.addSubview(btn)
                
                //
                indexButton += 1
            }
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // layout all buttons
        let sizeOfButton = CGSize(width: self.bounds.size.width / CGFloat(max(self.subviews.count,1)), height: self.bounds.size.height)
        var preButton: UIView? = nil
        for btn in self.subviews {
            btn.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(btn.superview!.snp.centerY).offset(0)
                make.width.equalTo(sizeOfButton.width)
                make.height.equalTo(sizeOfButton.height)
                // get previous button
                if let btnTmp = preButton {
                    make.leading.equalTo(btnTmp.snp.trailing).offset(0)
                } else {
                    make.leading.equalTo(btn.superview!.snp.leading).offset(0)
                }
            })
            
            preButton = btn
        }
    }
    
    func btnTapped(_ sender: UIButton) {
        completion?(sender.tag)
    }
}

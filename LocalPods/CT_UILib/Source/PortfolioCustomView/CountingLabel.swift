//
//  CountingLabel.swift
//  Portfolio
//
//  Created by Khanh Pham on 3/15/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

open class CountingLabel: RichLabel {

    /**
     This block will be called to update text while counting.
     
     Note: This must be assigned in order to update text on label
     
     Parameter: Current value
    */
//    var updateTextBlock: ((Double) -> Void)!
    
    open var textFormatBlock: ((Double) -> String)?
    
    fileprivate var fromValue: Double!
    fileprivate var toValue: Double!
    fileprivate var progress: TimeInterval!
    fileprivate var lastUpdate: TimeInterval!
    fileprivate var totalTime: TimeInterval!
    fileprivate var duration: TimeInterval!
    
    fileprivate var timer: CADisplayLink?
    
    fileprivate var completionHandler: (() -> Void)?
    
    fileprivate func formattedTextForValue(_ value: Double) -> String {
        return textFormatBlock?(value) ?? "\(value)"
    }
    
    open func countFrom(_ fromValue: Double, toValue: Double, duration: TimeInterval, completionHandler: (() -> Void)? = nil) {
        self.duration = duration
        self.fromValue = fromValue
        self.toValue = toValue
        self.completionHandler = completionHandler
        // Remove exist timer
        timer?.invalidate()
        timer = nil
        
        if duration == 0 {
            self.text = formattedTextForValue(toValue)
            self.completionHandler?()
            return
        }
        
        progress = 0
        totalTime = duration
        lastUpdate = Date().timeIntervalSince1970
        
        self.alpha = 0.5
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 1.0
            }) { (_) in
                self.alpha = 1.0
        }
        
        let runTimer = CADisplayLink(target: self, selector: #selector(updateValue(_:)))
        runTimer.frameInterval = 2
        runTimer.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
        runTimer.add(to: RunLoop.main, forMode: RunLoopMode.UITrackingRunLoopMode)
        timer = runTimer
    }
    
    open func updateValue(_ timer: Timer) {
        let now = Date().timeIntervalSince1970
        progress = progress + now - lastUpdate
        lastUpdate = now
        
        var completed = false
        if progress >= totalTime {
            timer.invalidate()
            self.timer = nil
            progress = totalTime
            completed = true
        }
        
        self.text = formattedTextForValue(currentValue)
        
        if completed {
            self.completionHandler?()
        }
    }
    
    open var currentValue: Double {
        if progress >= totalTime {
            return toValue
        }
        
        let percent = progress / totalTime
        
        return fromValue + (toValue - fromValue) * percent
    }

}

//
//  StringExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/22/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import Foundation
import UIKit

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: from))
    }
    
    var length: Int {
        return self.characters.count
    }
    
    static func random(_ length: Int = 20) -> String {
        
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.characters.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        
        return randomString
    }
    
    func convertToNewDateTimeFormat() -> String {
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = bostonTimeZone//currentTimeZone
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let myDate = dateFormatter.date(from: self) ?? Date()
        
        dateFormatter.dateFormat = "MMM dd, YYYY"
        return dateFormatter.string(from: myDate)
        
    }
    
    
    func convertToDate(isBirthDateFormat: Bool = true) -> Date {
        let dateFormatter = DateFormatter()
        ////dateFormatter.timeZone = bostonTimeZone
        dateFormatter.dateFormat = isBirthDateFormat ? "yyyy-MM-dd" : "MMM dd yyyy H:mm a"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return Date()
        //return dateFormatter.date(from: self) ?? Date()
    }
    
    func convertStringToDate() -> Date {
        let dateFormatter = DateFormatter()
        ////dateFormatter.timeZone = bostonTimeZone
        dateFormatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return Date()
        //return dateFormatter.date(from: self) ?? Date()
    }
 
    /**
     Check the string is the email
     
     :returns: ?true:flase
     */
    func isEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        if characters.count < 5 { return false }
        if self == "" { return false }
        return true
    }
    
      
    public var capitalizedFirstLetter: String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    public func lowerThenCapitalizeEachWord() -> String {
        return self.lowercased().capitalized
    }
    
    public func upperSubstring(_ substring: String, ignoreCaseSensitive: Bool = true) -> String {
        var options: NSString.CompareOptions = NSString.CompareOptions()
        if ignoreCaseSensitive {
            options.insert(.caseInsensitive)
        }
        return self.replacingOccurrences(of: substring, with: substring.uppercased(), options: options, range: nil)
    }
    
    public func sentenceCaseString() -> String {
        let string = NSString(string: self)
        return string.replacingCharacters(in: NSMakeRange(0, 1), with: string.substring(to: 1).uppercased()) as String
    }
    
    public func stringByTrimmingWhitespaceAndNewline() -> String {
        let spaceSet = CharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: spaceSet)
    }
    
    public func capitilizeEachWord() -> String {
        let words = self.components(separatedBy: " ")
        var newWords: Array = [String]()
        for word: String in words {
            let index: String.Index =  word.characters.index(word.startIndex, offsetBy: 1)
            let neword = word.substring(to: index).uppercased() + word.substring(from: index)
            newWords.append(neword)
        }
        
        return newWords.joined(separator: " ")
    }
    
    public func capitilizeEachWordOfSentence() -> String {
        var nsString = NSString(string: self)
        do {
            let pattern = "(^|\\.|\\?|\\!)\\s*(\\p{Letter})"
            let nameRegex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options())
            nameRegex.enumerateMatches(in: self, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, self.characters.count)) { (result, flags, stop) in
                if let result = result {
                    let r = result.rangeAt(2) as NSRange
                    nsString = nsString.replacingCharacters(in: r, with: nsString.substring(with: r).uppercased()) as NSString
                }
            }
        } catch let error as NSError {
            NSLog("CapitilizeEachWordOfSentence Error: \(error)")
        }
        
        return nsString as String
    }
    
    /// Get localized string
    var localized: String! {
        let localizedString = NSLocalizedString(self, comment: "")
        if self == localizedString {
            print("CANNOT FIND TRANSLATION FOR STRING \(self)")
        }
        return localizedString
    }

    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.font = font
        label.text = self
        label.sizeToFit()
        
        return label.frame.height
    }
}




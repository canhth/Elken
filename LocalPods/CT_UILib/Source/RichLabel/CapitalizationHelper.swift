//
//  CapitalizationHelper.swift
//  Portfolio
//
//  Created by Nga Pham on 10/4/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import UIKit

public enum TextCapitalizationOption {
    /// Keep the original text
    case none
    
    /// Lowercase all characters
    case lower
    
    /// Uppercase all characters
    case upper
    
    /// Lowercase all text, then uppercase the first letter of beginning word of each sentence
    case lowerThenCapitalizeFirstWordOfSentence
    
    /// Like .lowerThenCapitalizeFirstWordOfSentence, but without lowercase all the rest
    case capitalizeFirstWordOfSentence
    
    /// Uppercase the first letter of each word
    case capitalizeEachWord
    
    /// Lowercase all characters, then uppercase the first letter of each word
    case lowerThenCapitalizeEachWord
}

public extension String {
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
}

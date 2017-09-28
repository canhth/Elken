//
//  Foundation_Extensions.swift
//  Portfolio
//
//  Created by Thuyen Trinh on 4/4/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import Foundation


//MARK: - Custom Operators
infix operator ???: NilCoalescingPrecedence

//thcanh: To fix warning when you use an optional in string interpolation
public func ???<T>(optional: T?, defaultValue: @autoclosure () -> String) -> String {
    switch optional {
    case let value?: return String(describing: value)
    case nil: return defaultValue()
    }
}


// MARK: - String
public extension String {
    
    public func toAttributedString() -> NSAttributedString {
        return NSAttributedString(string: self)
    }
}

// MARK: - Array
public extension Array {
    
    public func scan<U>(_ initial: U, combine: (U, Element) -> U) -> [U] {
        if self.isEmpty { return [] }
        
        var results: [U] = []
        for index in (0..<self.count) {
            if index == 0 {
                results.append(combine(initial, self[0]))
                continue
            }
            
            results.append(combine(results.last!, self[index]))
        }
        
        return results
    }
    
    public func splitBy(_ subSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: subSize).map { startIndex in
            var endIndex = startIndex.advanced(by: subSize)
            // TODO: Just an temporary solution to replace advancedBy ... limit: ...
            endIndex = endIndex > self.count ? self.count : endIndex
            return Array(self[startIndex ..< endIndex])
        }
    }
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    public subscript (atIndex index: Index) -> Iterator.Element? {
        if index < 0 || index >= self.count { return nil }
        return self[index]
    }
}

public extension Collection {
    typealias IElement = Iterator.Element
    public func groupBy<U>(groupingFunction group: (IElement) -> U) -> [U: [IElement]] {
        var result = [U: [IElement]]()
        for item in self {
            let groupKey = group(item)
            // If element has already been added to dictionary, append to it. If not, create one.
            if result[groupKey] != nil {
                result[groupKey]! += [item]
            } else {
                result[groupKey] = [item]
            }
        }
        return result
    }
    
    public func separate(_ predicate: (IElement) -> Bool) -> ([IElement], [IElement]) {
        var array1: [IElement] = []
        var array2: [IElement] = []
        for element in self {
            if predicate(element) {
                array1.append(element)
            } else {
                array2.append(element)
            }
        }
        return (array1, array2)
    }
}

public extension Collection where Iterator.Element: Hashable {
    public func uniqueElements() -> [IElement] {
        return Array(Set(self))
    }
}

// MARK: - Dictionary
public extension Dictionary {
    public mutating func update(optionalValue: Value?, forKey key: Key) {
        if let value = optionalValue {
            self[key] = value
        }
    }
    
    public mutating func update(key: Key, with value: Value?) {
        if let value = value { self[key] = value }
    }
}

public extension Error {
    public var debugDescription: String {
        return (self as NSError).debugDescription
    }
    
    public var code: Int {
        return (self as NSError).code
    }
    
    public var domain: String {
        return (self as NSError).domain
    }
}

public extension NSError {
    public convenience init(domain: String, code: Int, descriptionKey: String? = nil) {
        if let descriptionKey = descriptionKey {
            self.init(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: descriptionKey])
        } else {
            self.init(domain: domain, code: code, userInfo: nil)
        }
    }
}

// MARK: - MFFloatingPoint
public protocol MFFloatingPoint {
    init(_ value: Double)
    var doubleValue: Double { get }
}

extension Double: MFFloatingPoint {
    public var doubleValue: Double { return self }
}

extension Float: MFFloatingPoint {
    public var doubleValue: Double { return Double(self) }
}

extension CGFloat: MFFloatingPoint {
    public var doubleValue: Double { return Double(self) }
}

public extension MFFloatingPoint {
    public var intValue: Int {
        return Int(doubleValue)
    }
    
    public var floatValue: Float {
        return Float(doubleValue)
    }
    
    public func toNilIfZero() -> Double? {
        return doubleValue > 0 ? doubleValue : nil
    }
    
    /// Rounds the double to decimal places value
    public func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (doubleValue * divisor).rounded() / divisor
    }
    
    // Given a value to round and a factor to round to,
    // round the value DOWN to the largest previous multiple
    // of that factor.
    public func roundDown(toNearest: MFFloatingPoint) -> Double {
        let _toNearestDouble = toNearest.doubleValue
        return floor(doubleValue / _toNearestDouble) * _toNearestDouble
    }
    
    // Given a value to round and a factor to round to,
    // round the value DOWN to the largest previous multiple
    // of that factor.
    public func roundUp(toNearest: MFFloatingPoint) -> Double {
        let _toNearestDouble = toNearest.doubleValue
        return ceil(doubleValue / _toNearestDouble) * _toNearestDouble
    }
}

// MARK: - Integer
public extension Integer {
    public var doubleValue: Double {
        return Double(self.toIntMax())
    }
    
    public func toNilIfZero() -> Int? {
        return self > 0 ? Int(self.toIntMax()) : nil
    }
}

public extension Comparable {
    public func adjustToBounds(min minValue: Self, max maxValue: Self) -> Self {
        if self <= minValue { return minValue }
        if self >= maxValue { return maxValue }
        return self
    }
}

// MARK: - Optionals
public protocol MFOptionalProtocol {
    associatedtype Wrapped
    var mf_optional: Wrapped? { get }
}

extension Optional: MFOptionalProtocol {
    public var mf_optional: Wrapped? { return self }
}

public extension MFOptionalProtocol {
    public func fallbackIfNil(to defaultValue: Wrapped) -> Wrapped {
        return mf_optional ?? defaultValue
    }
}

public extension MFOptionalProtocol where Wrapped == String {
    public var isNilOrEmpty: Bool {
        return mf_optional == nil || mf_optional == ""
    }
    
    public var isNilOrEmptyWithTrimming: Bool {
        return mf_optional == nil || mf_optional?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == ""
    }
    
    public var toEmptyIfNil: String {
        return fallbackIfNil(to: "")
    }
}

public extension MFOptionalProtocol where Wrapped: Integer {
    public var toZeroIfNil: Wrapped {
        return fallbackIfNil(to: 0)
    }
}

public extension MFOptionalProtocol where Wrapped: MFFloatingPoint {
    public var toZeroIfNil: Wrapped {
        return fallbackIfNil(to: Wrapped(0))
    }
}

public extension MFOptionalProtocol where Wrapped: Collection {
    public var isNilOrEmpty: Bool {
        if self.mf_optional == nil { return true }
        return self.mf_optional!.isEmpty
    }
}

// MARK: - Bundle
public extension Bundle {
    public static var executableName: String? {
        return Bundle.main.infoDictionary?["CFBundleExecutable"] as? String
    }
}

// MARK: - NSKeyedArchiver/NSKeyedUnarchiver
public extension NSKeyedArchiver {
    public class func mf_setClassName(_ codedName: String?, forClass cls: AnyClass) {
        // Ex:  class: MFNotifications --> codedName: MFNotifications
        //      class: KateSpade.MFNotifications --> codedName: MFNotifications
        let executableName = Bundle.executableName ?? ""
        let mf_codedName = codedName.map { $0.replacingOccurrences(of: "\(executableName).", with: "") }
        setClassName(mf_codedName, for: cls)
    }
    
    // TODO: Try to handle exception later or add more logs to find out why the app crashed
    public class func mf_archivedDataWithRootObject(_ rootObject: AnyObject) -> Data {
        return archivedData(withRootObject: rootObject)
    }
}

public extension NSKeyedUnarchiver {
    public class func mf_setClass(_ cls: AnyClass?, forClassName codedName: String) {
        // Ex:  class: codedName: MFNotifications --> class: MFNotifications
        //      class: codedName: KateSpade.MFNotifications --> class: MFNotifications
        let executableName = Bundle.executableName ?? ""
        let clsNameWithAppName = "\(executableName).\(codedName)"
        setClass(cls, forClassName: codedName)
        setClass(cls, forClassName: clsNameWithAppName)
    }
    
    // TODO: Try to handle exception later or add more logs to find out why the app crashed
    public class func mf_unarchiveObject(with data: Data) -> AnyObject? {
        if #available(iOS 9.0, *) {
            do {
                return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data as NSData)
            } catch {
                //DDLogDebug("NSKeyedUnarchiver. mf_unarchiveObjectWithData: can't unarchiveTopLevelObjectWithData.")
                return nil
            }
        } else {
            return unarchiveObject(with: data) as AnyObject?
        }
    }
}

// MARK: - Notification
public extension NotificationCenter {
    public func post(name: String, object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        post(name: .init(name), object: object, userInfo: userInfo)
    }
}

// MARK: - UserDefaults
public extension UserDefaults {
    public func removeAll(except keys: [String]) {
        for (key, _) in dictionaryRepresentation() {
            if !keys.contains(key) {
                removeObject(forKey: key)
            }
        }
    }
}

// MARK: - UInt32
public extension UInt32 {
    var asByteArray: [UInt8] {
        return [0, 8, 16, 24]
            .map { UInt8(self >> $0 & 0x000000FF) }
    }
}

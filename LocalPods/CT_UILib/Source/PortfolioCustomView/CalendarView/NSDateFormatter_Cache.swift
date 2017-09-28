//
//  Date.swift
//  Fossil
//
//  Created by Matthew Yannascoli on 02/01/15.
//  Copyright (c) 2014 Fossil, Inc. All rights reserved.
//

import Foundation

public var yyyymmddDateFormatter = DateFormatter.yyyymmddFormatter_LocalTimezone_US_POSIX()

public extension DateFormatter {
    
    struct SpecialFormatterKeys {
        static let ServerFullDay_GMT_US_POSIX = "ServerFullDay_GMT_US_POSIX"
        static let ServerDay_LocalTimezone_US_POSIX = "ServerDay_LocalTimezone_US_POSIX"
        static let ServerHour_LocalTimezone_US_POSIX = "ServerHour_LocalTimezone_US_POSIX"
        
        static let YYYYMMDD_LocalTimezone_US_POSIX = "YYYYMMDD_LocalTimezone_US_POSIX"
    }
    
    fileprivate class func objectFromThreadDictionary(_ key: String, timezone: Foundation.TimeZone = .autoupdatingCurrent, objectCreationBlock: () -> DateFormatter) -> DateFormatter {
        var object : DateFormatter? = Thread.current.threadDictionary[key] as? DateFormatter
        
        // If formatter already exists on thread, return it
        if let o = object {
            o.timeZone = timezone
            return o
        }
        
        // Return formatter via a block method and save it in the current thread's dictionary
        object = objectCreationBlock() as DateFormatter
        Thread.current.threadDictionary[key] = object
        
        return object!
    }
    
    public class func dateFormatter(_ format: String) -> DateFormatter {
        
        let dateFormatter = DateFormatter.objectFromThreadDictionary("DateFormatter_\(format)", objectCreationBlock: { () -> DateFormatter in
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter
        })
        
        return dateFormatter
    }
    
    public class func yyyymmddFormatter_LocalTimezone_US_POSIX() -> DateFormatter {
        let formatter = DateFormatter.objectFromThreadDictionary(SpecialFormatterKeys.YYYYMMDD_LocalTimezone_US_POSIX) { () -> DateFormatter in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }
        return formatter
    }
    
    public class func serverFullDateFormatter_GMT_US_POSIX() -> DateFormatter {
        let defaultTimeZone = Foundation.TimeZone(identifier: "GMT") ?? Foundation.TimeZone(secondsFromGMT: 0)!
        let formatter = DateFormatter.objectFromThreadDictionary(SpecialFormatterKeys.ServerFullDay_GMT_US_POSIX, timezone: defaultTimeZone) { () -> DateFormatter in
            let formatter = DateFormatter()
            formatter.timeZone = Foundation.TimeZone(identifier: "GMT")
            formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }
        return formatter
    }
    
    public class func serverDateFormatter_LocalTimezone_POSIX() -> DateFormatter {
        let formatter = DateFormatter.objectFromThreadDictionary(SpecialFormatterKeys.ServerDay_LocalTimezone_US_POSIX) { () -> DateFormatter in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }
        return formatter
    }
    
    public class func serverHourFormatter_LocalTimezone_POSIX() -> DateFormatter {
        let formatter = DateFormatter.objectFromThreadDictionary(SpecialFormatterKeys.ServerHour_LocalTimezone_US_POSIX) { () -> DateFormatter in
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm:ssa"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }
        return formatter
    }
}

public extension DateFormatter {
    
    // refer: https://developer.apple.com/reference/foundation/nsdateformatter/1411441-lenient
    // use heuristics to guess at the valid date
    public func getValidDateFromString(_ string: String) -> Date? {
        // on flag lenient to guess the valid date
        self.isLenient = true
        return self.date(from: string)
    }
    
    public func dateFromStringWithCLSLog(_ string: String) -> Date {
        var result = date(from: string)
        
        // NOTE: we will use heuristics to guess at the valid date
        if result == nil {
            result = self.getValidDateFromString(string)
        }
        
        if result == nil {
            let currentLocale = Locale.current
            let languageCode = (currentLocale as NSLocale).object(forKey: NSLocale.Key.languageCode) as? String ?? ""
            let countryCode = (currentLocale as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String ?? ""
//            MFCrashlyticsLog.logv("NSDateFormatter.dateFromStringWithCLSLog()\nReason: Unexpectedly found nil while unwrapping an Optional value.\nData for investigate: date string: %@, language code: %@, country code: %@", getVaList([string, languageCode, countryCode]))
        }
        return result!
    }
    
    public func intValueFromDateWithCLSLog(_ date: Date) -> Int {
        let dateString = string(from: date)
        let result = Int(dateString)
        if result == nil {
            let currentLocale = Locale.current
            let languageCode = (currentLocale as NSLocale).object(forKey: NSLocale.Key.languageCode) as? String ?? ""
            let countryCode = (currentLocale as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String ?? ""
//            MFCrashlyticsLog.logv("NSDateFormatter.intValueFromDateWithCLSLog()\nReason: Unexpectedly found nil while unwrapping an Optional value.\nData for investigate: date string: %@, language code: %@, country code: %@", getVaList([dateString, languageCode, countryCode]))
        }
        
        return result!
    }
    
}

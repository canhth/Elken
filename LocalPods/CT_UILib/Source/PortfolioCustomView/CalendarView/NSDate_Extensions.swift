//
//  NSDate_Extensions.swift
//  Portfolio
//
//  Created by Thuyen Trinh on 3/10/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import Foundation

// Ref: https://github.com/melvitax/AFDateHelper/blob/master/AFDateHelper/AFDateExtension.swift

import Foundation

// DotNet: "/Date(1268123281843)/"
let DefaultFormat = "EEE MMM dd HH:mm:ss Z yyyy"
let RSSFormat = "EEE, d MMM yyyy HH:mm:ss ZZZ" // "Fri, 09 Sep 2011 15:26:08 +0200"
let AltRSSFormat = "d MMM yyyy HH:mm:ss ZZZ" // "09 Sep 2011 15:26:08 +0200"

public enum ISO8601Format: String {
    
    case Year = "yyyy" // 1997
    case YearMonth = "yyyy-MM" // 1997-07
    case Date = "yyyy-MM-dd" // 1997-07-16
    case DateTime = "yyyy-MM-dd'T'HH:mmZ" // 1997-07-16T19:20+01:00
    case DateTimeSec = "yyyy-MM-dd'T'HH:mm:ssZ" // 1997-07-16T19:20:30+01:00
    case DateTimeMilliSec = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // 1997-07-16T19:20:30.45+01:00
    
    public init(dateString:String) {
        switch dateString.characters.count {
        case 4:
            self = ISO8601Format(rawValue: ISO8601Format.Year.rawValue)!
        case 7:
            self = ISO8601Format(rawValue: ISO8601Format.YearMonth.rawValue)!
        case 10:
            self = ISO8601Format(rawValue: ISO8601Format.Date.rawValue)!
        case 22:
            self = ISO8601Format(rawValue: ISO8601Format.DateTime.rawValue)!
        case 25:
            self = ISO8601Format(rawValue: ISO8601Format.DateTimeSec.rawValue)!
        default:// 28:
            self = ISO8601Format(rawValue: ISO8601Format.DateTimeMilliSec.rawValue)!
        }
    }
}

public enum DateFormat {
    case iso8601(ISO8601Format?), dotNet, rss, altRSS, custom(String)
}

public enum MFTimeZone {
    case local, utc
}

private extension Calendar {
    static func mf_calendar() -> Calendar {
        var calendar = Calendar.current
        // NOTE: tnthuyen: Currently the Portfolio app is using first week day as SUNDAY
        // All date public extensions must use `mf_calendar()` instead of `currentCalendar`
        calendar.firstWeekday = 1   // SUNDAY
        return calendar
    }
}

public extension Date {
    
    // MARK: Intervals In Seconds
    fileprivate static func minuteInSeconds() -> Double { return 60 }
    fileprivate static func hourInSeconds() -> Double { return 3600 }
    fileprivate static func dayInSeconds() -> Double { return 86400 }
    fileprivate static func weekInSeconds() -> Double { return 604800 }
    fileprivate static func yearInSeconds() -> Double { return 31556926 }
    
    // MARK: Components
    fileprivate static func componentFlags() -> NSCalendar.Unit { return [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.weekOfYear, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second, NSCalendar.Unit.weekday, NSCalendar.Unit.weekdayOrdinal, NSCalendar.Unit.weekOfYear] }
    
    fileprivate static func components(fromDate: Date) -> DateComponents! {
        return (Calendar.mf_calendar() as NSCalendar).components(Date.componentFlags(), from: fromDate)
    }
    
    fileprivate func components() -> DateComponents  {
        return Date.components(fromDate: self)!
    }
    
    // MARK: Date From String
    
    /**
     Creates a date based on a string and a formatter type. You can ise .ISO8601(nil) to for deducting an ISO8601Format automatically.
     
     - Parameter fromString Date string i.e. "16 July 1972 6:12:00".
     - Parameter format The Date Formatter type can be .ISO8601(ISO8601Format?), .DotNet, .RSS, .AltRSS or Custom(String).
     - Parameter timeZone: The time zone to interpret fromString can be .Local, .UTC applies to Custom format only
     
     - Returns A new date
     */
    
    init(fromString string: String, format:DateFormat, timeZone: MFTimeZone = .local)
    {
        if string.isEmpty {
            self.init()
            return
        }
        
        let string = string as NSString
        
        let zone: TimeZone
        
        switch timeZone {
        case .local:
            zone = TimeZone.autoupdatingCurrent
        case .utc:
            zone = TimeZone(secondsFromGMT: 0)!
        }
        
        switch format {
            
        case .dotNet:
            
            let startIndex = string.range(of: "(").location + 1
            let endIndex = string.range(of: ")").location
            let range = NSRange(location: startIndex, length: endIndex-startIndex)
            let milliseconds = (string.substring(with: range) as NSString).longLongValue
            let interval = TimeInterval(milliseconds / 1000)
            self.init(timeIntervalSince1970: interval)
            
        case .iso8601(let isoFormat):
            
            let dateFormat = (isoFormat != nil) ? isoFormat! : ISO8601Format(dateString: string as String)
            let formatter = Date.formatter(format: dateFormat.rawValue)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone.autoupdatingCurrent
            formatter.dateFormat = dateFormat.rawValue
            if let date = formatter.date(from: string as String) {
                self.init(timeInterval:0, since:date)
            } else {
                self.init()
            }
            
        case .rss:
            
            var s  = string
            if string.hasSuffix("Z") {
                s = s.substring(to: s.length-1) + "GMT" as NSString
            }
            let formatter = Date.formatter(format: RSSFormat)
            if let date = formatter.date(from: string as String) {
                self.init(timeInterval:0, since:date)
            } else {
                self.init()
            }
            
        case .altRSS:
            
            var s  = string
            if string.hasSuffix("Z") {
                s = s.substring(to: s.length-1) + "GMT" as NSString
            }
            let formatter = Date.formatter(format: AltRSSFormat)
            if let date = formatter.date(from: string as String) {
                self.init(timeInterval:0, since:date)
            } else {
                self.init()
            }
            
        case .custom(let dateFormat):
            
            let formatter = Date.formatter(format: dateFormat, timeZone: zone)
            if let date = formatter.date(from: string as String) {
                self.init(timeInterval:0, since:date)
            } else {
                self.init()
            }
        }
    }
    
    
    
    // MARK: Comparing Dates
    
    /**
     Returns true if dates are equal while ignoring time.
     
     - Parameter date: The Date to compare.
     */
    public func isEqualToDateIgnoringTime(_ date: Date) -> Bool
    {
        return self.yyyymmdd() == date.yyyymmdd()
//        let comp1 = NSDate.components(fromDate: self)
//        let comp2 = NSDate.components(fromDate: date)
//        return ((comp1.year == comp2.year) && (comp1.month == comp2.month) && (comp1.day == comp2.day))
    }
    
    /**
     Returns Returns true if date is today.
     */
    public func isToday() -> Bool
    {
        return self.isEqualToDateIgnoringTime(Date.now)
    }
    
    /**
     Returns true if date is tomorrow.
     */
    public func isTomorrow() -> Bool
    {
        return self.isEqualToDateIgnoringTime(Date.now.dateByAddingDays(1))
    }
    
    /**
     Returns true if date is yesterday.
     */
    public func isYesterday() -> Bool
    {
        return self.isEqualToDateIgnoringTime(Date.now.dateBySubtractingDays(1))
    }
    
    /**
     Returns true if date is yesterday or before yesterday
    */
    public func isYesterdayOrBefore() -> Bool {
        return self.isEarlierThanDateIgnoringTime(Date.now)
    }
    
    /**
     Returns true if date are in the same week.
     
     - Parameter date: The date to compare.
     */
    public func isSameWeekAsDate(_ date: Date) -> Bool
    {
        let comp1 = Date.components(fromDate: self)
        let comp2 = Date.components(fromDate: date)
        // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
        if comp1?.weekOfYear != comp2?.weekOfYear {
            return false
        }
        // Must have a time interval under 1 week
        return abs(self.timeIntervalSince(date)) < Date.weekInSeconds()
    }
    
    /**
     Returns true if date is this week.
     */
    public func isThisWeek() -> Bool
    {
        return self.isSameWeekAsDate(Date.now)
    }
    
    /**
     Returns true if date is next week.
     */
    public func isNextWeek() -> Bool
    {
        let interval: TimeInterval = Date.now.timeIntervalSinceReferenceDate + Date.weekInSeconds()
        let date = Date(timeIntervalSinceReferenceDate: interval)
        return self.isSameWeekAsDate(date)
    }
    
    /**
     Returns true if date is last week.
     */
    public func isLastWeek() -> Bool
    {
        let interval: TimeInterval = Date.now.timeIntervalSinceReferenceDate - Date.weekInSeconds()
        let date = Date(timeIntervalSinceReferenceDate: interval)
        return self.isSameWeekAsDate(date)
    }
    
    /**
     Returns true if dates are in the same year.
     
     - Parameter date: The date to compare.
     */
    public func isSameYearAsDate(_ date: Date) -> Bool
    {
        let comp1 = Date.components(fromDate: self)
        let comp2 = Date.components(fromDate: date)
        return (comp1!.year == comp2!.year)
    }
    
    /**
     Returns true if date is this year.
     */
    public func isThisYear() -> Bool
    {
        return self.isSameYearAsDate(Date.now)
    }
    
    /**
     Returns true if date is next year.
     */
    public func isNextYear() -> Bool
    {
        let comp1 = Date.components(fromDate: self)
        let comp2 = Date.components(fromDate: Date.now)
        return (comp1!.year! == comp2!.year! + 1)
    }
    
    /**
     Returns true if date is last year.
     */
    public func isLastYear() -> Bool
    {
        let comp1 = Date.components(fromDate: self)
        let comp2 = Date.components(fromDate: Date.now)
        return (comp1!.year! == comp2!.year! - 1)
    }
    
    /**
     Returns true if date is earlier than date.
     
     - Parameter date: The date to compare.
     */
    public func isEarlierThanDate(_ date: Date) -> Bool
    {
        return (self as NSDate).earlierDate(date) == self
    }
    
    /**
     Returns true if date is later than date.
     
     - Parameter date: The date to compare.
     */
    public func isLaterThanDate(_ date: Date) -> Bool
    {
        return (self as NSDate).laterDate(date) == self
    }
    
    /**
     Returns true if date is in future.
     */
    public func isInFuture() -> Bool
    {
        return self.isLaterThanDate(Date.now)
    }
    
    /**
     Returns true if date is in past.
     */
    public func isInPast() -> Bool
    {
        return self.isEarlierThanDate(Date.now)
    }
    
    
    // MARK: Adjusting Dates
    
    /**
     Creates a new date by a adding days.
     
     - Parameter days: The number of days to add.
     - Returns A new date object.
     */
    public func dateByAddingDays(_ days: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.day = days
        return (Calendar.mf_calendar() as NSCalendar).date(byAdding: dateComp, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    /**
     Creates a new date by a substracting days.
     
     - Parameter days: The number of days to substract.
     - Returns A new date object.
     */
    public func dateBySubtractingDays(_ days: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.day = (days * -1)
        return (Calendar.mf_calendar() as NSCalendar).date(byAdding: dateComp, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    /**
     Creates a new date by a adding hours.
     
     - Parameter days: The number of hours to add.
     - Returns A new date object.
     */
    public func dateByAddingHours(_ hours: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.hour = hours
        return (Calendar.mf_calendar() as NSCalendar).date(byAdding: dateComp, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    /**
     Creates a new date by substracting hours.
     
     - Parameter days: The number of hours to substract.
     - Returns A new date object.
     */
    public func dateBySubtractingHours(_ hours: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.hour = (hours * -1)
        return (Calendar.mf_calendar() as NSCalendar).date(byAdding: dateComp, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    /**
     Creates a new date by adding minutes.
     
     - Parameter days: The number of minutes to add.
     - Returns A new date object.
     */
    public func dateByAddingMinutes(_ minutes: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.minute = minutes
        return (Calendar.mf_calendar() as NSCalendar).date(byAdding: dateComp, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    /**
     Creates a new date by substracting minutes.
     
     - Parameter days: The number of minutes to add.
     - Returns A new date object.
     */
    public func dateBySubtractingMinutes(_ minutes: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.minute = (minutes * -1)
        return (Calendar.mf_calendar() as NSCalendar).date(byAdding: dateComp, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    /**
     Creates a new date by adding seconds.
     
     - Parameter seconds: The number of seconds to add.
     - Returns A new date object.
     */
    public func dateByAddingSeconds(_ seconds: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.second = seconds
        return (Calendar.mf_calendar() as NSCalendar).date(byAdding: dateComp, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    /**
     Creates a new date by substracting seconds.
     
     - Parameter days: The number of seconds to substract.
     - Returns A new date object.
     */
    public func dateBySubtractingSeconds(_ seconds: Int) -> Date
    {
        var dateComp = DateComponents()
        dateComp.second = (seconds * -1)
        return (Calendar.mf_calendar() as NSCalendar).date(byAdding: dateComp, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    /**
     For alarm, time show in UI alarm must ignore DST
     Story:
     * When DST change (ex: Tehran,...), start of date begin from 01:00 not expected 00:00
     - If we have alarm was set in 00:30 (minuteInMightnight = 30) and use local time + minuteInMightnight = 01:30
     * How we fix here:
     - If keepDate = true
     + Move date foward or backward dst offset (ex: 3600s) in the first and last date in DST duration
     - If keepDate = false (NOTE: use for UI only)
     + Move date foward or backward 1 day in the first and last date in DST duration
     */
    public func dateIgnoreDST(keepDay: Bool = false) -> Date
    {
        let startOfDay = Date.now.dateAtStartOfDay()
        let startDateBeforeDSTChange = startOfDay.dateByAddingDays(-1)
        let nextDSTDate = NSTimeZone.local.nextDaylightSavingTimeTransition(after: startDateBeforeDSTChange)
        if let nextDSTDate = nextDSTDate, nextDSTDate.isSameDayAsDate(startOfDay) {
            if NSTimeZone.local.isDaylightSavingTime(for: startDateBeforeDSTChange) {
                if keepDay {
                    return self.addingTimeInterval(NSTimeZone.local.daylightSavingTimeOffset(for: startOfDay))
                }
                return self.dateByAddingDays(1)
            } else {
                if keepDay {
                    return self.addingTimeInterval(-NSTimeZone.local.daylightSavingTimeOffset(for: startOfDay))
                }
                return self.dateByAddingDays(-1)
            }
        }
        
        return self
    }
    
    /**
     Creates a new date from the start of the day.
     
     - Returns A new date object.
     */
    public func dateAtStartOfDay() -> Date
    {
        var components = self.components()
        components.hour = 0
        components.minute = 0
        components.second = 0
        return Calendar.mf_calendar().date(from: components)!
    }
    
    /**
     Creates a new date from the end of the day.
     
     - Returns A new date object.
     */
    public func dateAtEndOfDay() -> Date
    {
        var components = self.components()
        components.hour = 23
        components.minute = 59
        components.second = 59
        return Calendar.mf_calendar().date(from: components)!
    }
    
    /**
     Creates a new date from the start of the week.
     - StartOfWeek is SUNDAY
     - Returns A new date object.
     */
    public func dateAtStartOfWeek() -> Date
    {
        let flags :NSCalendar.Unit = [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.weekOfYear, NSCalendar.Unit.weekday, NSCalendar.Unit.yearForWeekOfYear]
        var components = (Calendar.mf_calendar() as NSCalendar).components(flags, from: self)
        components.weekday = Calendar.mf_calendar().firstWeekday
        components.hour = 0
        components.minute = 0
        components.second = 0
        return Calendar.mf_calendar().date(from: components)!
    }
    
    /**
     Creates a new date from the end of the week.
     - EndOfWeek is SUNDAY
     - Returns A new date object.
     */
    public func dateAtEndOfWeek() -> Date
    {
        let flags :NSCalendar.Unit = [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.weekOfYear, NSCalendar.Unit.weekday, NSCalendar.Unit.yearForWeekOfYear]
        var components = (Calendar.mf_calendar() as NSCalendar).components(flags, from: self)
        components.weekday = Calendar.mf_calendar().firstWeekday + 6
        components.hour = 0
        components.minute = 0
        components.second = 0
        return Calendar.mf_calendar().date(from: components)!
    }
    
    /**
     Creates a new date from the first day of the month
     
     - Returns A new date object.
     */
    public func dateAtStartOfMonth() -> Date
    {
        //Create the date components
        var components = self.components()
        components.day = 1
        //Builds the first day of the month
        let firstDayOfMonthDate :Date = Calendar.mf_calendar().date(from: components)!
        return firstDayOfMonthDate
        
    }
    
    /**
     Creates a new date from the last day of the month
     
     - Returns A new date object.
     */
    public func dateAtEndOfMonth() -> Date {
        
        //Create the date components
        var components = self.components()
        //Set the last day of this month
        components.month = (components.month ?? 0) + 1
        components.day = 0
        
        //Builds the first day of the month
        let lastDayOfMonth: Date = Calendar.mf_calendar().date(from: components)!
        return lastDayOfMonth
        
    }
    
    /**
     Creates a new date based on tomorrow.
     
     - Returns A new date object.
     */
    static public func tomorrow() -> Date
    {
        return Date.now.dateByAddingDays(1).dateAtStartOfDay()
    }
    
    /**
     Creates a new date based on yesterdat.
     
     - Returns A new date object.
     */
    static public func yesterday() -> Date
    {
        return Date.now.dateBySubtractingDays(1).dateAtStartOfDay()
    }
    
    /**
     Return a new NSDate object with the new hour, minute and seconds values
     
     :returns: NSDate
     */
    public func setTimeOfDate(hour: Int, minute: Int, second: Int) -> Date {
        var components = self.components()
        components.hour = hour
        components.minute = minute
        components.second = second
        return Calendar.mf_calendar().date(from: components)!
    }
    
    
    // MARK: Retrieving Intervals
    
    /**
     Gets the number of seconds after a date.
     
     - Parameter date: the date to compare.
     - Returns The number of seconds
     */
    public func secondsAfterDate(_ date: Date) -> Int
    {
        return Int(self.timeIntervalSince(date))
    }
    
    /**
     Gets the number of seconds before a date.
     
     - Parameter date: The date to compare.
     - Returns The number of seconds
     */
    public func secondsBeforeDate(_ date: Date) -> Int
    {
        return Int(date.timeIntervalSince(self))
    }
    
    /**
     Gets the number of minutes after a date.
     
     - Parameter date: the date to compare.
     - Returns The number of minutes
     */
    public func minutesAfterDate(_ date: Date) -> Int
    {
        let interval = self.timeIntervalSince(date)
        return Int(interval / Date.minuteInSeconds())
    }
    
    /**
     Gets the number of minutes before a date.
     
     - Parameter date: The date to compare.
     - Returns The number of minutes
     */
    public func minutesBeforeDate(_ date: Date) -> Int
    {
        let interval = date.timeIntervalSince(self)
        return Int(interval / Date.minuteInSeconds())
    }
    
    /**
     Gets the number of hours after a date.
     
     - Parameter date: The date to compare.
     - Returns The number of hours
     */
    public func hoursAfterDate(_ date: Date) -> Int
    {
        let interval = self.timeIntervalSince(date)
        return Int(interval / Date.hourInSeconds())
    }
    
    /**
     Gets the number of hours before a date.
     
     - Parameter date: The date to compare.
     - Returns The number of hours
     */
    public func hoursBeforeDate(_ date: Date) -> Int
    {
        let interval = date.timeIntervalSince(self)
        return Int(interval / Date.hourInSeconds())
    }
    
    /**
     Gets the number of days after a date.
     
     - Parameter date: The date to compare.
     - Returns The number of days
     */
    public func daysAfterDate(_ date: Date) -> Int
    {
        let interval = self.dateAtStartOfDay().timeIntervalSince(date.dateAtStartOfDay())
        return Int(interval / Date.dayInSeconds())
    }
    
    /**
     Gets the number of days before a date.
     
     - Parameter date: The date to compare.
     - Returns The number of days
     */
    public func daysBeforeDate(_ date: Date) -> Int
    {
        let interval = date.dateAtStartOfDay().timeIntervalSince(self.dateAtStartOfDay())
        return Int(interval / Date.dayInSeconds())
    }
    
    
    // MARK: Decomposing Dates
    
    /**
     Returns the nearest hour.
     */
    public func nearestHour () -> Int {
        let halfHour = Date.minuteInSeconds() * 30
        var interval = self.timeIntervalSinceReferenceDate
        if  self.seconds() < 30 {
            interval -= halfHour
        } else {
            interval += halfHour
        }
        let date = Date(timeIntervalSinceReferenceDate: interval)
        return date.hour()
    }
    /**
     Returns the year component.
     */
    public func year () -> Int { return self.components().year!  }
    /**
     Returns the month component.
     */
    public func month () -> Int { return self.components().month! }
    /**
     Returns the week of year component.
     */
    public func week () -> Int { return self.components().weekOfYear! }
    /**
     Returns the day component.
     */
    public func day () -> Int { return self.components().day! }
    /**
     Returns the hour component.
     */
    public func hour () -> Int { return self.components().hour! }
    /**
     Returns the minute component.
     */
    public func minute () -> Int { return self.components().minute! }
    /**
     Returns the seconds component.
     */
    public func seconds () -> Int { return self.components().second! }
    /**
     Returns the weekday component.
     */
    public func weekday () -> Int { return self.components().weekday! }
    /**
     Returns the nth days component. e.g. 2nd Tuesday of the month is 2.
     */
    public func nthWeekday () -> Int { return self.components().weekdayOrdinal! }
    /**
     Returns the days of the month.
     */
    
    public func monthDays () -> Int { return (Calendar.mf_calendar() as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: self).length }
    
    /**
     Returns the first day of the week.
     */
    public func firstDayOfWeek () -> Int {
        let distanceToStartOfWeek = Date.dayInSeconds() * Double(self.components().weekday! - 1)
        let interval: TimeInterval = self.timeIntervalSinceReferenceDate - distanceToStartOfWeek
        return Date(timeIntervalSinceReferenceDate: interval).day()
    }
    /**
     Returns the last day of the week.
     */
    public func lastDayOfWeek () -> Int {
        let distanceToStartOfWeek = Date.dayInSeconds() * Double(self.components().weekday! - 1)
        let distanceToEndOfWeek = Date.dayInSeconds() * Double(7)
        let interval: TimeInterval = self.timeIntervalSinceReferenceDate - distanceToStartOfWeek + distanceToEndOfWeek
        return Date(timeIntervalSinceReferenceDate: interval).day()
    }
    /**
     Returns true if a weekday.
     */
    public func isWeekday() -> Bool {
        return !self.isWeekend()
    }
    /**
     Returns true if weekend.
     */
    public func isWeekend() -> Bool {
        let range = (Calendar.mf_calendar() as NSCalendar).maximumRange(of: NSCalendar.Unit.weekday)
        return (self.weekday() == range.location || self.weekday() == range.length)
    }
    
    
    // MARK: To String
    
    /**
     A string representation using short date and time style.
     */
    public func toString() -> String {
        return self.toString(dateStyle: .short, timeStyle: .short, doesRelativeDateFormatting: false)
    }
    
    /**
     A string representation based on a format.
     
     - Parameter format: The format of date can be .ISO8601(.ISO8601Format?), .DotNet, .RSS, .AltRSS or Custom(FormatString).
     - Parameter timeZone: The time zone to interpret the date can be .Local, .UTC applies to Custom format only
     - Returns The date string representation
     */
    public func toString(format: DateFormat, timeZone: MFTimeZone = .local) -> String
    {
        var dateFormat: String
        let zone: TimeZone
        switch format {
        case .dotNet:
            let offset = NSTimeZone.default.secondsFromGMT() / 3600
            let nowMillis = 1000 * self.timeIntervalSince1970
            return  "/Date(\(nowMillis)\(offset))/"
        case .iso8601(let isoFormat):
            dateFormat = (isoFormat != nil) ? isoFormat!.rawValue : ISO8601Format.DateTimeMilliSec.rawValue
            zone = TimeZone.autoupdatingCurrent
        case .rss:
            dateFormat = RSSFormat
            zone = TimeZone.autoupdatingCurrent
        case .altRSS:
            dateFormat = AltRSSFormat
            zone = TimeZone.autoupdatingCurrent
        case .custom(let string):
            switch timeZone {
            case .local:
                zone = TimeZone.autoupdatingCurrent
            case .utc:
                zone = TimeZone(secondsFromGMT: 0)!
            }
            dateFormat = string
        }
        
        let formatter = Date.formatter(format: dateFormat, timeZone: zone)
        return formatter.string(from: self)
    }
    
    /**
     A string representation based on custom style.
     
     - Parameter dateStyle: The date style to use.
     - Parameter timeStyle: The time style to use.
     - Parameter doesRelativeDateFormatting: Enables relative date formatting.
     - Parameter timeZone: The time zone to use.
     - Parameter locale: The locale to use.
     - Returns A string representation of the date.
     */
    public func toString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, doesRelativeDateFormatting: Bool = false, timeZone: TimeZone = TimeZone.autoupdatingCurrent, locale: Locale = Locale.current) -> String
    {
        let formatter = Date.formatter(dateStyle: dateStyle, timeStyle: timeStyle, doesRelativeDateFormatting: doesRelativeDateFormatting, timeZone: timeZone, locale: locale)
        return formatter.string(from: self)
    }
    
    /**
     A string representation based on a relative time language. i.e. just now, 1 minute ago etc..
     */
    public func relativeTimeToString() -> String
    {
        let time = self.timeIntervalSince1970
        let now = Date.now.timeIntervalSince1970
        
        let timeIsInPast = now - time > 0
        
        let seconds = abs(now - time)
        let minutes = round(seconds/60)
        let hours = round(minutes/60)
        let days = round(hours/24)
        
        func describe(_ time: String) -> String {
            if timeIsInPast { return "\(time) ago" }
            else { return "in \(time)" }
        }
        
        if seconds < 10 {
            return NSLocalizedString("just now", comment: "Show the relative time from a date")
        } else if seconds < 60 {
            let relativeTime = NSLocalizedString(describe("%.f seconds"), comment: "Show the relative time from a date")
            return String(format: relativeTime, seconds)
        }
        
        if minutes < 60 {
            if minutes == 1 {
                return NSLocalizedString(describe("1 minute"), comment: "Show the relative time from a date")
            } else {
                let relativeTime = NSLocalizedString(describe("%.f minutes"), comment: "Show the relative time from a date")
                return String(format: relativeTime, minutes)
            }
        }
        
        if hours < 24 {
            if hours == 1 {
                return NSLocalizedString(describe("1 hour"), comment: "Show the relative time from a date")
            } else {
                let relativeTime = NSLocalizedString(describe("%.f hours"), comment: "Show the relative time from a date")
                return String(format: relativeTime, hours)
            }
        }
        
        if days < 7 {
            if days == 1 {
                return NSLocalizedString(describe("1 day"), comment: "Show the relative time from a date")
            } else {
                let relativeTime = NSLocalizedString(describe("%.f days"), comment: "Show the relative time from a date")
                return String(format: relativeTime, days)
            }
        }
        
        return self.toString()
    }
    
    /**
     A string representation of the weekday.
     */
    public func weekdayToString() -> String {
        let formatter = Date.formatter()
        return formatter.weekdaySymbols[self.weekday()-1] as String
    }
    
    /**
     A short string representation of the weekday.
     */
    public func shortWeekdayToString() -> String {
        let formatter = Date.formatter()
        return formatter.shortWeekdaySymbols[self.weekday()-1] as String
    }
    
    /**
     A very short string representation of the weekday.
     
     - Returns String
     */
    public func veryShortWeekdayToString() -> String {
        let formatter = Date.formatter()
        return formatter.veryShortWeekdaySymbols[self.weekday()-1] as String
    }
    
    /**
     A string representation of the month.
     
     - Returns String
     */
    public func monthToString() -> String {
        let formatter = Date.formatter()
        return formatter.monthSymbols[self.month()-1] as String
    }
    
    /**
     A short string representation of the month.
     
     - Returns String
     */
    public func shortMonthToString() -> String {
        let formatter = Date.formatter()
        return formatter.shortMonthSymbols[self.month()-1] as String
    }
    
    /**
     A very short string representation of the month.
     
     - Returns String
     */
    public func veryShortMonthToString() -> String {
        let formatter = Date.formatter()
        return formatter.veryShortMonthSymbols[self.month()-1] as String
    }
    
    
    private static let _sharedDateFormatters: [String: DateFormatter] = [:]
    
    // MARK: Static Cached Formatters
    
    /**
     Returns a cached static array of NSDateFormatters so that thy are only created once.
     */
    fileprivate static func sharedDateFormatters() -> [String: DateFormatter] {
        return _sharedDateFormatters
    }
    
    /**
     Returns a cached formatter based on the format, timeZone and locale. Formatters are cached in a singleton array using hashkeys generated by format, timeZone and locale.
     
     - Parameter format: The format to use.
     - Parameter timeZone: The time zone to use, defaults to the local time zone.
     - Parameter locale: The locale to use, defaults to the current locale
     - Returns The date formatter.
     */
    fileprivate static func formatter(format:String = DefaultFormat, timeZone: TimeZone = TimeZone.autoupdatingCurrent, locale: Locale = Locale.current) -> DateFormatter {
        let hashKey = "\(format.hashValue)\(timeZone.hashValue)\(locale.hashValue)"
        var formatters = Date.sharedDateFormatters()
        if let cachedDateFormatter = formatters[hashKey] {
            return cachedDateFormatter
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.timeZone = timeZone
            formatter.locale = locale
            formatters[hashKey] = formatter
            return formatter
        }
    }
    
    /**
     Returns a cached formatter based on date style, time style and relative date. Formatters are cached in a singleton array using hashkeys generated by date style, time style, relative date, timeZone and locale.
     
     - Parameter dateStyle: The date style to use.
     - Parameter timeStyle: The time style to use.
     - Parameter doesRelativeDateFormatting: Enables relative date formatting.
     - Parameter timeZone: The time zone to use.
     - Parameter locale: The locale to use.
     - Returns The date formatter.
     */
    fileprivate static func formatter(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, doesRelativeDateFormatting: Bool, timeZone: TimeZone = TimeZone.autoupdatingCurrent, locale: Locale = Locale.current) -> DateFormatter {
        var formatters = Date.sharedDateFormatters()
        let hashKey = "\(dateStyle.hashValue)\(timeStyle.hashValue)\(doesRelativeDateFormatting.hashValue)\(timeZone.hashValue)\(locale.hashValue)"
        if let cachedDateFormatter = formatters[hashKey] {
            return cachedDateFormatter
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = dateStyle
            formatter.timeStyle = timeStyle
            formatter.doesRelativeDateFormatting = doesRelativeDateFormatting
            formatter.timeZone = timeZone
            formatter.locale = locale
            formatters[hashKey] = formatter
            return formatter
        }
    }
    
    
    
}

// Added by tnthuyen
// When merging, I found some extra public extensions of other members, I move it here
// Because the public extensions above belongs to an online resource & will be updated along with time
public extension Date {
    
    public init?(yyyymmdd: String) {
        let date = yyyymmddDateFormatter.dateFromStringWithCLSLog(yyyymmdd)
        self.init(timeIntervalSince1970: date.timeIntervalSince1970)
    }
    
    public init?(yyyymmddInt: Int) {
        self.init(yyyymmdd: "\(yyyymmddInt)")
    }

    public func monthsFrom(_ date:Date) -> Int{
        return (Calendar.mf_calendar() as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    
    public func weeksFrom(_ date:Date) -> Int{
        return (Calendar.mf_calendar() as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    
    public func daysFrom(_ date:Date) -> Int{
        return (Calendar.mf_calendar() as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    
    public func isLessThanDate(_ date: Date) -> Bool {
        return self.compare(date) == .orderedAscending
    }
    
    public func isGreaterThanDate(_ date: Date) -> Bool {
        return self.compare(date) == .orderedDescending
    }
    
    public func isEqualDate(_ date: Date) -> Bool {
        return self.compare(date) == .orderedSame
    }
    
    public func weeksAfterDate(_ date: Date) -> Int {
        var count: Int = 0
        var startDate = self
        while !startDate.isSameWeekAsDate(date) {
            count += 1
            startDate = startDate.dateBySubtractingDays(7)
        }
        return count
    }
    
    static public func veryShortWeekDaySymbols() -> [String] {
        return Date.formatter().veryShortWeekdaySymbols
    }

    // Added by tnthuyen
    
    static public func makeWeekRanges(fromDate: Date, toDate: Date) -> [(start: Date, end: Date)] {
        var dateRange: [(start: Date, end: Date)] = []
        
        let fromDate0 = fromDate.dateAtStartOfWeek()
        let toDate0 = toDate.dateAtEndOfWeek()
        
        fromDate0.loopToDate(toDate0, dayStep: 7) { date in
            let startOfWeek = date.dateAtStartOfWeek()
            let endOfWeek = date.dateAtEndOfWeek()
            dateRange.append((start: startOfWeek, end: endOfWeek))
        }
        
        return dateRange
    }
    
    public func isEarlierThanDateIgnoringTime(_ date: Date) -> Bool {
        return self.dateAtStartOfDay().compare(date.dateAtStartOfDay()) == .orderedAscending
    }
    
    public func isLaterThanDateIgnoringTime(_ date: Date) -> Bool {
        return self.dateAtStartOfDay().compare(date.dateAtStartOfDay()) == .orderedDescending
    }
    
    public func isSameDayAsDate(_ date: Date) -> Bool {
        return self.isEqualToDateIgnoringTime(date)
    }
    
    public func isSameMonthAsDate(_ date: Date) -> Bool {
        let comp1 = Date.components(fromDate: self)
        let comp2 = Date.components(fromDate: date)
        
        return comp1!.month == comp2!.month && comp1!.year == comp2!.year
    }
    
    public func isThisMonth() -> Bool {
        return self.isSameMonthAsDate(Date.now)
    }
    
    public func numberOfDaysInMonthAfterMonths(_ months: Int) -> Int {
        var endDateOfMonth = self.dateAtEndOfMonth()
        (0..<months).forEach { index in
            endDateOfMonth = endDateOfMonth.dateByAddingDays(1).dateAtEndOfMonth()
        }
        return endDateOfMonth.monthDays()
    }
    
    public func numberOfDaysInMonthBeforeMonths(_ months: Int) -> Int {
        var startDateOfMonth = self.dateAtStartOfMonth()
        (0..<months).forEach { index in
            startDateOfMonth = startDateOfMonth.dateBySubtractingDays(1).dateAtStartOfMonth()
        }
        return startDateOfMonth.monthDays()
    }
    
    public func startDateOfMonthAfterMonths(_ months: Int) -> Date {
        var endDateOfMonth = self.dateAtEndOfMonth()
        (0..<months).forEach { index in
            endDateOfMonth = endDateOfMonth.dateByAddingDays(1).dateAtEndOfMonth()
        }
        return endDateOfMonth.dateAtStartOfMonth()
    }
    
    public func startDateOfMonthBeforeMonths(_ months: Int) -> Date {
        var startDateOfMonth = self.dateAtStartOfMonth()
        (0..<months).forEach { index in
            startDateOfMonth = startDateOfMonth.dateBySubtractingDays(1).dateAtStartOfMonth()
        }
        return startDateOfMonth
    }
    
    public func toDateString(_ dateFormat: String, usingSystemMFTimeZone: Bool = true) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        if usingSystemMFTimeZone {
            formatter.timeZone = TimeZone.current
        } else {
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
        }
        
        return formatter.string(from: self)
    }
    
    public func dateByAddingYears(_ nYears: Int) -> Date {
        var components = self.components()
        components.year = self.year() + nYears
        return Calendar.mf_calendar().date(from: components)!
    }
    
    public func dateAtEndOfYear() -> Date {
        var components = self.components()
        components.day = 31
        components.month = 12
        return Calendar.mf_calendar().date(from: components)!
    }
    
    public func dateAtStartOfYear() -> Date {
        var components = self.components()
        components.day = 1
        components.month = 1
        return Calendar.mf_calendar().date(from: components)!
    }
    
    static public func fromInterval(_ intervalSince1970: Double, timezoneString: String) -> Date {
        let date = Date(timeIntervalSince1970: intervalSince1970)
        let localTimezone = TimeZone.autoupdatingCurrent
        if timezoneString == localTimezone.identifier {   // The same timezone --> no need to convert
            return date
        }
        
        if let timezone = TimeZone(identifier: timezoneString) {
            return fromInterval(intervalSince1970, timezone: timezone)
        }
        
        return date
    }
    
    static public func fromInterval(_ intervalSince1970: Double, timezone: TimeZone) -> Date {
        return fromInterval(intervalSince1970, timezoneOffset: timezone.secondsFromGMT())
    }
    
    static public func fromInterval(_ intervalSince1970: Double, timezoneOffset: Int) -> Date {
        let date = Date(timeIntervalSince1970: intervalSince1970)
        let localTimezone = TimeZone.autoupdatingCurrent
        if timezoneOffset == localTimezone.secondsFromGMT() {   // The same timezone --> no need to convert
            return date
        }
        
        let diffTimezoneSeconds = Double(timezoneOffset - localTimezone.secondsFromGMT())
        return Date(timeInterval: diffTimezoneSeconds, since: date)
    }

    public func dateAtStartOfMinute() -> Date {
        let intervalOfNearestMinute = (Int(self.timeIntervalSince1970) / 60) * 60
        return Date(timeIntervalSince1970: Double(intervalOfNearestMinute))
    }
    
    public func yyyymmdd() -> String {
        return yyyymmddDateFormatter.string(from: self)
    }
    
    public func yyyymmddInt() -> Int {
        return yyyymmddDateFormatter.intValueFromDateWithCLSLog(self)
    }
    
    public func toString_GMT_US_POSIX() -> String {
        return DateFormatter.serverFullDateFormatter_GMT_US_POSIX().string(from: self)
    }
    
    public func hour12(_ format: String = "h:mm_aaa_") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }

    // MARK: - NSDate iteration
    public func loopToDate(_ toDate: Date, dayStep: Int = 1, closure: (Date) -> ()) {
        var pivotDate = self
        while pivotDate.timeIntervalSince1970 <= toDate.timeIntervalSince1970 {
            closure(pivotDate)
            pivotDate = pivotDate.dateByAddingDays(dayStep)
        }
    }
    
    public func loopToDate(_ toDate: Date, intervalStep: TimeInterval, closure: (Date) -> ()) {
        var pivotDate = self
        while pivotDate.timeIntervalSince1970 <= toDate.timeIntervalSince1970 {
            closure(pivotDate)
            pivotDate = pivotDate.addingTimeInterval(intervalStep)
        }
    }
    
    public func loopWithTimes(_ times: Int, dayStep: Int = 1, closure: (Date) -> ()) {
        var pivotDate = self
        (0..<times).forEach { _ in
            closure(pivotDate)
            pivotDate = pivotDate.dateByAddingDays(dayStep)
        }
    }
    
    public func loopWithTimes(_ times: Int, intervalStep: TimeInterval, closure: (Date) -> ()) {
        var pivotDate = self
        (0..<times).forEach { _ in
            closure(pivotDate)
            pivotDate = pivotDate.addingTimeInterval(intervalStep)
        }
    }
    
    public func loopWithCondition(_ condition: (Date) -> Bool, intervalStep: TimeInterval, closure: (Date) -> ()) {
        var pivotDate = self
        while condition(pivotDate) {
            closure(pivotDate)
            pivotDate = pivotDate.addingTimeInterval(intervalStep)
        }
    }
    
    // Make date range
    public static func makeArray(fromDate: Date, toDate: Date) -> [Date] {
        var dates: [Date] = []
        fromDate.loopToDate(toDate) { dates.append($0) }
        return dates
    }
    
    /**
     Format string using format: dd/MM/yyyy - hh:mm
    */
    public func toStringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy - hh:mm"
        return dateFormatter.string(from: self)
    }
    
    public var nsDate: NSDate {
        return (self as NSDate)
    }
    
    public static var now: Date {
        // NOTE: tnthuyen: This is for the sake of SWIZZLING. To simulate `TIME TRAVEL` for TESTING
        // I intentionally switch to use NSDate() instead of Date() so that we could swizzle the init of NSDate().
        // REASON: We cannot perform swizzling on Date() since it's struct (not class)
        // For now, we should only apply for DEBUG build the app performance or safety may be affected :-?
        // (There must be reasons why Apple recommends using Date)
        #if DEBUG
            return NSDate() as Date
        #else
            return Date()   // TODO: Should we use #if SWIZZLE_DATE_ENABLED?
        #endif
    }
}

public extension NSDate {
    public static var now: NSDate {
        return Date.now as NSDate
    }
}


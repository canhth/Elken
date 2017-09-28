//
//  Month.swift
//  Portfolio
//
//  Created by Thuyen Trinh on 3/12/16.
//  Copyright © 2016 Misfit. All rights reserved.
//

import Foundation

public enum Month {
    case january(startDate: Date)
    case february(startDate: Date)
    case march(startDate: Date)
    case april(startDate: Date)
    case may(startDate: Date)
    case june(startDate: Date)
    case july(startDate: Date)
    case august(startDate: Date)
    case september(startDate: Date)
    case october(startDate: Date)
    case november(startDate: Date)
    case december(startDate: Date)

    public static func monthFromDate(_ date: Date) -> Month {
        switch date.month() {
        case 1:
            return .january(startDate: date.dateAtStartOfMonth())
        case 2:
            return .february(startDate: date.dateAtStartOfMonth())
        case 3:
            return .march(startDate: date.dateAtStartOfMonth())
        case 4:
            return .april(startDate: date.dateAtStartOfMonth())
        case 5:
            return .may(startDate: date.dateAtStartOfMonth())
        case 6:
            return .june(startDate: date.dateAtStartOfMonth())
        case 7:
            return .july(startDate: date.dateAtStartOfMonth())
        case 8:
            return .august(startDate: date.dateAtStartOfMonth())
        case 9:
            return .september(startDate: date.dateAtStartOfMonth())
        case 10:
            return .october(startDate: date.dateAtStartOfMonth())
        case 11:
            return .november(startDate: date.dateAtStartOfMonth())
        case 12:
            return .december(startDate: date.dateAtStartOfMonth())
        case _:
            return .january(startDate: date.dateAtStartOfMonth())
        }
    }
    
    public static func currentMonth() -> Month {
        return Month.monthFromDate(Date.now)
    }
    
    public func nextMonth() -> Month {
        let date = getStartDate()
        let numberOfDays = date.monthDays()
        return Month.monthFromDate(date.dateByAddingDays(numberOfDays + 1))
    }
    
    public func previousMonth() -> Month {
        return Month.monthFromDate(getStartDate().dateBySubtractingDays(1))
    }
    
    public func getStartDate() -> Date {
        switch self {
        case let .january(startDate):
            return startDate
        case let .february(startDate):
            return startDate
        case let .march(startDate):
            return startDate
        case let .april(startDate):
            return startDate
        case let .may(startDate):
            return startDate
        case let .june(startDate):
            return startDate
        case let .july(startDate):
            return startDate
        case let .august(startDate):
            return startDate
        case let .september(startDate):
            return startDate
        case let .october(startDate):
            return startDate
        case let .november(startDate):
            return startDate
        case let .december(startDate):
            return startDate
        }
    }
    
    public func numberOfDays() -> Int {
        return getStartDate().monthDays()
    }
    
    public func getDescriptionWithFormat(_ monthFormat: String) -> String {
        return getStartDate().toDateString(monthFormat)
    }
    
    public func monthByShifting(_ diffMonths: Int) -> Month {
        var currentMonth = self
        (0..<diffMonths).forEach { _ in
            currentMonth = currentMonth.nextMonth()
        }
        return currentMonth
    }
    
    public func isEarlierThanMonth(_ month: Month) -> Bool {
        return self.getStartDate().isEarlierThanDateIgnoringTime(month.getStartDate())
    }
    
    public func isLaterThanMonth(_ month: Month) -> Bool {
        return self.getStartDate().isLaterThanDateIgnoringTime(month.getStartDate())
    }
    
    public func isThisMonth() -> Bool {
        return getStartDate().isThisMonth()
    }
    
    public func isSameMonthAsMonth(_ month: Month) -> Bool {
        return self.getStartDate().isSameMonthAsDate(month.getStartDate())
    }
    
    public func getStartDateAndEndDate() -> (Date, Date) {
        let startDate = getStartDate()
        let endDate = startDate.dateAtEndOfMonth()
        return (startDate, endDate)
    }
    
    public static func monthsFromDate(_ fromDate: Date, toDate: Date) -> [Month] {
        if !fromDate.isEarlierThanDateIgnoringTime(toDate) { return [] }
        
        var months: [Month] = []
        var dateIterate = fromDate
        
        while !dateIterate.isLaterThanDateIgnoringTime(toDate) {
            let month = Month.monthFromDate(dateIterate)
            months.append(month)
            
            dateIterate = month.nextMonth().getStartDate()
        }
        
        return months
    }
}

extension Month: Equatable, Hashable {
    
    public var hashValue: Int {
        get {
            return getStartDate().hashValue
        }
    }
}

public func ==(lhs: Month, rhs: Month) -> Bool {
    return lhs.getStartDate() == rhs.getStartDate()
}

//
//  DateUtils.swift
//  Bankey
//
//  Created by Mpilo Pillz on 2022/11/15.
//

import Foundation

extension Date {
    static var bankeyDateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "MDT")
        return formatter
    }
    
    var monthDayYearString: String {
        let dateFormatter = Date.bankeyDateFormatter
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: self)
    }
}

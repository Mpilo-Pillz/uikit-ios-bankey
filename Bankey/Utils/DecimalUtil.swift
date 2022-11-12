//
//  DecimalUtil.swift
//  Bankey
//
//  Created by Mpilo Pillz on 2022/11/12.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}

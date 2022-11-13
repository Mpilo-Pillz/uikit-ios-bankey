//
//  CurrencyFormatterTests.swift
//  BankeyUnitTests
//
//  Created by Mpilo Pillz on 2022/11/13.
//

import Foundation
import XCTest

@testable import Bankey

class Test: XCTestCase {
    var formatter: CurrencyFormatter!
    
    override func setUp() {
        super.setUp()
        formatter = CurrencyFormatter()
    }
    
    func testBreakDollarsIntoCents() throws {
        let result = formatter.breakIntoDollarsAndCents(30571264.89)
        XCTAssertEqual(result.0, "30,571,264")
        XCTAssertEqual(result.1, "89")
    }
    
    func testDollarsFormatted() throws {
        let result = formatter.dollarsFormatted(30571264.89)
        XCTAssertEqual(result, "$30,571,264.89")
    }
    
    func testZeroDollarsFormatted() throws {
        let result = formatter.dollarsFormatted(0)
        XCTAssertEqual(result, "$0.00")
    }
    
    func testDollarsFormattedWithCurrencySymbol() throws {
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol!
        
        let result = formatter.dollarsFormatted(30571264.89)
        XCTAssertEqual(result, "\(currencySymbol)30,571,264.89")
    }
}

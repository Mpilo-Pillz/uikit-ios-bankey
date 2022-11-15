//
//  ProfileTests.swift
//  BankeyUnitTests
//
//  Created by Mpilo Pillz on 2022/11/15.
//

import Foundation
import XCTest

@testable import Bankey

class ProfileTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testCanParse() throws {
        let json = """
                {
                "id": "1",
                "first_name": "Zakhele",
                "last_name": "Shange",
                }
                """
        
        let data = json.data(using: .utf8)!
        let result = try! JSONDecoder().decode(Profile.self, from: data)
        
        XCTAssertEqual(result.id, "1")
        XCTAssertEqual(result.firstName, "Kevin")
        XCTAssertEqual(result.lastName, "Shange")
    }
}

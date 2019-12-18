//
//  StringUtilTests.swift
//  RaboTestTests
//
//  Created by Adam Lovastyik on 16/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import XCTest

class StringUtilTests: XCTestCase {
    
    // MARK: - Test trimming

    func testTrimLeftSpace() {

        let original = " Test"
        let trimmed = original.trimmed
        
        XCTAssertNotEqual(original, trimmed)
        XCTAssertEqual(trimmed, "Test")
    }
    
    func testTrimLeftNewLine() {

        let original = "\nTest"
        let trimmed = original.trimmed
        
        XCTAssertNotEqual(original, trimmed)
        XCTAssertEqual(trimmed, "Test")
    }
    
    func testTrimRightSpace() {
        
        let original = "Test "
        let trimmed = original.trimmed
        
        XCTAssertNotEqual(original, trimmed)
        XCTAssertEqual(trimmed, "Test")
    }
    
    func testTrimRightNewLine() {

        let original = "Test\n"
        let trimmed = original.trimmed
        
        XCTAssertNotEqual(original, trimmed)
        XCTAssertEqual(trimmed, "Test")
    }
    
    func testTrimmedMultiple() {
        
        let original = " \n    Test\n    \n    \n  "
        let trimmed = original.trimmed
        
        XCTAssertNotEqual(original, trimmed)
        XCTAssertEqual(trimmed, "Test")
    }
    
    func testNotTrimmed() {
        
        let original = "Test"
        let trimmed = original.trimmed
        
        XCTAssertEqual(original, trimmed)
    }
    
    // MARK: - Test NilIfEmpty
    
    func testNilIfEmptyNil() {
        
        let original = "   \n\n  "
        let trimmed = original.nilIfEmpty
        
        XCTAssertNil(trimmed)
    }
    
    func testNilIfEmptyNotNil() {
        
        let original = "   \nTest\n  "
        let trimmed = original.nilIfEmpty
        
        XCTAssertNotNil(trimmed)
        XCTAssertNotEqual(original, trimmed)
        XCTAssertEqual(trimmed, "Test")
    }
    
    func testNilIfEmptySame() {
        
        let original = "Test"
        let trimmed = original.nilIfEmpty
        
        XCTAssertNotNil(trimmed)
        XCTAssertEqual(original, trimmed)
    }
    
    // MARK: - Test quotes removal
    
    func testRemoveLeftQuote() {
        
        let original = "\"Test"
        let trimmed = original.withoutQuotes
        
        XCTAssertNotEqual(original, trimmed)
        XCTAssertEqual(trimmed, "Test")
    }
    
    func testRemoveRightQuote() {
        
        let original = "Test\""
        let trimmed = original.withoutQuotes
        
        XCTAssertNotEqual(original, trimmed)
        XCTAssertEqual(trimmed, "Test")
    }
    
    func testRemoveQuotes() {
        
        let original = "\"Test\""
        let trimmed = original.withoutQuotes
        
        XCTAssertNotEqual(original, trimmed)
        XCTAssertEqual(trimmed, "Test")
    }
    
    func testRemoveQuotesNotQuoted() {
        
        let original = "Test"
        let trimmed = original.withoutQuotes
        
        XCTAssertNotNil(trimmed)
        XCTAssertEqual(original, trimmed)
    }
    
    func testRemoveQuotesEmptyDouble() {
        
        let original = "\"\""
        let trimmed = original.withoutQuotes
        
        XCTAssertNotNil(trimmed)
        XCTAssertNotEqual(original, trimmed)
        XCTAssertEqual(trimmed, "")
    }
    
    func testRemoveQuotesEmptySingle() {
        
        let original = "\""
        let trimmed = original.withoutQuotes
        
        XCTAssertNotNil(trimmed)
        XCTAssertNotEqual(original, trimmed)
        XCTAssertEqual(trimmed, "")
    }
    
    // MARK: - String conversion
    
    func testIntToString() {
        
        let value: Any = 1
        let string = String.from(value: value)
        
        XCTAssertEqual(string, "1")
    }
    
    func testDoubleToString() {
        
        let value: Any = Double(1.234)
        let string = String.from(value: value)
        
        XCTAssertEqual(string, "1.234")
    }
    
    func testBoolTrueToString() {
        
        let value: Any = true
        let string = String.from(value: value)
        
        XCTAssertEqual(string, "True")
    }
    
    func testBoolFalseToString() {
        
        let value: Any = false
        let string = String.from(value: value)
        
        XCTAssertEqual(string, "False")
    }
    
    func testDateWithTimeToString() {
        
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        components.year = 2019
        components.month = 12
        components.day = 18
        components.hour = 19
        components.minute = 5
        components.second = 11
        
        let value: Any = Calendar.current.date(from: components)!
        let string = String.from(value: value)
        
        XCTAssertEqual(string, "Dec 18, 2019 at 7:05 PM")
    }
    
    func testDateWithoutTimeToString() {
        
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        components.year = 2019
        components.month = 12
        components.day = 18
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        let value: Any = Calendar.current.date(from: components)!
        let string = String.from(value: value)
        
        XCTAssertEqual(string, "Dec 18, 2019")
    }
}

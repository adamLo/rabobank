//
//  CSVFileTests.swift
//  RaboTestTests
//
//  Created by Adam Lovastyik on 17/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import XCTest

class CSVFileTests: XCTestCase {

    var csvURL: URL!
    
    override func setUp() {
        
        let path = Bundle.main.path(forResource: "issues", ofType: "csv")
        XCTAssertNotNil(path)
        csvURL = URL(fileURLWithPath: path!)
    }

    func testCreateNotNil() {
        
        XCTAssertNotNil(csvURL)
        
        let file = CSVFile(localFileURL: csvURL)
        XCTAssertNotNil(file)
    }

    func testCreateNil() {
        
        let file = CSVFile(localFileURL: URL(string: "/data/invalid.csv")!)
        XCTAssertNil(file)
    }

    func testLoadActualFile() {
        
        XCTAssertNotNil(csvURL)
        
        let file = CSVFile(localFileURL: csvURL)
        XCTAssertNotNil(file)
        
        let lines = file!.load()
        XCTAssertNotNil(lines)
        XCTAssertEqual(lines.count, 4)
    }
    
    func testProcessReadText() {
        
        XCTAssertNotNil(csvURL)
        
        let file = CSVFile(localFileURL: csvURL)
        XCTAssertNotNil(file)
        
        let text = "111\n222\n333"
        
        let (lines, leftover) = file!.process(text: text)
        
        XCTAssertEqual(lines.count, 2)
        XCTAssertEqual(leftover, "333")
    }
    
    func testProcessLine() {
        
        XCTAssertNotNil(csvURL)
        
        let file = CSVFile(localFileURL: csvURL)
        XCTAssertNotNil(file)
        
        let text = "\"aaa\",bbb, ccc  ,  \"ddd"
        let lines = file!.process(line: text)
        
        XCTAssertEqual(lines.count, 4)
        XCTAssertEqual(lines[0], "aaa")
        XCTAssertEqual(lines[1], "bbb")
        XCTAssertEqual(lines[2], "ccc")
        XCTAssertEqual(lines[3], "ddd")
    }
}

//
//  CSVProcessorTests.swift
//  RaboTestTests
//
//  Created by Adam Lovastyik on 16/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import XCTest

class CSVProcessorTests: XCTestCase {

    var csvURL: URL!
    
    override func setUp() {
        
        let path = Bundle.main.path(forResource: "issues", ofType: "csv")
        XCTAssertNotNil(path)
        csvURL = URL(fileURLWithPath: path!)
    }

    func testProcessorCreateNotNil() {
        
        XCTAssertNotNil(csvURL)
        
        let processor = CSVProcessor(localFileURL: csvURL)
        XCTAssertNotNil(processor)
    }

    func testProcessorCreateNil() {
        
        let processor = CSVProcessor(localFileURL: URL(string: "/data/invalid.csv")!)
        XCTAssertNil(processor)
    }
    
    func testLoadActualFile() {
        
        XCTAssertNotNil(csvURL)
        
        let processor = CSVProcessor(localFileURL: csvURL)
        XCTAssertNotNil(processor)
        
        let (text, error) = processor!.load()
        
        XCTAssertNotNil(text)
        XCTAssertNil(error)
    }
    
    func testLoadEmptyFile() {
        
        let path = Bundle.main.path(forResource: "emptyfile", ofType: "csv")
        XCTAssertNotNil(path)
        
        let url = URL(fileURLWithPath: path!)
        XCTAssertNotNil(url)
        
        let processor = CSVProcessor(localFileURL: url)
        XCTAssertNotNil(processor)
        
        let (text, error) = processor!.load()
        
        XCTAssertNil(text)
        XCTAssertNil(error)
    }
    
    func testProcessValid() {
        
        XCTAssertNotNil(csvURL)
        
        let processor = CSVProcessor(localFileURL: csvURL)
        XCTAssertNotNil(processor)
        
        let (text, loadError) = processor!.load()
        
        XCTAssertNotNil(text)
        XCTAssertNil(loadError)
        
        let (issues, processError) = processor!.process(text: text!, skipFirstLine: true)
        
        XCTAssertNotNil(issues)
        XCTAssertNil(processError)
        XCTAssertEqual(issues?.count ?? 0, 3)
    }
    
    func testProcessEmptyFile() {
        
        let path = Bundle.main.path(forResource: "emptyfile", ofType: "csv")
        XCTAssertNotNil(path)
        
        let url = URL(fileURLWithPath: path!)
        XCTAssertNotNil(url)
        
        let processor = CSVProcessor(localFileURL: url)
        XCTAssertNotNil(processor)
        
        let (issues, processError) = processor!.process(text: "", skipFirstLine: false)
        
        XCTAssertNil(issues)
        XCTAssertNotNil(processError)
        XCTAssertEqual(issues?.count ?? 0, 0)
    }
    
    func testProcessInvalidLineInFile() {
        
        let path = Bundle.main.path(forResource: "invalid2", ofType: "csv")
        XCTAssertNotNil(path)
        
        let url = URL(fileURLWithPath: path!)
        XCTAssertNotNil(url)
        
        let processor = CSVProcessor(localFileURL: url)
        XCTAssertNotNil(processor)
        
        let (text, loadError) = processor!.load()
        
        XCTAssertNotNil(text)
        XCTAssertNil(loadError)
        
        let (issues, processError) = processor!.process(text: text!, skipFirstLine: false)
        
        XCTAssertNil(issues)
        XCTAssertNotNil(processError)
        XCTAssertEqual(issues?.count ?? 0, 0)
    }
    
    func testLoadAndProcessValid() {
        
        XCTAssertNotNil(csvURL)
        
        let processor = CSVProcessor(localFileURL: csvURL)
        XCTAssertNotNil(processor)
        
        var issues: [Issue]?
        var text: String?
        var error: Error?
        
        let expectation = self.expectation(description: "LoadAndProcessValid")
        
        processor?.loadAndProcess(completion: { (_text, _issues, _error) in
            text = _text
            issues = _issues
            error = _error
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertNil(text)
        XCTAssertNotNil(issues)
        XCTAssertEqual(issues?.count ?? 0, 3)
        XCTAssertNil(error)
    }
    
    func testLoadAndProcessEmptyFile() {
        
        XCTAssertNotNil(csvURL)
        
        let path = Bundle.main.path(forResource: "emptyfile", ofType: "csv")
        XCTAssertNotNil(path)
        
        let url = URL(fileURLWithPath: path!)
        XCTAssertNotNil(url)
        
        let processor = CSVProcessor(localFileURL: url)
        XCTAssertNotNil(processor)
        
        var issues: [Issue]?
        var text: String?
        var error: Error?
        
        let expectation = self.expectation(description: "LoadAndProcessValid1")
        
        processor?.loadAndProcess(completion: { (_text, _issues, _error) in
            text = _text
            issues = _issues
            error = _error
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertNil(text)
        XCTAssertNil(issues)
        XCTAssertNotNil(error)
    }
    
    func testLoadAndProcessInvalidFile1() {
        
        XCTAssertNotNil(csvURL)
        
        let path = Bundle.main.path(forResource: "invalid1", ofType: "csv")
        XCTAssertNotNil(path)
        
        let url = URL(fileURLWithPath: path!)
        XCTAssertNotNil(url)
        
        let processor = CSVProcessor(localFileURL: url)
        XCTAssertNotNil(processor)
        
        var issues: [Issue]?
        var text: String?
        var error: Error?
        
        let expectation = self.expectation(description: "LoadAndProcessValid1")
        
        processor?.loadAndProcess(completion: { (_text, _issues, _error) in
            text = _text
            issues = _issues
            error = _error
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertNotNil(text)
        XCTAssertNil(issues)
        XCTAssertNotNil(error)
    }
    
    func testLoadAndProcessInvalidFile2() {
        
        XCTAssertNotNil(csvURL)
        
        let path = Bundle.main.path(forResource: "invalid2", ofType: "csv")
        XCTAssertNotNil(path)
        
        let url = URL(fileURLWithPath: path!)
        XCTAssertNotNil(url)
        
        let processor = CSVProcessor(localFileURL: url)
        XCTAssertNotNil(processor)
        
        var issues: [Issue]?
        var text: String?
        var error: Error?
        
        let expectation = self.expectation(description: "LoadAndProcessValid2")
        
        processor?.loadAndProcess(completion: { (_text, _issues, _error) in
            text = _text
            issues = _issues
            error = _error
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertNotNil(text)
        XCTAssertNil(issues)
        XCTAssertNotNil(error)
    }
}

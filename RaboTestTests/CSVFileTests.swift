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
        
        var lineReadCount = 0
        var errors: [Error]?
        var text: String?
        var lastIndex = -1
        
        let expectation = self.expectation(description: "LoadActualFile")
        
        file?.load(lineRead: { (index, line) in
            lineReadCount += 1
            lastIndex = index ?? 0
        }, completion: { (_text, _errors) in
            errors = _errors
            text = _text
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertNotNil(file?.lines)
        XCTAssertEqual(file?.lines.count, 3)
        XCTAssertEqual(lastIndex, 2)
        XCTAssertNil(errors)
        XCTAssertNotNil(text)
    }
    
    func testProcessTextFinal() {
        
        XCTAssertNotNil(csvURL)
        
        let file = CSVFile(localFileURL: csvURL)
        XCTAssertNotNil(file)
        
        let text = "111\n222\n333"
        
        let (lines, leftover) = file!.process(text: text, final: true)
        
        XCTAssertEqual(lines.count, 3)
        XCTAssertEqual(leftover, "")
    }
    
    func testProcessTextLeftover() {
        
        XCTAssertNotNil(csvURL)
        
        let file = CSVFile(localFileURL: csvURL)
        XCTAssertNotNil(file)
        
        let text = "111\n222\n333"
        
        let (lines, leftover) = file!.process(text: text, final: false)
        
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
    
    func testValueConversionInt() {
        
        XCTAssertNotNil(csvURL)
        
        let file = CSVFile(localFileURL: csvURL)
        XCTAssertNotNil(file)
        
        let string = "1"
        let value = file!.value(of: string)
        
        XCTAssertEqual(value as? Int, 1)
        XCTAssertNil(value as? Double)
        XCTAssertNil(value as? Bool)
        XCTAssertNil(value as? Date)
        XCTAssertNil(value as? String)
    }
    
    func testValueConversionDouble() {
        
        XCTAssertNotNil(csvURL)
        
        let file = CSVFile(localFileURL: csvURL)
        XCTAssertNotNil(file)
        
        let string = "1.234"
        let value = file!.value(of: string)
        XCTAssertEqual(value as? Double, 1.234)
        XCTAssertNil(value as? Int)
        XCTAssertNil(value as? Bool)
        XCTAssertNil(value as? Date)
        XCTAssertNil(value as? String)
    }
    
    func testValueConversionBoolTrue() {
        
        XCTAssertNotNil(csvURL)
        
        let file = CSVFile(localFileURL: csvURL)
        XCTAssertNotNil(file)
        
        let string = "true"
        let value = file!.value(of: string)
        XCTAssertEqual(value as? Bool, true)
        XCTAssertNil(value as? Double)
        XCTAssertNil(value as? Int)
        XCTAssertNil(value as? Date)
        XCTAssertNil(value as? String)
    }
    
    func testValueConversionBoolFalse() {
        
        XCTAssertNotNil(csvURL)
        
        let file = CSVFile(localFileURL: csvURL)
        XCTAssertNotNil(file)
        
        let string = "false"
        let value = file!.value(of: string)
        XCTAssertEqual(value as? Bool, false)
        XCTAssertNil(value as? Double)
        XCTAssertNil(value as? Int)
        XCTAssertNil(value as? Date)
        XCTAssertNil(value as? String)
    }
    
    func testValueConversionDate() {
        
        XCTAssertNotNil(csvURL)
        
        let file = CSVFile(localFileURL: csvURL)
        XCTAssertNotNil(file)
        
        let string = "1978-01-02T00:00:00"
        let value = file!.value(of: string)
        XCTAssertNotNil(value as? Date)
        XCTAssertNil(value as? Double)
        XCTAssertNil(value as? Bool)
        XCTAssertNil(value as? Int)
        XCTAssertNil(value as? String)
    }
    
    func testValueConversionString() {
        
        XCTAssertNotNil(csvURL)
        
        let file = CSVFile(localFileURL: csvURL)
        XCTAssertNotNil(file)
        
        let string = "string"
        let value = file!.value(of: string)
        XCTAssertNotNil(value as? String)
        XCTAssertNil(value as? Double)
        XCTAssertNil(value as? Bool)
        XCTAssertNil(value as? Date)
        XCTAssertNil(value as? Int)
    }
    
    func testProcessStrings() {
        
        XCTAssertNotNil(csvURL)
        
        let file = CSVFile(localFileURL: csvURL)
        XCTAssertNotNil(file)
        
        let strings = ["Theo","Jansen","5","1978-01-02T00:00:00"]
        let fieldNames = ["First name","Sur name","Issue count","Date of birth"]
        let values = file!.process(strings: strings, fieldNames: fieldNames)
        
        XCTAssertEqual(values.count, 4)
        XCTAssertEqual(values["First name"] as? String, "Theo")
        XCTAssertEqual(values["Sur name"] as? String, "Jansen")
        XCTAssertEqual(values["Issue count"] as? Int, 5)
        XCTAssertNotNil(values["Date of birth"] as? Date)
    }
    
    func testProcessTextRead() {
                
        XCTAssertNotNil(csvURL)
        
        let file = CSVFile(localFileURL: csvURL)
        XCTAssertNotNil(file)
        
        let leftover = "\"First name\",\"Sur name\",\"Issue count\","
        let textRead = "\"Date of birth\"\n\"Theo\",\"Jansen\",5,\"1978-01-02T00:00:00\"\n\"Fiona\""
        var lineIndex = 0
        var lastIndex = -1
        
        let expectation = self.expectation(description: "ProcessTextRead")
        var values: [String: Any]?
        
        let processedLeftover = file!.process(textRead: textRead, leftOver: leftover, final: false, lineIndex: &lineIndex) { (index, _values) in
            values = _values
            lastIndex = index ?? -1
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
        
        XCTAssertNotNil(values)
        XCTAssertEqual(values?.count, 4)
        XCTAssertEqual(values?["First name"] as? String, "Theo")
        XCTAssertEqual(values?["Sur name"] as? String, "Jansen")
        XCTAssertEqual(values?["Issue count"] as? Int, 5)
        XCTAssertNotNil(values?["Date of birth"] as? Date)
        XCTAssertEqual(processedLeftover, "\"Fiona\"")
        XCTAssertEqual(lineIndex, 2)
        XCTAssertEqual(lastIndex, 0)
        XCTAssertEqual(file?.fieldNames.count, 4)
        XCTAssertEqual(file?.fieldNames[0], "First name")
        XCTAssertEqual(file?.fieldNames[1], "Sur name")
        XCTAssertEqual(file?.fieldNames[2], "Issue count")
        XCTAssertEqual(file?.fieldNames[3], "Date of birth")
    }
    
    // MARK: - Measure load time
    
    func testLoad3Lines() {
        
        XCTAssertNotNil(csvURL)
        
        let file = CSVFile(localFileURL: csvURL)
        XCTAssertNotNil(file)
        
        self.measure {
            
            let expectation = self.expectation(description: "Load3Lines")
            
            file?.load(lineRead: { (index, line) in
            }, completion: { (_text, _errors) in
                expectation.fulfill()
            })
            
            waitForExpectations(timeout: 1, handler: nil)
        }
    }
    
    func testLoad2000Lines() {

        let path = Bundle.main.path(forResource: "2000lines", ofType: "csv")
        XCTAssertNotNil(path)
        let file = CSVFile(localFileURL: URL(fileURLWithPath: path!))
        XCTAssertNotNil(file)
        
        self.measure {
            
            let expectation = self.expectation(description: "Load2000Lines")
            
            file?.load(lineRead: { (index, line) in
            }, completion: { (_text, _errors) in
                expectation.fulfill()
            })
            
            waitForExpectations(timeout: 60, handler: nil)
        }
    }
    
    func testLoad10000Lines() {

        let path = Bundle.main.path(forResource: "10000lines", ofType: "csv")
        XCTAssertNotNil(path)
        let file = CSVFile(localFileURL: URL(fileURLWithPath: path!))
        XCTAssertNotNil(file)
        
        self.measure {
            
            let expectation = self.expectation(description: "Load10000Lines")
            
            file?.load(lineRead: { (index, line) in
            }, completion: { (_text, _errors) in
                expectation.fulfill()
            })
            
            waitForExpectations(timeout: 60, handler: nil)
        }
    }
}

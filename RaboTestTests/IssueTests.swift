//
//  IssueTests.swift
//  RaboTestTests
//
//  Created by Adam Lovastyik on 16/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import XCTest

class IssueTests: XCTestCase {

    func testCreateNotNil() {
        
        let text = "\"Petra\",\"Boersma\",1,\"2001-04-20T00:00:00\""
        let issue = Issue(text: text)
        
        XCTAssertNotNil(issue)
    }
    
    func testTooFewFields() {
        
        let text = ""
        let issue = Issue(text: text)
        
        XCTAssertNil(issue)
    }
    
    func testTooManyFields() {
        
        let text = "\"Petra\",\"Boersma\",1,\"2001-04-20T00:00:00\",Unneeded data"
        let issue = Issue(text: text)
        
        XCTAssertNotNil(issue)
    }

    func testValidData() {
        
        let text = "\"Petra\",\"Boersma\",1,\"2001-04-20T00:00:00\""
        let issue = Issue(text: text)
        
        XCTAssertNotNil(issue)
        
        XCTAssertNotNil(issue?.firstName)
        XCTAssertEqual(issue?.firstName, "Petra")
        
        XCTAssertNotNil(issue?.surName)
        XCTAssertEqual(issue?.surName, "Boersma")
        
        XCTAssertEqual(issue?.issueCount, 1)
        
        XCTAssertNotNil(issue?.birthDate)
        
        if let _date = issue?.birthDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let dateString = formatter.string(from: _date)
            XCTAssertEqual(dateString, "2001-04-20T00:00:00")
        }
    }
    
    func testValidWithoutQuotes() {
        
        let text = "Petra,Boersma,1,2001-04-20T00:00:00"
        let issue = Issue(text: text)
        
        XCTAssertNotNil(issue)
        
        XCTAssertNotNil(issue?.firstName)
        XCTAssertEqual(issue?.firstName, "Petra")
        
        XCTAssertNotNil(issue?.surName)
        XCTAssertEqual(issue?.surName, "Boersma")
        
        XCTAssertEqual(issue?.issueCount, 1)
        
        XCTAssertNotNil(issue?.birthDate)
        
        if let _date = issue?.birthDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let dateString = formatter.string(from: _date)
            XCTAssertEqual(dateString, "2001-04-20T00:00:00")
        }
    }
    
    func testValidTrimmed() {
        
        let text = " \"Petra\"  ,\n\"Boersma\",1,2001-04-20T00:00:00"
        let issue = Issue(text: text)
        
        XCTAssertNotNil(issue)
        
        XCTAssertNotNil(issue?.firstName)
        XCTAssertEqual(issue?.firstName, "Petra")
        
        XCTAssertNotNil(issue?.surName)
        XCTAssertEqual(issue?.surName, "Boersma")
        
        XCTAssertEqual(issue?.issueCount, 1)
        
        XCTAssertNotNil(issue?.birthDate)
        
        if let _date = issue?.birthDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let dateString = formatter.string(from: _date)
            XCTAssertEqual(dateString, "2001-04-20T00:00:00")
        }
    }
}

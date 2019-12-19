//
//  MainViewControllerUITests.swift
//  RaboTestUITests
//
//  Created by Adam Lovastyik on 16/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import XCTest

class MainViewControllerUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTabBars() {
                
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.tabBars["tabbar.main"].exists)
        
        XCTAssertTrue(app.tabBars.buttons["csv.tab.main"].exists)
        XCTAssertTrue(app.tabBars.buttons["txt.tab.main"].exists)
        XCTAssertTrue(app.tabBars.buttons["errors.tab.main"].exists)
        
        XCTAssertTrue(app.navigationBars["navbar.main"].exists)
    }
    
    func testListSelectedOnLaunch() {
                
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.tables["table.csv"].exists)
        XCTAssertFalse(app.textViews["text.txt"].exists)
        XCTAssertFalse(app.tables["table.errors"].exists)
    }
    
    func testTxtTabSelected() {
        
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.tabBars.buttons["txt.tab.main"].exists)
        
        app.tabBars.buttons["txt.tab.main"].tap()
        
        XCTAssertFalse(app.tables["table.csv"].exists)
        XCTAssertTrue(app.textViews["text.txt"].exists)
        XCTAssertFalse(app.tables["table.errors"].exists)
    }
    
    func testErrorsTabSelected() {
        
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.tabBars.buttons["errors.tab.main"].exists)
        
        app.tabBars.buttons["errors.tab.main"].tap()
        
        XCTAssertFalse(app.tables["table.csv"].exists)
        XCTAssertFalse(app.textViews["text.txt"].exists)
        XCTAssertTrue(app.tables["table.errors"].exists)
    }
    
    func testTxtTabThenCsvTabSelected() {
        
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.tabBars.buttons["txt.tab.main"].exists)
        
        app.tabBars.buttons["txt.tab.main"].tap()
        
        XCTAssertFalse(app.tables["table.csv"].exists)
        XCTAssertTrue(app.textViews["text.txt"].exists)
        XCTAssertFalse(app.tables["table.errors"].exists)
        
        XCTAssertTrue(app.tabBars.buttons["csv.tab.main"].exists)
        
        app.tabBars.buttons["csv.tab.main"].tap()
        
        XCTAssertTrue(app.tables["table.csv"].exists)
        XCTAssertFalse(app.textViews["text.txt"].exists)
        XCTAssertFalse(app.tables["table.errors"].exists)
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}

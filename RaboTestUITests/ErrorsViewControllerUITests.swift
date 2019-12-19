//
//  ErrorsViewControllerUITests.swift
//  RaboTestUITests
//
//  Created by Adam Lovastyik on 19/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import XCTest

class ErrorsViewControllerUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPlaceholder() {
     
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.tabBars.buttons["errors.tab.main"].exists)
        
        app.tabBars.buttons["errors.tab.main"].tap()
        
        XCTAssertTrue(app.tables["table.errors"].exists)
        XCTAssertTrue(app.staticTexts["empty_placeholder.table.errors"].exists)
        XCTAssertEqual(app.staticTexts["empty_placeholder.table.errors"].label, NSLocalizedString("No errors", comment: "Placeholder when no errors occured during reading"))
    }

    func testTableViewEmpty() {
        
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.tabBars.buttons["errors.tab.main"].exists)
        
        app.tabBars.buttons["errors.tab.main"].tap()
        
        XCTAssertTrue(app.tables["table.errors"].exists)
        XCTAssertFalse(app.cells["cell.table.errors"].exists)
        XCTAssertFalse(app.staticTexts["message.cell.table.errors"].exists)
    }
    
    func testLoadFileError() {
        
        let app = XCUIApplication()
        app.launchArguments = ["FILE_TO_READ:badfile"]
        app.launch()
        
        XCTAssertTrue(app.tabBars.buttons["errors.tab.main"].exists)
        
        app.tabBars.buttons["errors.tab.main"].tap()
        
        XCTAssertTrue(app.tables["table.errors"].exists)
        XCTAssertFalse(app.staticTexts["empty_placeholder.table.errors"].exists)
        XCTAssertTrue(app.cells["cell.table.errors"].exists)
        XCTAssertTrue(app.staticTexts["message.cell.table.errors"].exists)
    }
}

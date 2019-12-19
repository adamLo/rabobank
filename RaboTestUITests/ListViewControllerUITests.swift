//
//  ListViewControllerUITests.swift
//  RaboTestUITests
//
//  Created by Adam Lovastyik on 19/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import XCTest

class ListViewControllerUITests: XCTestCase {

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

    func testTableView() {
        
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.tables["table.csv"].exists)
        XCTAssertTrue(app.cells["line.table.csv"].exists)
        XCTAssertTrue(app.staticTexts["title.line.table.csv"].exists)
        XCTAssertTrue(app.staticTexts["value.line.table.csv"].exists)
    }

}

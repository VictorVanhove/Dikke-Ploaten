//
//  SearchScreenTests.swift
//  Dikke PloatenUITests
//
//  Created by Victor Vanhove on 19/04/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import XCTest

class SearchScreenTests: XCTestCase {

	var app: XCUIApplication!
	
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
		app = XCUIApplication()
		app.launchArguments = ["userLoggedIn"]
		app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
		
    }
	
	func testCanFilterOnAlbumName() {
		app.tabBars.buttons["Search"].doubleTap()
		app.navigationBars.element.searchFields["Search"].tap()
		app.searchFields.element.typeText("Heroes")
		
		XCTAssertTrue(app.tables.cells.count == 1)
	}
	
	func testCanFilterOnAlbumArtist() {
		app.tabBars.buttons["Search"].doubleTap()
		app.navigationBars.element.searchFields["Search"].tap()
		app.searchFields.element.typeText("David Bowie")
		
		XCTAssertTrue(app.tables.cells.count == 1)
	}

}

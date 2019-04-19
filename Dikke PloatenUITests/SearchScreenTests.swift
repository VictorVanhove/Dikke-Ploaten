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

    func testCanAddAlbumToCollection() {
		app.tabBars.buttons["Search"].tap()
		app.tabBars.buttons["Collection"].tap()
		app.tabBars.buttons["Search"].tap()
		
		app.tables.cells.element(boundBy: 0).swipeLeft()
		app.tables.cells.element(boundBy: 0).buttons["☰ Add"].tap()

		XCTAssertTrue(app.alerts.element.staticTexts["'Pet Sounds' by The Beach Boys is added to your collection"].exists)
		
		app.tabBars.buttons["Collection"].tap()
		app.tables.cells.element(boundBy: 0).swipeLeft()
		app.tables.cells.element(boundBy: 0).buttons["⌫ Remove"].tap()
    }
	
	func testCanAddAlbumToWantlist() {
		app.tabBars.buttons["Search"].tap()
		app.tabBars.buttons["Wantlist"].tap()
		app.tabBars.buttons["Search"].tap()
		
		app.tables.cells.element(boundBy: 1).swipeLeft()
		app.tables.cells.element(boundBy: 1).buttons["♥ Want"].tap()
		
		XCTAssertTrue(app.alerts.element.staticTexts["'1999' by Prince is added to your wantlist"].exists)
		
		app.tabBars.buttons["Wantlist"].tap()
		app.tables.cells.element(boundBy: 0).swipeLeft()
		app.tables.cells.element(boundBy: 0).buttons["⌫ Remove"].tap()
	}

}

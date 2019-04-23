//
//  ProfileScreenTests.swift
//  Dikke PloatenUITests
//
//  Created by Victor Vanhove on 23/04/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import XCTest

class ProfileScreenTests: XCTestCase {
	
	var app: XCUIApplication!
	
	let exists = NSPredicate(format: "exists == true")
	
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

    func testCanAddProfilePhoto() {
		app.tabBars.buttons["Profile"].doubleTap()
		app.navigationBars["Profile"].buttons["Settings"].tap()
		app.tables.cells.element(boundBy: 0).tap()
		sleep(3)
		let moments = app.tables.cells.element(boundBy: 0)
		moments.tap()
		
		XCTAssertTrue(app.collectionViews.element.exists)
		
		let selectedPhoto = app.collectionViews.element(boundBy: 0).cells.element(boundBy: 0)
		sleep(3)
		selectedPhoto.tap()
		selectedPhoto.tap()
    }
	
	func testCanAddCoverPhoto() {
		app.tabBars.buttons["Profile"].doubleTap()
		app.navigationBars["Profile"].buttons["Settings"].tap()
		app.tables.cells.element(boundBy: 1).tap()
		sleep(3)
		let moments = app.tables.cells.element(boundBy: 0)
		moments.tap()
		
		XCTAssertTrue(app.collectionViews.element.exists)
		
		let selectedPhoto = app.collectionViews.element(boundBy: 0).cells.element(boundBy: 2)
		sleep(3)
		selectedPhoto.tap()
	}
	
	func testCanChangeUsername() {
		app.tabBars.buttons["Profile"].doubleTap()
		app.navigationBars["Profile"].buttons["Settings"].tap()
		app.tables.cells.element(boundBy: 2).tap()
		
		XCTAssertTrue(app.alerts.element.staticTexts["Fill in your new username:"].exists)
		
		app.textFields["Username"].tap()
		app.textFields["Username"].typeText("Viktor")
		app.alerts["Change name"].buttons["OK"].tap()
	}

	func testCanChangePassword() {
		app.tabBars.buttons["Profile"].doubleTap()
		app.navigationBars["Profile"].buttons["Settings"].tap()
		app.tables.cells.element(boundBy: 3).tap()
		
		XCTAssertTrue(app.alerts.element.staticTexts["Fill in your new password:"].exists)
		
		app.secureTextFields["New password"].tap()
		app.secureTextFields["New password"].typeText("vvvvvv")
		app.secureTextFields["Confirm new password"].tap()
		app.secureTextFields["Confirm new password"].typeText("vvvvvv")
		app.alerts["Change password"].buttons["OK"].tap()
	}
	
	func testCanLogOut() {
		app.tabBars.buttons["Profile"].doubleTap()
		app.navigationBars["Profile"].buttons["Settings"].tap()
		app.tables.cells.element(boundBy: 6).tap()

		expectation(for: exists, evaluatedWith: app.navigationBars["Dikke_Ploaten.LoginView"], handler: nil)
		waitForExpectations(timeout: 5, handler: nil)

		XCTAssertTrue(app.navigationBars["Dikke_Ploaten.LoginView"].exists)
	}
	
}

//
//  LoginScreenTests.swift
//  Dikke PloatenUITests
//
//  Created by Victor Vanhove on 18/04/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import XCTest

class LoginScreenTests: XCTestCase {
	
	var app: XCUIApplication!
	
	let exists = NSPredicate(format: "exists == true")
	
	override func setUp() {
		// Put setup code here. This method is called before the invocation of each test method in the class.
		
		// In UI tests it is usually best to stop immediately when a failure occurs.
		continueAfterFailure = false
		
		// UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
		app = XCUIApplication()
		app.launchArguments = ["userNotLoggedIn"]
		app.launch()
		
		// In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testCannotLoginWithoutEmailAndPassword() {
		app.buttons["Log In"].tap()
		sleep(1)
		XCTAssertTrue(app.alerts.element.staticTexts["Please make sure all required fields are filled out correctly."].exists)
	}
	
	func testCannotLoginWithInvalidEmail() {
		app.textFields["Email"].tap()
		app.textFields["Email"].typeText("victor")
		
		app.buttons["Next:"].tap()
		app.secureTextFields["Password"].typeText("vvvvvv")
		
		app.buttons["Go"].tap()
		app.alerts["Whoops"].buttons["OK"].tap()
		
		app.textFields["Email"].tap()
		app.textFields["Email"].typeText("@bazookas")

		app.buttons["Next:"].tap()
		app.buttons["Go"].tap()
		
		XCTAssertTrue(app.alerts.element.staticTexts["The email address is badly formatted."].exists)
	}
	
	func testCannotLoginWithInvalidPassword() {
		app.textFields["Email"].tap()
		app.textFields["Email"].typeText("victor@bazookas.be")
		
		app.buttons["Next:"].tap()
		app.secureTextFields["Password"].typeText("cccccc")
		
		app.buttons["Go"].tap()
		
		XCTAssertTrue(app.alerts.element.staticTexts["The password does not match with your email."].exists)
	}
	
	func testCanLoginWithValidInformation() {
		app.textFields["Email"].tap()
		app.textFields["Email"].typeText("victor@bazookas.be")
		
		app.buttons["Next:"].tap()
		app.secureTextFields["Password"].typeText("vvvvvv")
		
		app.buttons["Go"].tap()
		
		expectation(for: exists, evaluatedWith: app.navigationBars["Collection"], handler: nil)
		waitForExpectations(timeout: 5, handler: nil)

		XCTAssertTrue(app.navigationBars["Collection"].exists)
	}
}

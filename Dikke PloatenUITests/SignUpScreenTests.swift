//
//  SignUpScreenTests.swift
//  Dikke PloatenUITests
//
//  Created by Victor Vanhove on 19/04/2019.
//  Copyright © 2019 bazookas. All rights reserved.
//

import XCTest

class SignUpScreenTests: XCTestCase {
	
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
	
	func testCannotSignUpWithoutNameEmailAndPassword() {
		app.buttons["Not a member yet? Sign Up"].tap()
		sleep(1)
		app.buttons["Sign Up"].tap()
		
		XCTAssertTrue(app.alerts.element.staticTexts["Please make sure all required fields are filled out correctly."].exists)
	}
	
	func testCannotSignUpWithInvalidEmail() {
		app.buttons["Not a member yet? Sign Up"].tap()
		sleep(1)
		app.textFields["Username"].tap()
		app.textFields["Username"].typeText("Victor")
		
		app.buttons["Next:"].tap()
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
	
	func testCannotSignUpWithInvalidPassword() {
		app.buttons["Not a member yet? Sign Up"].tap()
		sleep(1)
		app.textFields["Username"].tap()
		app.textFields["Username"].typeText("Victor")
		
		app.buttons["Next:"].tap()
		app.textFields["Email"].typeText("victor@bazookas.be")
		
		app.buttons["Next:"].tap()
		app.secureTextFields["Password"].typeText("cccc")
		
		app.buttons["Go"].tap()
		
		XCTAssertTrue(app.alerts.element.staticTexts["The password must be 6 characters long or more."].exists)
	}
	
	func testCannotSignUpIfEmailAlreadyInUse() {
		app.buttons["Not a member yet? Sign Up"].tap()
		sleep(1)
		app.textFields["Username"].tap()
		app.textFields["Username"].typeText("Victor")
		
		app.buttons["Next:"].tap()
		app.textFields["Email"].typeText("victor@bazookas.be")
		
		app.buttons["Next:"].tap()
		app.secureTextFields["Password"].typeText("vvvvvv")
		
		app.buttons["Go"].tap()
		sleep(1)
		
		XCTAssertTrue(app.alerts.element.staticTexts["The email address is already in use by another account."].exists)
	}
	
	func testCanSignUpWithValidInformation() {
		app.buttons["Not a member yet? Sign Up"].tap()
		sleep(1)
		app.textFields["Username"].tap()
		app.textFields["Username"].typeText("Victor")
		
		app.buttons["Next:"].tap()
		// Need to change email everytime in order to create new user
		app.textFields["Email"].typeText("victor235@bazookas.be")
		
		app.buttons["Next:"].tap()
		app.secureTextFields["Password"].typeText("vvvvvv")
		
		app.buttons["Go"].tap()
		
		expectation(for: exists, evaluatedWith: app.navigationBars["Collection"], handler: nil)
		waitForExpectations(timeout: 5, handler: nil)
		
		XCTAssertTrue(app.navigationBars["Collection"].exists)
	}
}

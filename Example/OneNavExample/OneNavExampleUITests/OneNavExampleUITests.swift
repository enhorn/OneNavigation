//
//  OneNavExampleUITests.swift
//  OneNavExampleUITests
//
//  Created by Robin Enhorn on 2025-03-26.
//

import XCTest

let app = XCUIApplication()

final class OneNavExampleUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    @MainActor
    func testPresentations() throws {
        tapButton(title: "Error")
        waitForText("Hello")
        tapButton(title: "OK")

        tapButton(title: "Present modal")
        tapButton(title: "Dismiss")

        tapButton(title: "Present modal")

        tapButton(title: "Push")
        tapButton(title: "Pop")

        tapButton(title: "Push")
        tapButton(title: "Show error banner")
        waitForText("Error banner")

        tapButton(title: "Dismiss from pushed")
        waitForButton(title: "Present modal")
    }
}

extension XCTestCase {

    func tapButton(title: String) {
        waitForButton(title: title)
        app.buttons[title].tap()
    }

    func waitForButton(title: String) {
        XCTAssertTrue(app.buttons[title].waitForExistence(timeout: 5))
    }

    func waitForText(_ text: String) {
        XCTAssertTrue(app.staticTexts[text].waitForExistence(timeout: 5))
    }

}

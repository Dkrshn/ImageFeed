//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Даниил Крашенинников on 07.04.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 20))
        
        loginTextField.tap()
        loginTextField.typeText("dan2408@yandex.ru")
        
        XCUIApplication().toolbars.buttons["Done"].tap()
        
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 7))
        
        passwordTextField.tap()
        passwordTextField.typeText("48Dan240811@@@")
        webView.swipeUp()
        
        print(app.debugDescription)
        
        let webViewsQuery = app.webViews
        
        webViewsQuery.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 15))
        
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        cell.swipeUp()
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        cellToLike.buttons["likeButton"].tap()
        cellToLike.buttons["likeButton"].tap()
        cellToLike.waitForExistence(timeout: 5)
        
        cellToLike.tap()
        
        cellToLike.waitForExistence(timeout: 5)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        app.buttons["backButton"].tap()
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Daniil Krasheninnikov"].exists)
        XCTAssertTrue(app.staticTexts["@dan2408"].exists)
        
        app.buttons["logoutButton"].tap()
        sleep(1)
        
        app.alerts["exit"].scrollViews.otherElements.buttons["Да"].tap()
    }
    
}

//
//  Pazarama_MovieAppUITests.swift
//  Pazarama-MovieAppUITests
//
//  Created by Kaan Yıldırım on 4.11.2023.
//

import XCTest

final class Pazarama_MovieAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }


    func testExample() throws {
        
        let app = XCUIApplication()
        app.launch()

        let omdbMoviesNavigationBar = app.navigationBars["OMDB Movies"]
        omdbMoviesNavigationBar.searchFields["Search Movie / Series / Episode"].tap()
        app.keys["delete"].press(forDuration: 2);
        omdbMoviesNavigationBar.typeText("Avatar")
        let searchKey = app.buttons["Search"]
        searchKey.tap()
        let collectionViewsQuery = app.collectionViews
        let cell = collectionViewsQuery.children(matching: .cell).element(boundBy: 2)
        cell.swipeUp()
        cell.swipeUp()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 1).tap()
        
        omdbMoviesNavigationBar.buttons["OMDB Movies"].tap()
        
        omdbMoviesNavigationBar.searchFields["Search Movie / Series / Episode"].tap()
        let zKey = app.keys["z"]
        zKey.tap()
        zKey.tap()
        zKey.tap()
        searchKey.tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

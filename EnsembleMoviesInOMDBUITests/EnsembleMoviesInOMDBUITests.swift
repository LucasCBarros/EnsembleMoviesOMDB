//
//  EnsembleMoviesInOMDBUITests.swift
//  EnsembleMoviesInOMDBUITests
//
//  Created by Lucas C Barros on 2024-05-02.
//

import XCTest

final class EnsembleMoviesInOMDBUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testNew() {
        let app = XCUIApplication()
        
        let moviesListNavigationBar = app.navigationBars["Movies list"]
        
        moviesListNavigationBar.buttons["Hide search"].tap()
        
        moviesListNavigationBar.buttons["Search"].tap()
        
        moviesListNavigationBar.buttons["Custom cell"].tap()
        
        moviesListNavigationBar.buttons["Generic cell"].tap()
        
        app.textFields["Search movie by title"].tap()
        
        app/*@START_MENU_TOKEN@*/.staticTexts["Search"]/*[[".buttons[\"Search\"].staticTexts[\"Search\"]",".staticTexts[\"Search\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
    }
}

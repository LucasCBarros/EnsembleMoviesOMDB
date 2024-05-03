//
//  MovieSearchListViewControllerUITests.swift
//  EnsembleMoviesInOMDBUITests
//
//  Created by Lucas C Barros on 2024-05-02.
//

import XCTest

final class MovieSearchListViewControllerUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHideShowSearchBar() {
        let app = XCUIApplication()
        app.launch()
        
        let moviesListNavigationBar = app.navigationBars["Movies list"]
        XCTAssertTrue(moviesListNavigationBar.exists)
        
        let searchTextField = app.textFields["Search movie by title"]
        XCTAssertTrue(searchTextField.exists)
        XCTAssertTrue(searchTextField.isHittable)
        let startSearchButton = app.staticTexts["Search"]
        XCTAssertTrue(startSearchButton.exists)
        XCTAssertTrue(startSearchButton.isHittable)
        
        let hideSearchButton = moviesListNavigationBar.buttons["Hide search"]
        XCTAssertTrue(hideSearchButton.exists)
        
        // Test disappear SearchBar
        hideSearchButton.tap()
        XCTAssertFalse(searchTextField.isHittable)
        XCTAssertFalse(startSearchButton.isHittable)
        let showSearchButton = moviesListNavigationBar.buttons["Search"]
        XCTAssertTrue(showSearchButton.exists)
        
        // Test reappear SearchBar
        showSearchButton.tap()
        XCTAssertTrue(searchTextField.exists)
        XCTAssertTrue(startSearchButton.exists)
        
        searchTextField.tap()
        searchTextField.typeText("Test successful!")
    }

    func testToggleTableViewCellType() throws {
        let app = XCUIApplication()
        app.launch()
        
        let moviesListNavigationBar = app.navigationBars["Movies list"]
        XCTAssertTrue(moviesListNavigationBar.exists)
        
        let toggleCustomTableViewCellButton = moviesListNavigationBar.buttons["Custom cell"]
        XCTAssertTrue(toggleCustomTableViewCellButton.exists)
        toggleCustomTableViewCellButton.tap()
        
        let toggleGenericTableViewCellButton = moviesListNavigationBar.buttons["Generic cell"]
        XCTAssertTrue(toggleGenericTableViewCellButton.exists)
        toggleGenericTableViewCellButton.tap()
    }
}

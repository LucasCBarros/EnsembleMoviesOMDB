//
//  MovieSearchListViewControllerUITests.swift
//  EnsembleMoviesInOMDBUITests
//
//  Created by Lucas C Barros on 2024-05-02.
//

import XCTest

final class MovieSearchListViewControllerUITests: XCTestCase {

    // MARK: Hide & show SearchBar
    func testHideShowSearchBar() {
        let app = XCUIApplication()
        app.launch()

        // Test navigation for Movies List
        let moviesListNavigationBar = app.navigationBars["Movies list"]
        XCTAssertTrue(moviesListNavigationBar.exists)

        // Test if SearchBar items are there
        let searchTextField = app.textFields["Search movie by title"]
        XCTAssertTrue(searchTextField.exists)
        XCTAssertTrue(searchTextField.isHittable)
        let startSearchButton = app.staticTexts["Search"]
        XCTAssertTrue(startSearchButton.exists)
        XCTAssertTrue(startSearchButton.isHittable)

        // Apply animation
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

    // MARK: Toggle between TableView Cell types
    func testToggleTableViewCellType() {
        let app = XCUIApplication()
        app.launch()

        // Test navigation for Movies List
        let moviesListNavigationBar = app.navigationBars["Movies list"]
        XCTAssertTrue(moviesListNavigationBar.exists)

        // Write & search in SearchBar
        let searchTextField = app.textFields["Search movie by title"]
        searchTextField.tap()
        searchTextField.typeText("batman")
        let startSearchButton = app.staticTexts["Search"]
        startSearchButton.tap()

        // Test both cell types
        let toggleGenericTableViewCellButton = moviesListNavigationBar.buttons["Generic cell"]
        XCTAssertTrue(toggleGenericTableViewCellButton.exists)
        toggleGenericTableViewCellButton.tap()

        let toggleCustomTableViewCellButton = moviesListNavigationBar.buttons["Custom cell"]
        XCTAssertTrue(toggleCustomTableViewCellButton.exists)
        toggleCustomTableViewCellButton.tap()
    }

    // MARK: Open tableViewCell
    func testOpenMovieTableViewCell() {
        let app = XCUIApplication()
        app.launch()

        // Test navigation for Movies List
        let moviesListNavigationBar = app.navigationBars["Movies list"]
        XCTAssertTrue(moviesListNavigationBar.exists)

        // Write & search in SearchBar to populate tableView
        let searchTextField = app.textFields["Search movie by title"]
        searchTextField.tap()
        searchTextField.typeText("batman")
        let startSearchButton = app.staticTexts["Search"]
        startSearchButton.tap()

        // Open first movie
        let tableView = app.tables["movieTableView"]
        let cell = tableView.cells["MovieSearchTableViewCell0"]
        cell.tap()
    }
}

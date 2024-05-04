//
//  MovieDetailViewControllerUITests.swift
//  EnsembleMoviesInOMDBUITests
//
//  Created by Lucas C Barros on 2024-05-02.
//

import XCTest

final class MovieDetailViewControllerUITests: XCTestCase {

    // MARK: Navigate to Movie Details
    func testNavigateToDetail() {
        let app = XCUIApplication()
        app.launch()

        // Test navigation for Movies List
        let moviesListNavigationBar = app.navigationBars["Movies list"]
        XCTAssertTrue(moviesListNavigationBar.exists)

        // Writes & search
        let searchTextField = app.textFields["Search movie by title"]
        searchTextField.tap()
        searchTextField.typeText("batman")
        let startSearchButton = app.staticTexts["Search"]
        startSearchButton.tap()

        // Opens movie in first cell
        let tableView = app.tables["movieTableView"]
        let cell = tableView.cells["MovieSearchTableViewCell0"]
        cell.tap()
    }

    // MARK: Movie Details information
    func testMovieDetailViews() {
        testNavigateToDetail()
        let app = XCUIApplication()

        // Find views in Movie Detail
        let movieTitle = app.staticTexts["movieTitleLabel"]
        XCTAssertTrue(movieTitle.exists)
        let movieDate = app.staticTexts["movieReleasedDateLabel"]
        XCTAssertTrue(movieDate.exists)
        let moviePoster = app.images["moviePosterView"]
        XCTAssertTrue(moviePoster.exists)
    }

    // MARK: Navigate back to Movies List
    func testMovieDetailNavigateBackToSearchList() {
        testNavigateToDetail()
        let app = XCUIApplication()

        // Test navigation for Movie Details
        let backButton = app.navigationBars["Movie Details"].buttons["Movies list"]
        XCTAssertTrue(backButton.exists)
        backButton.tap()

        // Navigate back button on navBar
        let moviesListNavigationBar = app.navigationBars["Movies list"]
        XCTAssertTrue(moviesListNavigationBar.exists)
    }
}

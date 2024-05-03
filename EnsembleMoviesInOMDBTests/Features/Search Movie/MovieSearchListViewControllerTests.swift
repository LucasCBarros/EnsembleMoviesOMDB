//
//  MovieSearchListViewControllerTests.swift
//  EnsembleMoviesInOMDBTests
//
//  Created by Lucas C Barros on 2024-05-01.
//

import XCTest
@testable import EnsembleMoviesInOMDB

final class MovieSearchListViewControllerTests: XCTestCase {

    var viewController: MovieSearchListViewController?
    var viewModel: MovieSearchListViewModel?
    var networkManager: NetworkManagerMock?

    override func setUp() {
        viewController = MovieSearchListViewController()
        networkManager = NetworkManagerMock()

        viewModel = MovieSearchListViewModel(movies: [],
                                             delegate: viewController.self,
                                             networkManager: networkManager)
        viewController?.viewModel = viewModel
    }

    override func tearDown() {
        viewController = nil
        viewModel = nil
        networkManager = nil
    }

    func testTapSearchButton() {
        // GIVEN
        let searchString = "batman"
        guard let initialText = viewController?.searchTextField.text else {
            XCTFail("SearchField is nil")
            return }
        XCTAssertTrue(initialText.isEmpty, "Field should start empty")
        XCTAssertEqual(viewController?.viewModel?.movies.count, 0,
                       "Movies list should start empty")

        // WHEN
        viewController?.searchTextField.text = searchString
        viewController?.tapSearchButton()

        // THEN
        XCTAssertEqual(viewController?.viewModel?.movies.count, 3,
                       "Movies list should be loaded with the search result")
    }

    func testTapToggleSearchFeatureButton() {
        // GIVEN
        let viewController = MovieSearchListViewController()
        viewController.viewDidLoad()

        let searchButton = viewController.searchButton
        let searchTextField = viewController.searchTextField
        let movieTableView = viewController.movieTableView

        let searchButtonInitialOrigin = searchButton.frame.origin
        let searchTextFieldInitialOrigin = searchTextField.frame.origin
        let movieTableViewInitialOrigin = movieTableView.frame.origin

        // Check initial state
        XCTAssertTrue(viewController.shouldSearch)
        XCTAssertFalse(searchButton.isHidden)
        XCTAssertFalse(searchTextField.isHidden)
        XCTAssertEqual(viewController.navigationItem.rightBarButtonItem?.title, "Hide search")

        // WHEN
        viewController.tapToggleSearchFeatureButton()

        // THEN
        // Check state after animation
        let exp = expectation(description: "Test after 2.5 second wait")
        let result = XCTWaiter.wait(for: [exp], timeout: 2.5)
        if result == XCTWaiter.Result.timedOut {
            // Check if views are hidden
            XCTAssertFalse(viewController.shouldSearch)
            XCTAssertTrue(searchButton.isHidden)
            XCTAssertTrue(searchTextField.isHidden)
            XCTAssertEqual(viewController.navigationItem.rightBarButtonItem?.title, "Search")

            // Check if animation moved views
            XCTAssertNotEqual(searchButtonInitialOrigin, searchButton.frame.origin)
            XCTAssertNotEqual(searchTextFieldInitialOrigin, searchTextField.frame.origin)
            XCTAssertNotEqual(movieTableViewInitialOrigin, movieTableView.frame.origin)
        } else {
            XCTFail("Delay interrupted")
        }

        // AND WHEN
        viewController.tapToggleSearchFeatureButton()

        // THEN
        let exp2 = expectation(description: "Test after 2.5 second wait")
        let result2 = XCTWaiter.wait(for: [exp2], timeout: 2.5)
        if result2 == XCTWaiter.Result.timedOut {
            // Check if views are showing again
            XCTAssertTrue(viewController.shouldSearch)
            XCTAssertFalse(searchButton.isHidden)
            XCTAssertFalse(searchTextField.isHidden)
            XCTAssertEqual(viewController.navigationItem.rightBarButtonItem?.title, "Hide search")
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func testTapCustomCellFeatureButton() {
        // GIVEN
        networkManager = NetworkManagerMock(shouldReturnError: false)
        let viewController = MovieSearchListViewController()

        viewModel = MovieSearchListViewModel(movies: DataMockFactory.buildSearchMoviesMock().movies,
                                             delegate: viewController.self,
                                             networkManager: networkManager)
        viewController.viewModel = viewModel
        viewController.viewDidLoad()

        // WHEN
        XCTAssertTrue(viewController.withCustomCell)
        viewController.tapCustomCellFeatureButton()

        // THEN
        XCTAssertNotNil(viewController.movieTableView.visibleCells.first)
        XCTAssertTrue(viewController.movieTableView.visibleCells.first is UITableViewCell)
        XCTAssertEqual(viewController.navigationItem.leftBarButtonItem?.title, "Generic cell")

        // AND
        viewController.tapCustomCellFeatureButton()
        XCTAssertTrue(viewController.movieTableView.visibleCells.first is MovieSearchTableViewCell)
        XCTAssertEqual(viewController.navigationItem.leftBarButtonItem?.title, "Custom cell")
    }

    func testTableViewDidSelectRow() {
        // GIVEN
        networkManager = NetworkManagerMock(shouldReturnError: false)
        let viewController = MovieSearchListViewController()

        viewModel = MovieSearchListViewModel(movies: DataMockFactory.buildSearchMoviesMock().movies,
                                             delegate: viewController.self,
                                             networkManager: networkManager)
        viewController.viewModel = viewModel
        viewController.viewDidLoad()

        let navigation = UINavigationController()
        navigation.viewControllers = [viewController]
        UIApplication.shared.windows.first?.rootViewController = viewController

        // WHEN
        XCTAssertTrue(navigation.topViewController is MovieSearchListViewController,
                      "The current viewController should be MovieSearchListViewController")
        viewController.tableView(viewController.movieTableView, didSelectRowAt: IndexPath(row: 0, section: 0))

        // THEN
        let exp = expectation(description: "Test after 1.5 second wait")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.5)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue(navigation.topViewController is MovieDetailViewController,
                          "The new viewController should be MovieDetailViewController")
        } else {
            XCTFail("Delay interrupted")
        }
    }
}

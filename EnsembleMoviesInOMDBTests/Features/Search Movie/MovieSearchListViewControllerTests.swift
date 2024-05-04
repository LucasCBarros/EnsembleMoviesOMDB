//
//  MovieSearchListViewControllerTests.swift
//  EnsembleMoviesInOMDBTests
//
//  Created by Lucas C Barros on 2024-05-01.
//

import XCTest
@testable import EnsembleMoviesInOMDB

final class MovieSearchListViewControllerTests: XCTestCase {

    // MARK: Test config properties
    var sut_viewController: MovieSearchListViewController?
    var viewModel: MovieSearchListViewModel!
    var networkManager: NetworkManagerMock!

    // MARK: SetUp & TearDown
    override func setUp() {
        networkManager = NetworkManagerMock()
        viewModel = MovieSearchListViewModel(movies: [],
                                             networkManager: networkManager)
        sut_viewController = MovieSearchListViewController(viewModel: viewModel)
    }

    override func tearDown() {
        sut_viewController = nil
        viewModel = nil
        networkManager = nil
    }

    // MARK: Tap search button
    func testTapSearchButton() {
        // GIVEN
        let searchString = "batman"
        guard let initialText = sut_viewController?.searchTextField.text else {
            XCTFail("SearchField is nil")
            return }
        XCTAssertTrue(initialText.isEmpty, "Field should start empty")
        XCTAssertEqual(sut_viewController?.viewModel.movies.count, 0,
                       "Movies list should start empty")

        // WHEN
        sut_viewController?.searchTextField.text = searchString
        sut_viewController?.tapSearchButton()

        // THEN
        XCTAssertEqual(sut_viewController?.viewModel.movies.count, 3,
                       "Movies list should be loaded with the search result")
    }

    // MARK: Toggle searchBar
    func testTapToggleSearchFeatureButton() {
        // GIVEN
        sut_viewController?.viewDidLoad()

        let searchButton = sut_viewController?.searchButton
        let searchTextField = sut_viewController?.searchTextField
        let movieTableView = sut_viewController?.movieTableView

        let searchButtonInitialOrigin = searchButton?.frame.origin
        let searchTextFieldInitialOrigin = searchTextField?.frame.origin
        let movieTableViewInitialOrigin = movieTableView?.frame.origin

        // Check initial state
        XCTAssertTrue(sut_viewController!.shouldSearch)
        XCTAssertFalse(searchButton!.isHidden)
        XCTAssertFalse(searchTextField!.isHidden)
        XCTAssertEqual(sut_viewController?.navigationItem.rightBarButtonItem?.title, "Hide search")

        // WHEN
        sut_viewController?.tapToggleSearchFeatureButton()

        // THEN
        // Check state after animation
        let exp = expectation(description: "Test after 2.5 second wait")
        let result = XCTWaiter.wait(for: [exp], timeout: 2.5)
        if result == XCTWaiter.Result.timedOut {
            // Check if views are hidden
            XCTAssertFalse(sut_viewController!.shouldSearch)
            XCTAssertTrue(searchButton!.isHidden)
            XCTAssertTrue(searchTextField!.isHidden)
            XCTAssertEqual(sut_viewController?.navigationItem.rightBarButtonItem?.title, "Search")

            // Check if animation moved views
            XCTAssertNotEqual(searchButtonInitialOrigin, searchButton?.frame.origin)
            XCTAssertNotEqual(searchTextFieldInitialOrigin, searchTextField?.frame.origin)
            XCTAssertNotEqual(movieTableViewInitialOrigin, movieTableView?.frame.origin)
        } else {
            XCTFail("Delay interrupted")
        }

        // AND WHEN
        sut_viewController?.tapToggleSearchFeatureButton()

        // THEN
        let exp2 = expectation(description: "Test after 2.5 second wait")
        let result2 = XCTWaiter.wait(for: [exp2], timeout: 2.5)
        if result2 == XCTWaiter.Result.timedOut {
            // Check if views are showing again
            XCTAssertTrue(sut_viewController!.shouldSearch)
            XCTAssertFalse(searchButton!.isHidden)
            XCTAssertFalse(searchTextField!.isHidden)
            XCTAssertEqual(sut_viewController?.navigationItem.rightBarButtonItem?.title, "Hide search")
        } else {
            XCTFail("Delay interrupted")
        }
    }

    // MARK: Toggle Custom & Generic cell
    func testTapCustomCellFeatureButton() {
        // GIVEN
        networkManager = NetworkManagerMock(shouldReturnError: false)
        viewModel = MovieSearchListViewModel(movies: DataMockFactory.buildSearchMoviesMock().movies,
                                             networkManager: networkManager)
        sut_viewController = MovieSearchListViewController(viewModel: viewModel)
        sut_viewController?.viewDidLoad()

        // WHEN
        XCTAssertTrue(sut_viewController!.withCustomCell)
        sut_viewController?.tapCustomCellFeatureButton()

        // THEN
        XCTAssertNotNil(sut_viewController!.movieTableView.visibleCells.first)
        XCTAssertTrue(sut_viewController!.movieTableView.visibleCells.first is UITableViewCell)
        XCTAssertEqual(sut_viewController!.navigationItem.leftBarButtonItem?.title, "Custom cell")

        // AND
        sut_viewController?.tapCustomCellFeatureButton()
        XCTAssertTrue(sut_viewController!.movieTableView.visibleCells.first is MovieSearchTableViewCell)
        XCTAssertEqual(sut_viewController!.navigationItem.leftBarButtonItem?.title, "Generic cell")
    }

    // MARK: Select tableView cell
    func testTableViewDidSelectRow() {
        // GIVEN
        networkManager = NetworkManagerMock(shouldReturnError: false)
        viewModel = MovieSearchListViewModel(movies: DataMockFactory.buildSearchMoviesMock().movies,
                                             delegate: sut_viewController.self,
                                             networkManager: networkManager)
        sut_viewController = MovieSearchListViewController(viewModel: viewModel)
        sut_viewController?.viewDidLoad()

        let navigation = UINavigationController()
        navigation.viewControllers = [sut_viewController!]
        UIApplication.shared.windows.first?.rootViewController = sut_viewController

        // WHEN
        XCTAssertTrue(navigation.topViewController is MovieSearchListViewController,
                      "The current viewController should be MovieSearchListViewController")
        sut_viewController?.tableView(sut_viewController!.movieTableView, didSelectRowAt: IndexPath(row: 0, section: 0))

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

//
//  MovieSearchListViewModelTests.swift
//  EnsembleMoviesInOMDBTests
//
//  Created by Lucas C Barros on 2024-05-01.
//

@testable import EnsembleMoviesInOMDB
import XCTest

final class MovieSearchListViewModelTests: XCTestCase {
    // MARK: Propeties
    var networkManager: NetworkManagerMock!
    var sut_viewModel: MovieSearchListViewModel!
    var viewController: MovieSearchListViewController?

    // MARK: SetUp & TearDown
    override func setUp() {
        networkManager = NetworkManagerMock()
        sut_viewModel = MovieSearchListViewModel(movies: [],
                                             networkManager: networkManager)
        viewController = MovieSearchListViewController(viewModel: sut_viewModel)
    }

    override func tearDown() {
        networkManager = nil
        sut_viewModel = nil
    }
    // MARK: Search Movie with success
    func testSearchMovieWithSuccess() {
        // GIVEN
        networkManager?.setReturnError(false)
        let searchTitle = "batman"

        // WHEN
        sut_viewModel?.networkManager.fetchMovies(withTitle: searchTitle, completion: { response in
            switch response {
            case .success(let search):
                // THEN
                XCTAssertEqual(search.movies.count, 3, "Response should contain same as the mock data")
                XCTAssertNotNil(search, "The expected result should have an object with array of movies")

            case.failure(let error):
                // THEN
                XCTAssertNil(error, "The expected result should be successful")
            }
        })
    }

    // MARK: Search Movie with failures
    func testSearchMovieWithFailure() {
        // GIVEN
        networkManager?.setReturnError(true)
        let searchTitle = "batman"

        // WHEN
        sut_viewModel?.networkManager.fetchMovies(withTitle: searchTitle, completion: { response in
            switch response {
            case .success(let search):
                // THEN
                XCTAssertNil(search, "The expected result should be a failure")
            case.failure(let error):
                // THEN
                XCTAssertEqual(error.description, "Invalid server data")
                XCTAssertNotNil(error, "The expected result should have an error of type .invalidData")
            }
        })
    }

    // MARK: Search Movie with empty string alert
    func testSearchMovieWithEmptyStringAlert() {
        // GIVEN
        networkManager?.setReturnError(false)
        sut_viewModel = MovieSearchListViewModel(movies: [],
                                             networkManager: networkManager)
        viewController = MovieSearchListViewController(viewModel: sut_viewModel)
        let searchText = ""

        // WHEN
        UIApplication.shared.windows.first?.rootViewController = viewController
        sut_viewModel?.fetchMovies(with: searchText)

        // THEN
        let exp = expectation(description: "Test after 1.5 second wait")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.5)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(viewController?.presentedViewController?.title,
                           "Invalid empty search",
                           "The Alert view should be shown in the screen")
            XCTAssertTrue(viewController?.presentedViewController is UIAlertController,
                          "The Alert view should be shown in the screen")
        } else {
            XCTFail("Delay interrupted")
        }
    }

    // MARK: Search Movie with short string alert
    func testSearchMovieWithSmallStringAlert() {
        // GIVEN
        networkManager?.setReturnError(false)
        sut_viewModel = MovieSearchListViewModel(movies: [],
                                             networkManager: networkManager)
        viewController = MovieSearchListViewController(viewModel: sut_viewModel)
        let searchText = "12"

        // WHEN
        UIApplication.shared.windows.first?.rootViewController = viewController
        sut_viewModel?.fetchMovies(with: searchText)

        // THEN
        let exp = expectation(description: "Test after 1.5 second wait")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.5)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(viewController?.presentedViewController?.title,
                           "Invalid lacking information",
                           "The Alert view should be shown in the screen")
            XCTAssertTrue(viewController?.presentedViewController is UIAlertController,
                          "The Alert view should be shown in the screen")
        } else {
            XCTFail("Delay interrupted")
        }
    }

    // MARK: Update view with alert
    func testUpdateViewWithError() {
        // GIVEN
        let testErrors: [FetchError] = [
            .invalidURL,
            .invalidResponse,
            .invalidData,
            .invalidJsonParse,
            .apiError(APIError(response: "API Response",
                               error: "API Error"))]

        for error in testErrors {
            // WHEN
            networkManager = NetworkManagerMock(shouldReturnError: true)
            networkManager?.setReturnError(true, with: error)

            sut_viewModel = MovieSearchListViewModel(movies: [],
                                                 networkManager: networkManager)
            viewController = MovieSearchListViewController(viewModel: sut_viewModel)

            UIApplication.shared.windows.first?.rootViewController = viewController
            viewController?.viewModel.fetchMovies(with: "batman")

            // THEN
            let exp = expectation(description: "Test after 1.5 second wait")
            let result = XCTWaiter.wait(for: [exp], timeout: 1.5)
            if result == XCTWaiter.Result.timedOut {
                XCTAssertTrue(viewController?.presentedViewController is UIAlertController,
                              "The Alert view should be shown in the screen")
            } else {
                XCTFail("Delay interrupted")
            }
        }
    }

    // MARK: Update tableView with Movies
    func testUpdateTableViewWithMovies() {
        // GIVEN
        networkManager = NetworkManagerMock(shouldReturnError: false)
        sut_viewModel = MovieSearchListViewModel(movies: [],
                                             networkManager: networkManager)
        viewController = MovieSearchListViewController(viewModel: sut_viewModel)

        XCTAssertEqual(viewController?.viewModel.movies.count, 0,
                       "movies inside viewModel shouldn't have any movies")
        XCTAssertEqual(viewController?.movieTableView.numberOfRows(inSection: 0), 0,
                       "movieTableView should start with zero cells")

        // WHEN
        viewController?.viewModel.fetchMovies(with: "batman")
        viewController?.loadViewIfNeeded()

        // THEN
        let exp = expectation(description: "Test after 1.5 second wait")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.5)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(viewController?.viewModel.movies.count, 3,
                           "movies inside viewModel should have 3 movies")
            XCTAssertEqual(viewController?.movieTableView.numberOfRows(inSection: 0), 3,
                           "movieTableView should end with 3 movies")
        } else {
            XCTFail("Delay interrupted")
        }
    }

    // MARK: Navigate to MovieDetail screen
    func testNavigateToMovieDetail() {
        // GIVEN
        networkManager = NetworkManagerMock(shouldReturnError: false)
        sut_viewModel = MovieSearchListViewModel(movies: DataMockFactory.buildSearchMoviesMock().movies,
                                             networkManager: networkManager)
        viewController = MovieSearchListViewController(viewModel: sut_viewModel)

        let navigation = UINavigationController()
        navigation.viewControllers = [viewController!]
        UIApplication.shared.windows.first?.rootViewController = viewController
        viewController?.viewModel.navigateToMovieDetail(with: DataMockFactory.buildMovieMock(),
                                                         navigation: navigation)

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

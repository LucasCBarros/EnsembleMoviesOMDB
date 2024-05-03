//
//  MovieDetailViewModelTests.swift
//  EnsembleMoviesInOMDB
//
//  Created by Lucas C Barros on 2024-05-01.
//

import XCTest
@testable import EnsembleMoviesInOMDB

final class MovieDetailViewModelTests: XCTestCase {
    // MARK: Properties
    var networkManager: NetworkManagerMock?
    var viewModel: MovieDetailViewModel?
    var viewController: MovieDetailViewController?

    // MARK: SetUp & TearDown
    override func setUp() {
        networkManager = NetworkManagerMock()

        let movie = DataMockFactory.buildMovieMock()
        viewModel = MovieDetailViewModel(movie: movie,
                                         delegate: viewController.self,
                                         networkManager: networkManager)

        viewController?.viewModel = viewModel
        viewController = MovieDetailViewController()
    }

    override func tearDown() {
        networkManager = nil
        viewModel = nil
    }

    // MARK: Fetch Movie Poster Success
    func testFetchMoviePosterSuccess() {
        // GIVEN
        networkManager?.setReturnError(false)

        // WHEN
        viewModel?.networkManager?.fetchMoviePoster(imageURL: "posterURL", completion: { response in
            switch response {
            case .success(let image):
                // THEN
                self.viewModel?.updateViewWithImage(image)
                XCTAssertNotNil(image, "The expected result should have an image data")
            case .failure(let error):
                // THEN
                self.viewModel?.updateViewWithError(error)
                XCTAssertNil(error, "The expected result should be successful")
            }
        })
    }

    // MARK: Fetch Movie Poster Failures
    func testFetchMoviePosterFailure() {
        // GIVEN
        let testErrors: [FetchError] = [
            .invalidURL,
            .invalidResponse,
            .invalidData,
            .invalidJsonParse,
            .apiError(APIError(response: "API Response",
                               error: "API Error"))]

        for error in testErrors {
            networkManager?.setReturnError(true, with: error)

            // WHEN
            viewModel?.networkManager?.fetchMoviePoster(imageURL: "posterURL", completion: { response in
                switch response {
                case .success(let image):
                    // THEN
                    XCTAssertNil(image, "The expected result should be a failure")
                case .failure(let error):
                    // THEN
                    XCTAssertNotNil(error, "The expected result should have an error of type .apiError")
                    switch error {
                    case .invalidURL:
                        XCTAssertEqual(error.description, "Invalid server URL")
                        XCTAssertNotNil(error, "The expected result should have an error of type .invalidURL")
                    case .invalidResponse:
                        XCTAssertEqual(error.description, "Invalid server response")
                        XCTAssertNotNil(error, "The expected result should have an error of type .invalidResponse")
                    case .invalidData:
                        XCTAssertEqual(error.description, "Invalid server data")
                        XCTAssertNotNil(error, "The expected result should have an error of type .invalidData")
                    case .invalidJsonParse:
                        XCTAssertEqual(error.description, "Invalid json parsing")
                        XCTAssertNotNil(error, "The expected result should have an error of type .invalidJsonParse")
                    case .apiError(let apiError):
                        XCTAssertEqual(error.description, "Server error: \(apiError.error)")
                    }
                }
            })
        }
    }

    // MARK: Update view with error
    func testUpdateViewWithError() {
        // GIVEN
        networkManager = NetworkManagerMock(shouldReturnError: true)

        viewModel = MovieDetailViewModel(movie: DataMockFactory.buildMovieMock(),
                                         delegate: viewController.self,
                                         networkManager: networkManager)
        viewController?.viewModel = viewModel

        // WHEN
        UIApplication.shared.windows.first?.rootViewController = viewController

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

    // MARK: Update view with image
    func testUpdateViewWithImage() {
        // GIVEN
        networkManager = NetworkManagerMock(shouldReturnError: false)

        XCTAssertNil(viewController?.moviePosterView.image,
                      "moviePosterView should start without image")

        let movie = DataMockFactory.buildMovieMock()
        viewModel = MovieDetailViewModel(movie: movie,
                                         delegate: viewController.self,
                                         networkManager: networkManager)
        viewController?.viewModel = viewModel

        // WHEN
        viewController?.viewModel?.fetchMoviePoster()

        // THEN
        let exp = expectation(description: "Test after 1.5 second wait")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.5)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertNotNil(viewController?.moviePosterView.image,
                          "There should be an image the moviePosterView")
        } else {
            XCTFail("Delay interrupted")
        }
    }
}

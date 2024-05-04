//
//  MovieDetailViewControllerTests.swift
//  EnsembleMoviesInOMDBTests
//
//  Created by Lucas C Barros on 2024-05-01.
//

import XCTest
@testable import EnsembleMoviesInOMDB

final class MovieDetailViewControllerTests: XCTestCase {

    // MARK: Test config properties
    var sut_viewController: MovieDetailViewController?
    var viewModel: MovieDetailViewModel?
    var networkManager: NetworkManagerMock?

    // MARK: SetUp & TearDown
    override func setUp() {
        networkManager = NetworkManagerMock()
        let movie = DataMockFactory.buildMovieMock()
        viewModel = MovieDetailViewModel(movie: movie,
                                         networkManager: networkManager!)
        sut_viewController = MovieDetailViewController(viewModel: viewModel!)
    }

    override func tearDown() {
        sut_viewController = nil
        viewModel = nil
        networkManager = nil
    }

    // MARK: Update image via delegate
    func testUpdateImageWithData() {
        // GIVEN
        networkManager?.setReturnError(false)
        XCTAssertNil(sut_viewController?.moviePosterView.image, "Image should be empty at first")

        // WHEN
        sut_viewController?.updateImageView(with: DataMockFactory.buildImageDataMock())

        // THEN
        XCTAssertNotNil(sut_viewController?.moviePosterView.image, "Image should be empty at first")
    }

    // MARK: Alert error
    func testAlertError() {
        // GIVEN
        networkManager?.setReturnError(true)

        XCTAssertNil(sut_viewController?.navigationController?.visibleViewController?.isKind(of: UIAlertController.self),
                     "Image should be empty at first")

        // WHEN
        UIApplication.shared.keyWindow?.rootViewController = sut_viewController
        sut_viewController?.alertError(title: "Title", description: "Message")

        // THEN
        XCTAssertTrue(UIApplication.shared.keyWindow?.rootViewController?.presentedViewController is UIAlertController)
    }
}

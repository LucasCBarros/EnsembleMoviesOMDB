//
//  MovieDetailViewControllerTests.swift
//  EnsembleMoviesInOMDBTests
//
//  Created by Lucas C Barros on 2024-05-01.
//

import XCTest
@testable import EnsembleMoviesInOMDB

final class MovieDetailViewControllerTests: XCTestCase {

    var viewController: MovieDetailViewController?
    var viewModel: MovieDetailViewModel?
    var networkManager: NetworkManagerMock?
    
    override func setUp() {
        viewController = MovieDetailViewController()
        networkManager = NetworkManagerMock()
        
        let movie = DataMockFactory.buildMovieMock()
        viewModel = MovieDetailViewModel(movie: movie,
                                         delegate: viewController.self,
                                         networkManager: networkManager)
        viewController?.viewModel = viewModel
    }

    override func tearDown() {
        viewController = nil
        viewModel = nil
        networkManager = nil
    }

    // Test Delegate functions
    func testUpdateImageWithData() {
        // GIVEN
        networkManager?.setReturnError(false)
        XCTAssertNil(viewController?.moviePosterView.image, "Image should be empty at first")
        
        // WHEN
        viewController?.updateImageView(with: DataMockFactory.buildImageDataMock())
        
        // THEN
        XCTAssertNotNil(viewController?.moviePosterView.image, "Image should be empty at first")
    }
    
    func testAlertError() {
        // GIVEN
        networkManager?.setReturnError(true)
        
        XCTAssertNil(viewController?.navigationController?.visibleViewController?.isKind(of: UIAlertController.self), "Image should be empty at first")
        
        // WHEN
        UIApplication.shared.keyWindow?.rootViewController = viewController
        viewController?.alertError(title: "Title", description: "Message")
        
        // THEN
        
        XCTAssertTrue(UIApplication.shared.keyWindow?.rootViewController?.presentedViewController is UIAlertController)
    }
}

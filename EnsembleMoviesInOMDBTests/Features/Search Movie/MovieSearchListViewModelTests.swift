//
//  MovieSearchListViewModelTests.swift
//  EnsembleMoviesInOMDBTests
//
//  Created by Lucas C Barros on 2024-05-01.
//

@testable import EnsembleMoviesInOMDB
import XCTest

final class MovieSearchListViewModelTests: XCTestCase {
    
    var networkManager: NetworkManagerMock?
    var viewModel: MovieSearchListViewModel?
    var viewController: MovieSearchListViewController?
    
    override func setUp() {
        networkManager = NetworkManagerMock()
        
        viewModel = MovieSearchListViewModel(movies: [],
                                             delegate: viewController.self,
                                             networkManager: networkManager)
        viewController?.viewModel = viewModel
        viewController = MovieSearchListViewController()
    }
    
    override func tearDown() {
        networkManager = nil
        viewModel = nil
    }
    
    func testSearchMovieWithSuccess() {
        // GIVEN
        networkManager?.setReturnError(false)
        let searchTitle = "batman"
        
        // WHEN
        
        //        if searchTitle.isEmpty {
        //            viewModel?.delegate?.alertError(title: "Invalid search",
        //                                 description: "Can't search an blank title!")
        //        } else if searchTitle.count < 3 {
        //            viewModel?.delegate?.alertError(title: "Invalid search",
        //                                 description: "Need more than 3 characters from the title!")
        //        }
        
        viewModel?.networkManager?.searchMovieWith(title: searchTitle, completion: { response in
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
    
    func testSearchMovieWithFailure() {
        // GIVEN
        networkManager?.setReturnError(true)
        let searchTitle = "batman"
        
        // WHEN
        viewModel?.networkManager?.searchMovieWith(title: searchTitle, completion: { response in
            switch response {
            case .success(let search):
                // THEN
                XCTAssertNil(search, "The expected result should be a failure")
            case.failure(let error):
                // THEN
                XCTAssertEqual(error.description(), "Invalid server data")
                XCTAssertNotNil(error, "The expected result should have an error of type .invalidData")
            }
        })
    }
    
    func testSearchMovieWithEmptyStringAlert() {
        // GIVEN
        networkManager?.setReturnError(false)
        viewModel = MovieSearchListViewModel(movies: [],
                                             delegate: viewController.self,
                                             networkManager: networkManager)
        viewController?.viewModel = viewModel
        var searchText = ""
        
        // WHEN
        UIApplication.shared.windows.first?.rootViewController = viewController
        viewModel?.searchForMovies(with: searchText)
        
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
    
    func testSearchMovieWithSmallStringAlert() {
        // GIVEN
        networkManager?.setReturnError(false)
        viewModel = MovieSearchListViewModel(movies: [],
                                             delegate: viewController.self,
                                             networkManager: networkManager)
        viewController?.viewModel = viewModel
        var searchText = "12"
        
        // WHEN
        UIApplication.shared.windows.first?.rootViewController = viewController
        viewModel?.searchForMovies(with: searchText)
        
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
            
            viewModel = MovieSearchListViewModel(movies: [],
                                                 delegate: viewController.self,
                                                 networkManager: networkManager)
            viewController?.viewModel = viewModel
            
            
            UIApplication.shared.windows.first?.rootViewController = viewController
            viewController?.viewModel?.searchForMovies(with: "batman")
            
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
    
    func testUpdateTableViewWithMovies() {
        // GIVEN
        networkManager = NetworkManagerMock(shouldReturnError: false)
        viewController = MovieSearchListViewController()
        viewModel = MovieSearchListViewModel(movies: [],
                                             delegate: viewController.self,
                                             networkManager: networkManager)
        viewController?.viewModel = viewModel
        
        XCTAssertEqual(viewController?.viewModel?.movies.count, 0,
                       "movies inside viewModel shouldn't have any movies")
        XCTAssertEqual(viewController?.movieTableView.numberOfRows(inSection: 0), 0,
                       "movieTableView should start with zero cells")
        
        // WHEN
        viewController?.viewModel?.searchForMovies(with: "batman")
        viewController?.loadViewIfNeeded()
        
        // THEN
        let exp = expectation(description: "Test after 1.5 second wait")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.5)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(viewController?.viewModel?.movies.count, 3,
                           "movies inside viewModel should have 3 movies")
            XCTAssertEqual(viewController?.movieTableView.numberOfRows(inSection: 0), 3,
                           "movieTableView should end with 3 movies")
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testNavigateToMovieDetail() {
        // GIVEN
        networkManager = NetworkManagerMock(shouldReturnError: false)
        let viewController = MovieSearchListViewController()
        
        viewModel = MovieSearchListViewModel(movies: DataMockFactory.buildSearchMoviesMock().movies,
                                             delegate: viewController.self,
                                             networkManager: networkManager)
        viewController.viewModel = viewModel
        
        let navigation = UINavigationController()
        navigation.viewControllers = [viewController]
        
        UIApplication.shared.windows.first?.rootViewController = viewController
        viewController.viewModel?.navigateToMovieDetail(with: DataMockFactory.buildMovieMock(),
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

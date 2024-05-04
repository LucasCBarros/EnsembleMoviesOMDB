//
//  NetworkManagerTests.swift
//  EnsembleMoviesInOMDBTests
//
//  Created by Lucas C Barros on 2024-05-02.
//

@testable import EnsembleMoviesInOMDB
import XCTest

final class NetworkManagerTests: XCTestCase {
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLprotocol.self]
        return URLSession(configuration: configuration)
    }()

    lazy var sut_networkManager: NetworkManager = {
        NetworkManager(session: session)
    }()

    // MARK: - Test FetchMovies()
    // MARK: Success
    func testFetchMoviesSuccessful() {
        let url = Constants.endPoint+"&s=bat"
        guard let mockData = DataMockFactory.getMockFromJson(from: "Search") else { return }

        MockURLprotocol.requestHandler = { request in
            XCTAssertEqual(request.url?.absoluteString, url)

            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!

            return (response, mockData, nil)
        }

        sut_networkManager.fetchMovies(withTitle: "bat", completion: { response in
            switch response {
            case .success(let search):
                XCTAssertNotNil(search)
                XCTAssertEqual(search.movies.count, 10, "Expected 10 movies from json file")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        })
    }

    // MARK: Failure - Invalid JSON
    func testFetchSearchInvalidJson() {
        let url = Constants.endPoint+"&s=bat"
        guard let mockInvalidJson = DataMockFactory.getMockFromJson(from: "Movie") else { return }

        MockURLprotocol.requestHandler = { request in
            XCTAssertEqual(request.url?.absoluteString, url)

            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!

            return (response, mockInvalidJson, nil)
        }

        sut_networkManager.fetchMovies(withTitle: "bat", completion: { response in
            switch response {
            case .success(let search):
                XCTAssertNil(search, "Result should be nil")
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.description, "Invalid json parsing", "The JSON should be invalid")
            }
        })
    }

    // MARK: Failure - Invalid Response
    func testFetchSearchInvalidResponse() {
        MockURLprotocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!

            return (response, nil, FetchError.invalidResponse)
        }

        sut_networkManager.fetchMovies(withTitle: "bat", completion: { response in
            switch response {
            case .success(let imageData):
                XCTAssertNil(imageData, "Should be nil")
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.description, "Invalid server response", "The response should be invalid")
            }
        })
    }

    // MARK: Failure - Invalid Data
    func testFetchMoviesInvalidData() {
        MockURLprotocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, nil, nil)
        }

        sut_networkManager.fetchMovies(withTitle: "bat", completion: { response in
            switch response {
            case .success(let imageData):
                XCTAssertNil(imageData, "Should be nil")
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.description, "Invalid server data", "The data should be invalid")
            }
        })
    }

    // MARK: - Test FetchMoviePoster()
    // MARK: Success
    func testFetchMoviePosterSuccessful() {
        let mockData = DataMockFactory.buildImageDataMock()

        MockURLprotocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, mockData, nil)
        }

        sut_networkManager.fetchMoviePoster(imageURL: "http://img.omdbapi.com/?apikey=36d78389&i=tt0096895",
                                        completion: { response in
            switch response {
            case .success(let imageData):
                XCTAssertNotNil(imageData)
                XCTAssertEqual(imageData, mockData, "Result should be the same as the mockedData")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        })
    }

    // MARK: Failure - Invalid Data
    func testFetchMoviePosterInvalidData() {
        MockURLprotocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, nil, nil)
        }

        sut_networkManager.fetchMoviePoster(imageURL: "http://img.omdbapi.com/?apikey=36d78389&i=tt0096895",
                                        completion: { response in
            switch response {
            case .success(let imageData):
                XCTAssertNil(imageData, "Should be nil")
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.description, "Invalid server data", "The data should be invalid")
            }
        })
    }

    // MARK: Failure - Invalid Response
    func testFetchMoviePosterInvalidResponse() {
        MockURLprotocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, nil, FetchError.invalidResponse)
        }

        sut_networkManager.fetchMoviePoster(imageURL: "http://img.omdbapi.com/?apikey=36d78389&i=tt0096895",
                                        completion: { response in
            switch response {
            case .success(let imageData):
                XCTAssertNil(imageData, "Should be nil")
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.description, "Invalid server response", "The response should be invalid")
            }
        })
    }
}

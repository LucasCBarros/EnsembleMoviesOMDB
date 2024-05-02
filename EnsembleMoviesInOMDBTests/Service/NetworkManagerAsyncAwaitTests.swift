//
//  NetworkManagerTestableTests.swift
//  EnsembleMoviesInOMDBTests
//
//  Created by Lucas C Barros on 2024-05-02.
//

@testable import EnsembleMoviesInOMDB
import XCTest

final class NetworkManagerAsyncAwaitTests: XCTestCase {
        lazy var session: URLSession = {
            let configuration = URLSessionConfiguration.ephemeral
            configuration.protocolClasses = [MockURLprotocol.self]
            return URLSession(configuration: configuration)
        }()
        
        lazy var networkManager: NetworkManagerAsyncAwait = {
            NetworkManagerAsyncAwait(session: session)
        }()
        
        func testFetchSearch() async throws {
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
            
            let result = try await networkManager.fetchMovies(withTitle: "bat")
            
            XCTAssertNotNil(result)
            XCTAssertEqual(result.movies.count, 10, "Expected 10 movies from json file")
        }
        
        func testFetchMoviePoster() async throws {
            let mockData = DataMockFactory.buildImageDataMock()
            
            MockURLprotocol.requestHandler = { request in
                let response = HTTPURLResponse(url: request.url!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)!
                
                return (response, mockData, nil)
            }
            
            let result = try await networkManager.fetchMoviePoster(imageURL: "http://img.omdbapi.com/?apikey=36d78389&i=tt0096895")
            XCTAssertNotNil(result)
            XCTAssertEqual(result, mockData, "Result should be the same as the mockedData")
        }
        
        func testFetchMovie() async throws {
            guard let mockData = DataMockFactory.getMockFromJson(from: "Movie") else { return }
            
            MockURLprotocol.requestHandler = { request in
                let response = HTTPURLResponse(url: request.url!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)!
                
                return (response, mockData, nil)
            }
            
            let result = try await networkManager.fetchMovie(withID: "tt0096895")
            XCTAssertNotNil(result)
            XCTAssertEqual(result.title, "Batman", "Result should be the same as the mockedData")
        }
    }

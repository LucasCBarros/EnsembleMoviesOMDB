//
//  NetworkManagerMock.swift
//  EnsembleMoviesInOMDBTests
//
//  Created by Lucas C Barros on 2024-05-01.
//

import XCTest
@testable import EnsembleMoviesInOMDB

class NetworkManagerMock: NetworkManagerProtocol {
    // MARK: Properties
    private var shouldReturnError: Bool
    private var errorType: FetchError

    // MARK: init
    init(shouldReturnError: Bool = false, errorType: FetchError = .invalidData) {
        self.shouldReturnError = shouldReturnError
        self.errorType = errorType
    }

    // MARK: Mock return type
    func setReturnError(_ shouldReturnError: Bool, with errorType: FetchError = .invalidData) {
        self.shouldReturnError = shouldReturnError
        self.errorType = errorType
    }

    // MARK: Mock result for FetchMovies
    func fetchMovies(withTitle: String, completion: @escaping (Result<Search, FetchError>) -> Void) {
        if !shouldReturnError {
            completion(.success(DataMockFactory.buildSearchMoviesMock()))
        } else {
            completion(.failure(errorType))
        }
    }

    // MARK: Mock result for FetchMoviePoster
    func fetchMoviePoster(imageURL: String, completion: @escaping (Result<Data, FetchError>) -> Void) {
        if !shouldReturnError {
            completion(.success(DataMockFactory.buildImageDataMock()))
        } else {
            completion(.failure(errorType))
        }
    }
}

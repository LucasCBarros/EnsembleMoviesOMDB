//
//  NetworkManagerMock.swift
//  EnsembleMoviesInOMDBTests
//
//  Created by Lucas C Barros on 2024-05-01.
//

import Foundation
@testable import EnsembleMoviesInOMDB

class NetworkManagerMock: NetworkManagerProtocol {
    private var shouldReturnError: Bool
    private var errorType: FetchError
    
    init(shouldReturnError: Bool = false, errorType: FetchError = .invalidData) {
        self.shouldReturnError = shouldReturnError
        self.errorType = errorType
    }
    
    func setReturnError(_ shouldReturnError: Bool, with errorType: FetchError = .invalidData) {
        self.shouldReturnError = shouldReturnError
        self.errorType = errorType
    }
    
    func searchMovieWith(title: String, completion: @escaping (Result<Search, FetchError>) -> Void) {
        if !shouldReturnError {
            completion(.success(DataMockFactory.buildSearchMoviesMock()))
        } else {
            completion(.failure(errorType))
        }
        
    }
    
    func fetchMoviePoster(imageURL: String, completion: @escaping (Result<Data, FetchError>) -> Void) {
        if !shouldReturnError {
            completion(.success(DataMockFactory.buildImageDataMock()))
        } else {
            completion(.failure(errorType))
        }
    }
}

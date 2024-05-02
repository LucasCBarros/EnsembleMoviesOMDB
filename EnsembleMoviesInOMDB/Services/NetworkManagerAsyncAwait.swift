//
//  NetworkManagerAsyncAwait.swift
//  EnsembleMoviesInOMDB
//
//  Created by Lucas C Barros on 2024-05-01.
//

import Foundation

protocol NetworkManagerAsyncAwaitProtocol {
    func fetchMovies(withTitle title: String) async throws -> Search
    func fetchMoviePoster(imageURL: String) async throws -> Data
    func fetchMovie(withID movieID: String) async throws -> Movie
}

class NetworkManagerAsyncAwait: NetworkManagerAsyncAwaitProtocol {
    var session: URLSession
    var decoder: JSONDecoder
    
    init(session: URLSession = URLSession.shared,
         decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func fetchMovies(withTitle title: String) async throws -> Search {
        guard let endpoint = URL(string: Constants.endPoint+"&s=\(title)") else { throw FetchError.invalidURL }
        return try await request(url: endpoint)
    }
    
    func fetchMoviePoster(imageURL: String) async throws -> Data {
        guard let imageEndpoint = URL(string: imageURL) else { throw FetchError.invalidURL }
        return try await requestWithoutDecoding(url: imageEndpoint)
    }
    
    func fetchMovie(withID movieID: String) async throws -> Movie {
        guard let movieEndpoint = URL(string: Constants.endPoint+"&i=\(movieID)") else { throw FetchError.invalidURL }
        return try await request(url: movieEndpoint)
    }
    
    private func request<T>(url: URL) async throws -> T where T: Decodable {
        let (data, _) = try await session.data(from: url)
        return try decoder.decode(T.self, from: data)
    }
    
    private func requestWithoutDecoding<T>(url: URL) async throws -> T where T: Decodable {
        let (data, _) = try await session.data(from: url)
        guard let dataResult = data as? T else { throw FetchError.invalidData }
        return dataResult
    }
}

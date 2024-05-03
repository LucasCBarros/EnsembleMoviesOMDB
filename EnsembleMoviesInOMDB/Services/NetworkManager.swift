//
//  NetworkManager.swift
//  ensembleMoviesInOMDB
//
//  Created by Lucas C Barros on 2024-04-30.
//

import UIKit

// MARK: - Protocol to mock
protocol NetworkManagerProtocol {
    func fetchMovies(withTitle title: String, completion: @escaping (Result<Search, FetchError>) -> Void)
    func fetchMoviePoster(imageURL: String, completion: @escaping (Result<Data, FetchError>) -> Void)
}

// MARK: - API calls
class NetworkManager: NetworkManagerProtocol {
    // MARK: Properties
    var session: URLSession
    var decoder: JSONDecoder

    // MARK: init
    init(session: URLSession = URLSession.shared,
         decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    // MARK: FetchMovies
    /// Fetches a Search object containining movies from endpoint
    ///
    /// - Parameters:
    ///     - Title: String contained in the desired movie title
    ///     - Completion: Method to work with server response
    ///
    /// - Returns: A result containing either an Error or Search object
    func fetchMovies(withTitle title: String, completion: @escaping (Result<Search, FetchError>) -> Void) {
        guard let url = URL(string: Constants.endPoint+"&s=\(title)") else { return }

        session.dataTask(with: url) { data, _, error in
            if error != nil {
                completion(.failure(FetchError.invalidResponse))
                return }
            guard let data = data, !data.isEmpty else {
                completion(.failure(FetchError.invalidData))
                return }

            do {
                let search = try JSONDecoder().decode(Search.self, from: data)
                completion(.success(search))
            } catch {
                do {
                    let apiError = try JSONDecoder().decode(APIError.self, from: data)
                    completion(.failure(FetchError.apiError(apiError)))
                } catch {
                    completion(.failure(FetchError.invalidJsonParse))
                }
            }
        }.resume()
    }

    // MARK: FetchMoviePoster
    /// Fetches Data from endpoint for moviePosterImage
    ///
    /// - Parameters:
    ///     - imageURL: String contained url to endpoint
    ///     - Completion: Method to work with server response
    ///
    /// - Returns: A result containing either an Error or Data without Json decoding
    func fetchMoviePoster(imageURL: String, completion: @escaping (Result<Data, FetchError>) -> Void) {
        guard let url = URL(string: imageURL) else { return }

        session.dataTask(with: url) { data, _, error in
            if error != nil {
                completion(.failure(FetchError.invalidResponse))
                return }
            guard let data = data, !data.isEmpty else {
                completion(.failure(FetchError.invalidData))
                return }

            completion(.success(data))
        }.resume()
    }
}

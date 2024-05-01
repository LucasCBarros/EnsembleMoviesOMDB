//
//  NetworkManager.swift
//  ensembleMoviesInOMDB
//
//  Created by Lucas C Barros on 2024-04-30.
//

import UIKit

// Protocol no make it testable
protocol NetworkManagerProtocol {
    func getUser() async throws -> Movie
    func fetchPeople(completion: @escaping (Result<Movie, FetchError>) -> Void)
}

// API calls
class NetworkManager: NetworkManagerProtocol {
    // Singleton
    static let shared = NetworkManager()
    
    // TODO: Fetch movie poster image
    // TODO: Fetch all movies
    
    // TODO: Implement fetching a list of movies
    // TODO: Implement fetching for movie poster
    
    // Fetch method 1 for specific movie
    func fetchPeople(completion: @escaping (Result<Movie, FetchError>) -> Void) {
        guard let url = URL(string: Constants.baseAPIurl+"&t=Batman&y=*") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(FetchError.invalidResponse))
                return }
            guard let data = data else {
                completion(.failure(FetchError.invalidData))
                return }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let movie = try jsonDecoder.decode(Movie.self, from: data)
                print(movie.title)
                completion(.success(movie))
            } catch {
                completion(.failure(FetchError.invalidJsonParse))
            }
        }.resume()
    }
    
    func searchMovieWith(title: String, completion: @escaping (Result<Search, FetchError>) -> Void ) {
        guard let url = URL(string: Constants.baseAPIurl+"&s=\(title)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(FetchError.invalidResponse))
                return }
            guard let data = data else {
                completion(.failure(FetchError.invalidData))
                return }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let search = try jsonDecoder.decode(Search.self, from: data)
                completion(.success(search))
            } catch {
                completion(.failure(FetchError.invalidJsonParse))
            }
        }.resume()
    }
    
    // Fetch method 1 for specific movie
    func getUser() async throws -> Movie {
        guard let url = URL(string: Constants.baseAPIurl) else { throw FetchError.invalidURL }
        
        // Here we apply the await
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Response not nil and status 200 is Successful
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw FetchError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            let movie = try decoder.decode(Movie.self, from: data)
            return movie
        } catch {
            throw FetchError.invalidData
        }
    }
}

enum FetchError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case invalidJsonParse
}

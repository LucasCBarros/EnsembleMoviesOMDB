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
    // MARK: - Manager Config
    // MARK: Properties
    var session: URLSession
    var decoder: JSONDecoder
    
    // MARK: init
    init(session: URLSession = URLSession.shared,
         decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    // MARK: - API Calls
    // MARK: FetchMovies with Title string
    func fetchMovies(withTitle title: String, completion: @escaping (Result<Search, FetchError>) -> Void) {
        guard let url = URL(string: Constants.endPoint+"&s=\(title)") else { return }

        session.dataTask(with: url) { data, response, error in
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
    
    // MARK: FetchMoviePoster with ImageURL string
    func fetchMoviePoster(imageURL: String, completion: @escaping (Result<Data, FetchError>) -> Void) {
        guard let url = URL(string: imageURL) else { return }

        session.dataTask(with: url) { data, response, error in
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

// Extra calls
//extension NetworkManager {
//    // Fetch method 2 for specific movie
//    func getUser() async throws -> Movie {
//        guard let url = URL(string: Constants.endPoint) else { throw FetchError.invalidURL }
//        
//        // Here we apply the await
//        let (data, response) = try await URLSession.shared.data(from: url)
//        
//        // Response not nil and status 200 is Successful
//        guard let response = response as? HTTPURLResponse,
//              response.statusCode == 200 else {
//            throw FetchError.invalidResponse
//        }
//        
//        do {
//            let movie = try JSONDecoder().decode(Movie.self, from: data)
//            return movie
//        } catch {
//            do {
//                let apiError = try JSONDecoder().decode(APIError.self, from: data)
//                throw FetchError.apiError(apiError)
//            } catch {
//                throw FetchError.invalidJsonParse
//            }
//        }
//    }
//        
//        let task = Task {
//            do {
//                movie = try await NetworkManager.shared.getUser()
//                print(movie?.title)
//            } catch FetchError.invalidURL {
//                print("Invalid URL")
//            } catch FetchError.invalidResponse {
//                print("Invalid Response")
//            } catch FetchError.invalidData {
//                print("Invalid data")
//            } catch {
//                print("Unexpected Error")
//            }
//        }
//    }
//}

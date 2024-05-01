//
//  NetworkManager.swift
//  ensembleMoviesInOMDB
//
//  Created by Lucas C Barros on 2024-04-30.
//

import UIKit

// MARK: - Protocol to make it testable
protocol NetworkManagerProtocol {
    func searchMovieWith(title: String, completion: @escaping (Result<Search, FetchError>) -> Void)
    func fetchMoviePoster(imageURL: String, completion: @escaping (Result<Data, FetchError>) -> Void)
     
    // Extra calls
//    func getUser() async throws -> Movie
//    func fetchMovieByID(_ imdbID: String, completion: @escaping (Result<Movie, FetchError>) -> Void)
}

// MARK: - API calls
class NetworkManager: NetworkManagerProtocol {
    // Fetch all movies that title contains the searched string
    func searchMovieWith(title: String, completion: @escaping (Result<Search, FetchError>) -> Void) {
        guard let url = URL(string: Constants.baseAPIurl+"&s=\(title)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(FetchError.invalidResponse))
                return }
            guard let data = data else {
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
    
    // Fetch image from imageURL
    func fetchMoviePoster(imageURL: String, completion: @escaping (Result<Data, FetchError>) -> Void) {
        guard let url = URL(string: imageURL) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(FetchError.invalidResponse))
                return }
            guard let data = data else {
                completion(.failure(FetchError.invalidData))
                return }
            
            completion(.success(data))
        }.resume()
    }
}

// Extra calls
extension NetworkManager {
    // Fetch method 1 for specific movie
    func fetchMovieByID(_ imdbID: String, completion: @escaping (Result<Movie, FetchError>) -> Void) {
        guard let url = URL(string: Constants.baseAPIurl+"&i=\(imdbID)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(FetchError.invalidResponse))
                return }
            guard let data = data else {
                completion(.failure(FetchError.invalidData))
                return }
            
            do {
                let movie = try JSONDecoder().decode(Movie.self, from: data)
                completion(.success(movie))
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
    
    // Fetch method 2 for specific movie
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
            let movie = try JSONDecoder().decode(Movie.self, from: data)
            return movie
        } catch {
            do {
                let apiError = try JSONDecoder().decode(APIError.self, from: data)
                throw FetchError.apiError(apiError)
            } catch {
                throw FetchError.invalidJsonParse
            }
        }
    }
    
    // Func to receive from Method 1 and Method 2 in the ViewModels
//    func method1and2() {
//        
//        NetworkManager.shared.fetch { response in
//            switch response {
//            case .success(let movie):
//                self.movie = movie
//                print("movie = ", movie)
//            case .failure(let error):
//                switch error {
//                case .invalidData:
//                    print("Invalid data")
//                case .invalidURL:
//                    print("Invalid url")
//                case .invalidResponse:
//                    print("Invalid response")
//                case .invalidJsonParse:
//                    print("Invalid Json Parse")
//                }
//            }
//        }
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
}

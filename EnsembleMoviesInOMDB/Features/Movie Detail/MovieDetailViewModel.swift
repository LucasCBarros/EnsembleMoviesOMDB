//
//  MovieDetailViewModel.swift
//  EnsembleMoviesInOMDB
//
//  Created by Lucas C Barros on 2024-04-30.
//

import UIKit

// MARK: Movie Detail Delegate
protocol MovieDetailViewControllerDelegate {
    func updateImageView(with imageData: Data)
    func alertError(title: String, description: String)
}

protocol MovieDetailViewModelProtocol {
    var movie: Movie? { get set }
    var moviePoster: UIImage? { get set }
    var delegate: MovieDetailViewControllerDelegate? { get set }
    
    func fetchMoviePoster()
}

// MARK: Business logic for Movie Detail
class MovieDetailViewModel: MovieDetailViewModelProtocol {
    // MARK: Properties
    var movie: Movie?
    var moviePoster: UIImage?
    var delegate: MovieDetailViewControllerDelegate?
    
    var networkManager: NetworkManagerProtocol? = NetworkManager()
    
    // MARK: Init
    init(movie: Movie? = nil,
         moviePoster: UIImage? = nil,
         delegate: MovieDetailViewControllerDelegate? = nil,
         networkManager: NetworkManagerProtocol? = NetworkManager()) {
        self.movie = movie
        self.moviePoster = moviePoster
        self.delegate = delegate
        self.networkManager = networkManager
    }
    
    // MARK: Methods
    func fetchMoviePoster() {
        guard let posterURL = movie?.poster else { return }
//        Task {
//            do {
//                let imageData = try await networkManager?.fetchMoviePoster(imageURL: posterURL)
//                guard let image = imageData else { return }
//                self.updateViewWithImage(image)
//            } catch let error {
//                guard let fetchError = error as? FetchError else {
//                    self.updateViewWithError(FetchError.apiError(APIError(response: "Unexpected Error", error: "Unexpected Error")))
//                    return
//                }
//                self.updateViewWithError(fetchError)
//            }
//        }
    }
    
    func updateViewWithImage(_ imageData: Data) {
        // Update views in main thread
        DispatchQueue.main.async {
            self.delegate?.updateImageView(with: imageData)
        }
    }
    
    func updateViewWithError(_ error: FetchError) {
        // Update views in main thread
        DispatchQueue.main.async {
            self.delegate?.alertError(title: "Ops! Unfortunate error:",
                                      description: error.description())
        }
    }
}

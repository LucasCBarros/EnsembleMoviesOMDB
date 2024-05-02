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
        
        networkManager?.fetchMoviePoster(imageURL: posterURL, completion: { response in
            switch response {
            case .success(let imageData):
                self.updateViewWithImage(imageData)
            case .failure(let error):
                self.updateViewWithError(error)
            }
        })
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

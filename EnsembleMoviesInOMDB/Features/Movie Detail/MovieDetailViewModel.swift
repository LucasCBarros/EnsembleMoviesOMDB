//
//  MovieDetailViewModel.swift
//  EnsembleMoviesInOMDB
//
//  Created by Lucas C Barros on 2024-04-30.
//

import UIKit

// MARK: Movie Detail Delegate
protocol MovieDetailViewControllerDelegate: AnyObject {
    func updateImageView(with imageData: Data, and backgroundImageData: Data)
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
    weak var delegate: MovieDetailViewControllerDelegate?

    var networkManager: NetworkManagerProtocol

    // MARK: Init
    init(movie: Movie? = nil,
         moviePoster: UIImage? = nil,
         delegate: MovieDetailViewControllerDelegate? = nil,
         networkManager: NetworkManagerProtocol) {
        self.movie = movie
        self.moviePoster = moviePoster
        self.delegate = delegate
        self.networkManager = networkManager
    }

    // MARK: Methods
    func fetchMoviePoster() {
        guard let posterURL = movie?.poster else { return }
        var imageFetchedData: Data?
        var backgroundFetchedData: Data?
        var errorFetched: FetchError?

        let group = DispatchGroup()
        
        group.enter()
        networkManager.fetchMoviePoster(imageURL: posterURL, completion: { response in
            switch response {
            case .success(let imageData):
                imageFetchedData = imageData
                group.leave()
            case .failure(let error):
                errorFetched = error
                group.leave()
            }
        })
        
        group.enter()
        networkManager.fetchBackgroundImage(completion: { response in
            switch response {
            case .success(let imageData):
                backgroundFetchedData = imageData
                group.leave()
            case .failure(let error):
                errorFetched = error
                group.leave()
            }
        })
        
        group.notify(queue: .main) {
            if let image = imageFetchedData,
               let background = backgroundFetchedData,
               errorFetched == nil {
                self.updateViewWithImage(image, and: background)
            } else {
                self.updateViewWithError(errorFetched ?? FetchError.invalidData)
            }
        }
    }

    func updateViewWithImage(_ imageData: Data, and backgroundImageData: Data) {
        // Update views in main thread
        DispatchQueue.main.async {
            self.delegate?.updateImageView(with: imageData, and: backgroundImageData)
        }
    }

    func updateViewWithError(_ error: FetchError) {
        // Update views in main thread
        DispatchQueue.main.async {
            self.delegate?.alertError(title: "Ops! Unfortunate error:",
                                      description: error.description)
        }
    }
}

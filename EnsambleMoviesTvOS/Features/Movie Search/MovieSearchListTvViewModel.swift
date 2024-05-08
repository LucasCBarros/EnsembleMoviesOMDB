//
//  MovieSearchListTvViewModel.swift
//  EnsambleMoviesTvOS
//
//  Created by Lucas C Barros on 2024-05-07.
//

import UIKit

protocol MovieSearchListTvViewControllerDelegate {
    func updateImageView(with imageData: Data)
    func updateImageView(with movieIndex: Int)
    func updateMovieList()
    func alertError(title: String, description: String)
}

protocol MovieSearchListTvViewModelProtocol {
    var movies: [Movie] { get set }
    var movie: Movie? { get set }
    var moviePoster: UIImage? { get set }
    var searchHistory: [String] { get set }
    var delegate: MovieSearchListTvViewControllerDelegate? { get set }
    
    func fetchMoviePoster(for posterUrl: String)
    func fetchMovies(with title: String)
}

class MovieSearchListTvViewModel: MovieSearchListTvViewModelProtocol {
    // MARK: Properties
    var movies: [Movie]
    var movie: Movie?
    var moviePoster: UIImage?
    var searchHistory: [String] = []
    
    var delegate: MovieSearchListTvViewControllerDelegate?
    var networkManager: NetworkManagerProtocol? = NetworkManager()
    
    // MARK: Init
    init(movies: [Movie] = [],
         movie: Movie? = nil,
         moviePoster: UIImage? = nil,
         delegate: MovieSearchListTvViewControllerDelegate? = nil,
         networkManager: NetworkManagerProtocol? = NetworkManager()) {
        self.movies = movies
        self.movie = movie
        self.moviePoster = moviePoster
        self.delegate = delegate
        self.networkManager = networkManager
    }
    
    // MARK: Methods
    func fetchMoviePoster(for posterURL: String) {
        //        let posterURL = "https://img.omdbapi.com/?apikey=36d78389&i=tt0096895"
        //        guard let posterURL = movie?.poster else { return }
        
        networkManager?.fetchMoviePoster(imageURL: posterURL, completion: { response in
            switch response {
            case .success(let imageData):
                self.updateViewWithImage(imageData)
            case .failure(let error):
                self.updateViewWithError(error)
            }
        })
    }
    
    func updateMoviePoster(for posterURL: String, movieIndex: Int) {
        //        let posterURL = "https://img.omdbapi.com/?apikey=36d78389&i=tt0096895"
        //        guard let posterURL = movie?.poster else { return }
        
        networkManager?.fetchMoviePoster(imageURL: posterURL, completion: { response in
            switch response {
            case .success(let imageData):
                self.movies[movieIndex].posterImage = imageData
                self.updateTableViewWith(self.movies)
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
                                      description: error.description)
        }
    }
    
    // MARK: Methods
    // Fetch all movies containing the text
    func fetchMovies(with title: String) {
        if title.isEmpty {
            delegate?.alertError(title: "Invalid empty search",
                                 description: "Can't search an blank title!")
        } else if title.count < 3 {
            delegate?.alertError(title: "Invalid lacking information",
                                 description: "Need more than 3 characters from the title!")
        }
        networkManager?.fetchMovies(withTitle: title, completion: { response in
            switch response {
            case .success(let search):
                self.updateTableViewWith(search.movies)
                self.fetchMoviePosters(for: search.movies)
            case .failure(let error):
                self.updateViewWithError(error)
            }
        })
    }
    
    func fetchMoviePosters(for movies: [Movie]) {
        for index in 0..<movies.count {
            self.updateMoviePoster(for: movies[index].poster, movieIndex: index)
        }
    }
    
    func updateTableViewWith(_ movies: [Movie]) {
        self.movies = movies
        
        // Update views in main thread
        DispatchQueue.main.async {
            self.delegate?.updateMovieList()
        }
    }
    
    func updateViewWithError(_ error: Error) {
        // Update views in main thread
        DispatchQueue.main.async {
            guard let error = error as? FetchError else {
                self.delegate?.alertError(title: "Ops! Unfortunate error:",
                                          description: error.localizedDescription)
                return
            }
            self.delegate?.alertError(title: "Ops! Unfortunate error:",
                                      description: error.description)
        }
    }
}

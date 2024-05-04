//
//  MovieSearchListViewModel.swift
//  EnsembleMoviesInOMDB
//
//  Created by Lucas C Barros on 2024-04-30.
//

import UIKit

protocol MovieSearchListDelegate: AnyObject {
    func updateMovieList()
    func alertError(title: String, description: String)
}

protocol MovieSearchListViewModelProtocol {
    var movies: [Movie] { get set }
    var delegate: MovieSearchListDelegate? { get set }

    func fetchMovies(with title: String)
    func navigateToMovieDetail(with movie: Movie, navigation: UINavigationController?)
}

// MARK: Business logic for Movie Search View Controller
class MovieSearchListViewModel: MovieSearchListViewModelProtocol {
    // MARK: Properties
    var movies: [Movie]
    weak var delegate: MovieSearchListDelegate?
    var networkManager: NetworkManagerProtocol

    // MARK: Init
    init(movies: [Movie] = [],
         delegate: MovieSearchListDelegate? = nil,
         networkManager: NetworkManagerProtocol) {
        self.movies = movies
        self.delegate = delegate
        self.networkManager = networkManager
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
        networkManager.fetchMovies(withTitle: title, completion: { response in
            switch response {
            case .success(let search):
                self.updateTableViewWith(search.movies)
            case .failure(let error):
                self.updateViewWithError(error)
            }
        })
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

    // MARK: Navigation
    func navigateToMovieDetail(with movie: Movie, navigation: UINavigationController?) {
        let viewModel = MovieDetailViewModel(movie: movie, networkManager: networkManager)
        let viewController = MovieDetailViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        navigation?.pushViewController(viewController, animated: true)
    }
}

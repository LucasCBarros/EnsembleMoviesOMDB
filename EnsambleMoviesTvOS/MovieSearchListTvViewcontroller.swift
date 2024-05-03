//
//  MovieSearchListTvViewcontroller.swift
//  EnsambleMoviesTvOS
//
//  Created by Lucas C Barros on 2024-05-03.
//

import UIKit
import QuickUIKitDevTools

class MovieSearchListTvViewcontroller: UIViewController {
    
    // MARK: Views
    var movieListContainerView = UIView()
    var searchTextField = UITextField()
    var searchButton = UIButton()
    var searchHistoryTableView = UITableView()
    
    var movieDetailContainerView = UIView()
    var moviePosterImage = UIImageView()
    var movieTitle = UILabel()
    var movieReleaseDate = UILabel()

    // MARK: Properties
    let viewModel: MainMenuViewModelProtocol = MainMenuViewModel()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        self.view.backgroundColor = .systemOrange
    }
    // MARK: Actions
    @objc func tapSearchButton() {
        guard let searchText = searchTextField.text else { return }
        viewModel.fetchMovies(with: searchText)
    }
}

// MARK: Setup UI
extension MovieSearchListTvViewcontroller: ViewCodable {
    func addHierarchy() {
        self.view.addSubviews([movieListContainerView,
                              movieDetailContainerView])
        
        movieListContainerView.addSubviews([searchTextField,
                                              searchButton,
                                             searchHistoryTableView])
        
        movieDetailContainerView.addSubviews([movieTitle,
                                              moviePosterImage,
                                             movieReleaseDate])
    }
    
    func addConstraints() {
        // Left side
        movieListContainerView
            .topToSuperview()
            .leadingToSuperview()
            .bottomToSuperview()
            .widthTo(self.view.frame.width/3)
        
        searchTextField
            .topToSuperview(25)
            .leadingToSuperview(25)
            .heightTo(100)
            .widthTo(self.view.frame.width/5)
            .backgroundColor = .systemGreen
                                              
        searchButton
            .topToTop(of: searchTextField)
            .leadingToTrailing(of: searchTextField, margin: 25)
            .heightOf(searchTextField)
            .trailingToSuperview(25)
            .backgroundColor = .magenta
                                             
        searchHistoryTableView
            .topToBottom(of: searchTextField, margin: 25)
            .widthToSuperview(-50)
            .bottomToSuperview()
            .centerHorizontalToSuperView()
            .backgroundColor = .systemYellow
        
        // Right side
        movieDetailContainerView
            .topToSuperview()
            .trailingToSuperview()
            .bottomToSuperview()
            .leadingToTrailing(of: movieListContainerView)
        
        movieTitle
            .topToSuperview(self.view.frame.height/5)
            .widthToSuperview()
            
        moviePosterImage
            .widthToSuperview(-400)
            .topToBottom(of: movieTitle, margin: 30)
            .centerHorizontalToSuperView()
            .heightTo(self.view.frame.height/2)
        
       movieReleaseDate
            .widthToSuperview()
            .topToBottom(of: moviePosterImage, margin: 30)

    }
    
    func additionalConfig() {
        movieListContainerView.backgroundColor = .systemRed
        movieDetailContainerView.backgroundColor = .systemBlue
        
        // Left
        searchHistoryTableView.dataSource = self
        searchHistoryTableView.delegate = self
        
        searchTextField.placeholder = "Movie title"
        searchTextField.layer.cornerRadius = 15
        
        searchButton.setTitle("Search", for: .normal)
        searchButton.addTarget(self, action: #selector(tapSearchButton), for: .touchUpInside)
        searchButton.layer.cornerRadius = 15
        
        // Right
        movieTitle.font = .systemFont(ofSize: 84, weight: .heavy)
        movieTitle.textAlignment = .center
        guard let title = viewModel.movie?.title else { return }
        movieTitle.text = title
        
        moviePosterImage.image = UIImage(systemName: "star")
        viewModel.fetchMoviePoster()
        guard let releaseDate = viewModel.movie?.released else { return }
        movieReleaseDate.text = "Released in: \(releaseDate)"
        
        movieReleaseDate.font = .systemFont(ofSize: 60, weight: .light)
        movieReleaseDate.textAlignment = .center
    }
}

extension MovieSearchListTvViewcontroller: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Movie number \(indexPath.row)"
        return cell
    }
}

extension MovieSearchListTvViewcontroller: MainMenuViewControllerDelegate {
    func updateImageView(with imageData: Data) {
        self.moviePosterImage.image = UIImage(data: imageData)
    }

    func alertError(title: String, description: String) {
        popAlert(title: title, message: description)
    }
    
    func updateMovieList() {
        self.searchHistoryTableView.reloadData()
    }
}
//
//protocol MainMenuViewControllerDelegate {
//    func updateImageView(with imageData: Data)
//    func updateMovieList()
//    func alertError(title: String, description: String)
//}
//
//protocol MainMenuViewModelProtocol {
//    var movies: [Movie] { get set }
//    var movie: Movie? { get set }
//    var moviePoster: UIImage? { get set }
//    var delegate: MainMenuViewControllerDelegate? { get set }
//
//    func fetchMoviePoster()
//    func fetchMovies(with title: String)
//}
//
//class MainMenuViewModel: MainMenuViewModelProtocol {
//    // MARK: Properties
//    var movies: [Movie]
//    var movie: Movie?
//    var moviePoster: UIImage?
//
//    var delegate: MainMenuViewControllerDelegate?
//    var networkManager: NetworkManagerProtocol? = NetworkManager()
//
//    // MARK: Init
//    init(movies: [Movie] = [],
//         movie: Movie? = nil,
//         moviePoster: UIImage? = nil,
//         delegate: MainMenuViewControllerDelegate? = nil,
//         networkManager: NetworkManagerProtocol? = NetworkManager()) {
//        self.movies = movies
//        self.movie = movie
//        self.moviePoster = moviePoster
//        self.delegate = delegate
//        self.networkManager = networkManager
//    }
//
//    // MARK: Methods
//    func fetchMoviePoster() {
//        let posterURL = "https://img.omdbapi.com/?apikey=36d78389&i=tt0096895"
////        guard let posterURL = movie?.poster else { return }
//
//        networkManager?.fetchMoviePoster(imageURL: posterURL, completion: { response in
//            switch response {
//            case .success(let imageData):
//                self.updateViewWithImage(imageData)
//            case .failure(let error):
//                self.updateViewWithError(error)
//            }
//        })
//    }
//
//    func updateViewWithImage(_ imageData: Data) {
//        // Update views in main thread
//        DispatchQueue.main.async {
//            self.delegate?.updateImageView(with: imageData)
//        }
//    }
//
//    func updateViewWithError(_ error: FetchError) {
//        // Update views in main thread
//        DispatchQueue.main.async {
//            self.delegate?.alertError(title: "Ops! Unfortunate error:",
//                                      description: error.description)
//        }
//    }
//
//    // MARK: Methods
//    // Fetch all movies containing the text
//    func fetchMovies(with title: String) {
//        if title.isEmpty {
//            delegate?.alertError(title: "Invalid empty search",
//                                 description: "Can't search an blank title!")
//        } else if title.count < 3 {
//            delegate?.alertError(title: "Invalid lacking information",
//                                 description: "Need more than 3 characters from the title!")
//        }
//        networkManager?.fetchMovies(withTitle: title, completion: { response in
//            switch response {
//            case .success(let search):
//                self.updateTableViewWith(search.movies)
//            case .failure(let error):
//                self.updateViewWithError(error)
//            }
//        })
//    }
//
//    func updateTableViewWith(_ movies: [Movie]) {
//        self.movies = movies
//
//        // Update views in main thread
//        DispatchQueue.main.async {
//            self.delegate?.updateMovieList()
//        }
//    }
//
//    func updateViewWithError(_ error: Error) {
//        // Update views in main thread
//        DispatchQueue.main.async {
//            guard let error = error as? FetchError else {
//                self.delegate?.alertError(title: "Ops! Unfortunate error:",
//                                          description: error.localizedDescription)
//                return
//            }
//            self.delegate?.alertError(title: "Ops! Unfortunate error:",
//                                      description: error.description)
//        }
//    }
//}

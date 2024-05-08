//
//  MovieSearchListTvViewcontroller.swift
//  EnsambleMoviesTvOS
//
//  Created by Lucas C Barros on 2024-05-03.
//

import UIKit
import QuickUIKitDevTools

class MovieSearchListTvViewcontroller: UIViewController {
    
    // MARK: - Views
    // MARK: Left movie searh
    var movieListContainerView = UIView()
    var searchTextField = UITextField()
    var searchHistoryTableView = UITableView()
    
    // MARK: Right selection & Movie details
    var movieSelectionContainerView = UIView()
    
    // MARK: Top Right Movie details
    var moviePosterImage = UIImageView()
    var movieDetailsContainerView = UIView()
    var movieDetailsContainerGradientBackground = GradientView()
    var movieTitle = UILabel()
    var movieReleaseDate = UILabel()
    
    // MARK: Bottom Right Movie collectionView
    private var movieCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 25
        return UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    }()
    
    // MARK: - Properties
    var viewModel: MovieSearchListTvViewModelProtocol = MovieSearchListTvViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchMovies(with: "batman")
        viewModel.delegate = self
        setupUI()
    }
    
    // MARK: Actions
    
}

// MARK: - Setup UI
extension MovieSearchListTvViewcontroller: ViewCodable {
    func addHierarchy() {
        self.view.addSubviews([movieListContainerView,
                               movieSelectionContainerView])
        
        movieListContainerView.addSubviews([searchTextField,
                                            searchHistoryTableView])
        
        movieSelectionContainerView.addSubviews([moviePosterImage,
                                                 movieDetailsContainerView,
                                                 movieCollectionView])
        
        movieDetailsContainerView.addSubviews([movieDetailsContainerGradientBackground,
                                               movieTitle,
                                               movieReleaseDate])
    }
    
    func addConstraints() {
        // Left side
        movieListContainerView
            .topToSuperview()
            .leadingToSuperview()
            .bottomToSuperview()
            .widthTo(self.view.frame.width/5)
        
        searchTextField
            .topToSuperview(25)
            .leadingToSuperview(25)
            .heightTo(50)
            .widthToSuperview(-50)
        
        searchHistoryTableView
            .topToBottom(of: searchTextField, margin: 25)
            .widthToSuperview(-50)
            .bottomToSuperview()
            .centerHorizontalToSuperView()
        
        // Right side
        movieSelectionContainerView
            .topToSuperview()
            .trailingToSuperview()
            .bottomToSuperview()
            .leadingToTrailing(of: movieListContainerView)
        
        moviePosterImage
            .widthToSuperview()
            .topToSuperview()
            .centerHorizontalToSuperView()
            .heightTo((self.view.frame.height/3)*2)
        
        // Top Right side
        movieDetailsContainerView
            .widthToSuperview()
            .topToSuperview()
            .bottomToBottom(of: moviePosterImage)
        
        movieDetailsContainerGradientBackground
            .widthToSuperview()
            .centerHorizontalToSuperView()
            .bottomToSuperview()
            .heightTo(self.view.frame.height/3)
        
        movieTitle
            .widthToSuperview()
            .bottomToTop(of: movieReleaseDate)
        
        movieReleaseDate
            .widthToSuperview()
            .bottomToSuperview(20)
        
        // Bottom Right side
        movieCollectionView
            .widthToSuperview()
            .centerHorizontalToSuperView()
            .heightTo(self.view.frame.height/3)
            .bottomToSuperview()
    }
    
    // MARK: additionalConfig
    func additionalConfig() {
        searchHistoryTableView.dataSource = self
        searchHistoryTableView.delegate = self
        
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        movieCollectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        
        searchTextField.placeholder = "Search movies"
        searchTextField.font = .systemFont(ofSize: 30)
        
        searchTextField.addTarget(self, action: #selector(MovieSearchListTvViewcontroller.textFieldDidChange(_:)), for: .editingDidEndOnExit)
        
        // Right
        movieTitle.font = .systemFont(ofSize: 50, weight: .heavy)
        movieTitle.textAlignment = .center
        
        movieTitle.text = "title"
        movieReleaseDate.text = "Released in 2024"
        
        movieReleaseDate.font = .systemFont(ofSize: 25, weight: .light)
        movieReleaseDate.textAlignment = .center
        movieReleaseDate.numberOfLines = 0
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let search = searchTextField.text,
           !search.isEmpty {
            viewModel.searchHistory.append(search)
            viewModel.fetchMovies(with: search)
        }
    }
}

// MARK: - Collection View
extension MovieSearchListTvViewcontroller: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.height, height: collectionView.frame.height/1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.contentView.backgroundColor = .systemBlue
        cell.tag = indexPath.row
        cell.delegate = self
        if let image = viewModel.movies[indexPath.row].posterImage {
            cell.imageView.image = UIImage(data: image)
        }
        cell.titleLabel.text = viewModel.movies[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = viewModel.movies[indexPath.row]
        guard let imageData = selectedMovie.posterImage else { return }
        moviePosterImage.image = UIImage(data: imageData)
        movieTitle.text = selectedMovie.title
        movieReleaseDate.text = selectedMovie.released
    }
}

// MARK: - Table View
extension MovieSearchListTvViewcontroller: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.searchHistory[indexPath.row] //"Movie number \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.fetchMovies(with: viewModel.searchHistory[indexPath.row])
    }
}

// MARK: - Delegate Methods
extension MovieSearchListTvViewcontroller: MovieSearchListTvViewControllerDelegate {
    func updateImageView(with imageData: Data) {
        self.moviePosterImage.image = UIImage(data: imageData)
    }
    
    func alertError(title: String, description: String) {
        popAlert(title: title, message: description)
    }
    
    func updateMovieList() {
        self.movieCollectionView.reloadData()
        self.searchHistoryTableView.reloadData()
        if let firstMovie = viewModel.movies.first,
           let imageData = firstMovie.posterImage {
            moviePosterImage.image = UIImage(data: imageData)
            movieTitle.text = firstMovie.title
            movieReleaseDate.text = firstMovie.released
        }
    }
    
    func updateImageView(with movieIndex: Int) {
        let selectedMovie = viewModel.movies[movieIndex]
        guard let imageData = selectedMovie.posterImage else { return }
        moviePosterImage.image = UIImage(data: imageData)
        movieTitle.text = selectedMovie.title
        movieReleaseDate.text = selectedMovie.released
    }
}

//
//  MovieDetailViewController.swift
//  ensembleMoviesInOMDB
//
//  Created by Lucas C Barros on 2024-04-30.
//

import UIKit
import QuickUIKitDevTools

class MovieDetailViewController: UIViewController {
    // MARK: Views
    let movieTitleLabel = UILabel()
    let movieReleasedDateLabel = UILabel()
    let moviePosterView = UIImageView()
    
    // MARK: Properties
    var viewModel: MovieDetailViewModelProtocol? = MovieDetailViewModel()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.delegate = self
        setupUI()
    }
    // MARK: Actions
}

// MARK: - Delegate Methods
extension MovieDetailViewController: MovieDetailViewControllerDelegate{
    func updateImageView(with imageData: Data) {
        self.moviePosterView.image = UIImage(data: imageData)
    }
    
    func alertError(title: String, description: String) {
        popAlert(title: title, message: description)
    }
}

/// NOTE: I've set all UI for this screen in a single extension as alternative when implementing simple views
// MARK: - Setup UI
extension MovieDetailViewController: ViewCodable {
    // MARK: Hierarchy
    func addHierarchy() {
        self.view.addSubviews([
            moviePosterView,
            movieTitleLabel,
            movieReleasedDateLabel])
    }
    
    // MARK: Constraints
    func addConstraints() {
        moviePosterView
            .topToSuperview(toSafeArea: true)
            .centerHorizontalToSuperView()
            .widthToSuperview(-50)
        
        movieTitleLabel
            .topToBottom(of: moviePosterView, margin: 15)
            .centerHorizontalToSuperView()
            .widthToSuperview()
        
        movieReleasedDateLabel
            .topToBottom(of: movieTitleLabel)
            .centerHorizontalToSuperView()
            .widthToSuperview()
            .heightTo(30)
    }
    
    // MARK: Configurations
    func additionalConfig() {
        moviePosterView.backgroundColor = .blue
        viewModel?.fetchMoviePoster()
        
        movieTitleLabel.numberOfLines = 0
        movieTitleLabel.textColor = .purple
        movieTitleLabel.textAlignment = .center
        movieTitleLabel.font = .systemFont(ofSize: 24, weight: .heavy)
        
        movieReleasedDateLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        movieReleasedDateLabel.textColor = .orange
        movieReleasedDateLabel.textAlignment = .center
        
        self.title = "Movie Details"
        self.view.backgroundColor = .white
        
        guard let releaseDate = viewModel?.movie?.released else { return }
        movieReleasedDateLabel.text = "Released in: \(releaseDate)"
        
        guard let title = viewModel?.movie?.title else { return }
        movieTitleLabel.text = title
    }
    
    func addAccessibility() {
        movieTitleLabel.accessibilityLabel = "movieTitleLabel"
        movieReleasedDateLabel.accessibilityLabel = "movieReleasedDateLabel"
        moviePosterView.accessibilityLabel = "moviePosterView"
    }
}

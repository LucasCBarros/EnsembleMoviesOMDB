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
    var viewModel: MovieDetailViewModelProtocol

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupUI()
    }

    init(viewModel: MovieDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Actions
    @objc func tapToggleDarkModeFeatureButton() {
        guard let isDarkMode = self.navigationController?.overrideUserInterfaceStyle.rawValue else { return }
        navigationItem.rightBarButtonItem?.title = isDarkMode == 1 ? "Light Mode" : "Dark Mode"
        self.navigationController?.overrideUserInterfaceStyle = isDarkMode == 1 ? .dark : .light
    }
}

// MARK: - Delegate Methods
extension MovieDetailViewController: MovieDetailViewControllerDelegate {
    func updateImageView(with imageData: Data) {
        self.moviePosterView.image = UIImage(data: imageData)
    }

    func alertError(title: String, description: String) {
        popAlert(title: title, message: description)
    }
}

// NOTE: I've set all UI for this screen in a single extension as alternative when implementing simple views
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
        viewModel.fetchMoviePoster()

        movieTitleLabel.numberOfLines = 0
        movieTitleLabel.textAlignment = .center
        movieTitleLabel.font = .systemFont(ofSize: 24, weight: .heavy)

        movieReleasedDateLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        movieReleasedDateLabel.textAlignment = .center

        self.title = "Movie Details"
        self.view.backgroundColor = .systemBackground

        guard let releaseDate = viewModel.movie?.released else { return }
        movieReleasedDateLabel.text = "Released in: \(releaseDate)"

        guard let title = viewModel.movie?.title else { return }
        movieTitleLabel.text = title

        guard let isDarkMode = self.navigationController?.overrideUserInterfaceStyle.rawValue else { return }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: isDarkMode == 1 ? "Dark Mode" : "Light Mode",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(tapToggleDarkModeFeatureButton))
    }

    func addAccessibility() {
        movieTitleLabel.accessibilityLabel = "movieTitleLabel"
        movieReleasedDateLabel.accessibilityLabel = "movieReleasedDateLabel"
        moviePosterView.accessibilityLabel = "moviePosterView"
    }
}

//
//  FavoriteMoviesTvViewController.swift
//  EnsambleMoviesTvOS
//
//  Created by Lucas C Barros on 2024-05-03.
//

import UIKit
import QuickUIKitDevTools

class FavoriteMoviesTvViewController: UIViewController {
    
    // MARK: Views
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
        
        self.view.backgroundColor = .systemPurple
    }
    // MARK: Actions

}

// MARK: Setup UI
extension FavoriteMoviesTvViewController: ViewCodable {
    func addHierarchy() {
        self.view.addSubviews([
                              movieDetailContainerView])
        
        movieDetailContainerView.addSubviews([movieTitle,
                                              moviePosterImage,
                                             movieReleaseDate])
    }
    
    func addConstraints() {
        
        // Right side
        movieDetailContainerView
            .topToSuperview()
            .trailingToSuperview()
            .bottomToSuperview()
            .leadingToSuperview()
        
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
        // Right
        movieTitle.font = .systemFont(ofSize: 84, weight: .heavy)
        movieTitle.textAlignment = .center
        guard let title = viewModel.movie?.title else { return }
        movieTitle.text = title
        
        moviePosterImage.image = UIImage(systemName: "star")
        viewModel.fetchMoviePoster(for: "https://img.omdbapi.com/?apikey=36d78389&i=tt0096895")
        guard let releaseDate = viewModel.movie?.released else { return }
        movieReleaseDate.text = "Released in: \(releaseDate)"
        
        movieReleaseDate.font = .systemFont(ofSize: 60, weight: .light)
        movieReleaseDate.textAlignment = .center
    }
}

extension FavoriteMoviesTvViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Movie number \(indexPath.row)"
        return cell
    }
}

extension FavoriteMoviesTvViewController: MainMenuViewControllerDelegate {
    func updateImageView(with imageData: Data) {
        self.moviePosterImage.image = UIImage(data: imageData)
    }

    func alertError(title: String, description: String) {
        popAlert(title: title, message: description)
    }
    
    func updateMovieList() {
//        self.searchHistoryTableView.reloadData()
    }
}

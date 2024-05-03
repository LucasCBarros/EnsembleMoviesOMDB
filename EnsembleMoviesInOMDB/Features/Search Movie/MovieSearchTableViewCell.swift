//
//  MovieSearchTableViewCell.swift
//  EnsembleMoviesInOMDB
//
//  Created by Lucas C Barros on 2024-05-01.
//

import UIKit
import QuickUIKitDevTools

/// NOTE: The image in the cell is commented to avoid needing to make the call for all images in the list and call it just in the detail instead
/// Left it commented in case having the image in the search view is the requirement
class MovieSearchTableViewCell: UITableViewCell {
    // MARK: Views
    private let movieTitleLabel = UILabel()
    private let movieReleaseDateLabel = UILabel()
//    private let moviePosterImage = UIImageView()
    
    // MARK: Properties
    static let identifier = "MovieSearchTableViewCell"
    
    // MARK: Life Cycle
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    // MARK: Methods
    public func configure(with movie: Movie) {
        movieTitleLabel.text = movie.title
        movieReleaseDateLabel.text = movie.released
//        guard let imageData = movie.posterImage else { return }
//        moviePosterImage.image = UIImage(data: imageData)
    }
}

// MARK: - Setup UI
extension MovieSearchTableViewCell: ViewCodable {
    func addHierarchy() {
        self.addSubviews([
        movieTitleLabel,
        movieReleaseDateLabel,
//        moviePosterImage
        ])
    }
    
    func addConstraints() {
        movieReleaseDateLabel
            .topToBottom(of: movieTitleLabel)
            .leadingToLeading(of: movieTitleLabel)
            .heightTo(20)
            .bottomToSuperview()
        
        movieTitleLabel
            .leadingToSuperview()
            .topToSuperview()
            .heightTo(30)
        
        movieTitleLabel
            .trailingToSuperview()
        
//        movieTitleLabel
//            .trailingToLeading(of: moviePosterImage)
//        
//        moviePosterImage
//            .trailingToSuperview()
//            .topToSuperview()
//            .bottomToSuperview()
//            .widthTo(50)
    }
    
    func additionalConfig() {
        movieTitleLabel.text = "Placeholder Title"
        movieTitleLabel.font = .boldSystemFont(ofSize: 24)
        
        movieReleaseDateLabel.text = "Release Date"
        movieReleaseDateLabel.font = .systemFont(ofSize: 16, weight: .light)
        
//        moviePosterImage.image = UIImage(systemName: "questionmark.square.dashed")
    }
    
    
}

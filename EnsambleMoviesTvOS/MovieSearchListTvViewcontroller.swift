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
    var searchHistoryLabel = UITextField()
    var searchTextField = UITextField()
    var searchHistoryTableView = UITableView()
    
    var movieSelectionContainerView = UIView()
    var moviePosterImage = UIImageView()
    
    var movieDetailsContainerView = UIView()
    var movieDetailsContainerGradientBackground = GradientView()
    var movieDetailsContainerBackground = UIView()
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
//    @objc func tapSearchButton() {
//        guard let searchText = searchTextField.text else { return }
//        viewModel.fetchMovies(with: searchText)
//    }
}

// MARK: Setup UI
extension MovieSearchListTvViewcontroller: ViewCodable {
    func addHierarchy() {
        self.view.addSubviews([movieListContainerView,
                              movieSelectionContainerView])
        
        movieListContainerView.addSubviews([searchHistoryLabel,
            searchTextField,
                                             searchHistoryTableView])
        
        movieSelectionContainerView.addSubviews([
                                              moviePosterImage,
                                                 movieDetailsContainerView,
                                             ])
        
        movieDetailsContainerView.addSubviews([
            movieDetailsContainerGradientBackground,
            movieDetailsContainerBackground,
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

        searchHistoryLabel
            .topToSuperview(25)
            .heightTo(30)
            .widthToSuperview(-50)
            .centerHorizontalToSuperView()
            .backgroundColor = .magenta
        
        searchTextField
            .topToBottom(of: searchHistoryLabel)
            .leadingToSuperview(25)
            .heightTo(50)
            .widthToSuperview(-50)
//            .widthTo(self.view.frame.width/10)
            .backgroundColor = .systemGreen

        searchHistoryTableView
            .topToBottom(of: searchTextField, margin: 25)
            .widthToSuperview(-50)
            .bottomToSuperview()
            .centerHorizontalToSuperView()
            .backgroundColor = .systemYellow

        // Right side
        movieSelectionContainerView
            .topToSuperview()
            .trailingToSuperview()
            .bottomToSuperview()
            .leadingToTrailing(of: movieListContainerView)
            .backgroundColor = .cyan
        
        moviePosterImage
            .widthToSuperview()
            .topToSuperview()
            .centerHorizontalToSuperView()
            .heightTo((self.view.frame.height/3)*2)
            .backgroundColor = .systemPurple
        
        movieDetailsContainerView
            .widthTo(self.view.frame.width/3)
            .leadingToSuperview()
            .topToSuperview()
            .heightOf(moviePosterImage)
        
        movieDetailsContainerGradientBackground
            .widthTo(self.view.frame.width/3)
            .trailingToSuperview()
            .heightToSuperview()
        
//        movieDetailsContainerBackground
//            .widthTo((self.view.frame.width/9)*2)
//            .leadingToSuperview()
//            .heightToSuperview()
//            .backgroundColor = .black
//        movieDetailsContainerBackground.alpha = 0.90
        
        movieTitle
            .widthTo((self.view.frame.width/9)*2)
            .leadingToSuperview()
            .topToSuperview(self.view.frame.height/5)
            
       movieReleaseDate
            .widthTo((self.view.frame.width/9)*2)
            .leadingToSuperview()
            .topToBottom(of: movieTitle, margin: 30)
    }

    func additionalConfig() {
        movieListContainerView.backgroundColor = .systemRed
//        movieDetailsContainerView.backgroundColor = .systemBlue

        // Left
        searchHistoryLabel.text = "Search History"
        searchHistoryLabel.textAlignment = .center
        
        searchHistoryTableView.dataSource = self
        searchHistoryTableView.delegate = self

        searchTextField.placeholder = "Movie title"
//        searchTextField.layer.cornerRadius = 50
        searchTextField.font = .systemFont(ofSize: 30)
        
        // Right
        movieTitle.font = .systemFont(ofSize: 50, weight: .heavy)
        movieTitle.textAlignment = .center
//        guard let title = viewModel.movie?.title else { return }
        movieTitle.text = "title"
        
        moviePosterImage.image = UIImage(systemName: "star")
//        viewModel.fetchMoviePoster()
//        guard let releaseDate = viewModel.movie?.released else { return }
        movieReleaseDate.text = "Released in 2024" //"Released in: \(releaseDate)"
        
        movieReleaseDate.font = .systemFont(ofSize: 50, weight: .light)
        movieReleaseDate.textAlignment = .center
        movieReleaseDate.numberOfLines = 0
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

extension UIView {
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor.clear.cgColor//UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
                
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addGradient() {

        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame.size = self.frame.size
        gradient.colors = [UIColor.red.cgColor,
                           UIColor.blue.withAlphaComponent(0).cgColor] //Or any colors
        self.layer.addSublayer(gradient)

    }
    
    func addGradient2() {
        self.layoutIfNeeded()
        let gradient = CAGradientLayer()

        gradient.frame = self.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor]

        self.layer.insertSublayer(gradient, at: 0)
    }
}

class GradientView: UIView {
    override open class var layerClass: AnyClass {
       return CAGradientLayer.classForCoder()
    }

    init() {
        super.init(frame: CGRect.zero)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [UIColor.black.cgColor,
                                UIColor.clear.cgColor]
//        self.alpha = 0.9
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.colors = [UIColor.black.cgColor,
                                UIColor.darkGray.cgColor,
                                UIColor.gray.cgColor,
                                UIColor.clear.cgColor]
    }
}

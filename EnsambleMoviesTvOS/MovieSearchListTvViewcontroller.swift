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
    var searchHistoryLabel = UITextField()
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
//    var movieCollectionView = UICollectionView(frame: CGRect.zero,
//                                               collectionViewLayout: UICollectionViewLayout.init())
    private var movieCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.itemSize = CGSize(width: 70, height: 70)
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    }()

    // MARK: - Properties
    var viewModel: MainMenuViewModelProtocol = MainMenuViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.delegate = self
//        viewModel.fetchMoviePoster()
        viewModel.fetchMovies(with: "batman")
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
                                              movieCollectionView,
                                             ])
        
        movieDetailsContainerView.addSubviews([
            movieDetailsContainerGradientBackground,
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
        
        // Top Right Z=0
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
        
        /// Top Right Z=1
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
        
        // Bottom Right
        movieCollectionView
            .widthToSuperview(-100)
            .centerHorizontalToSuperView()
            .heightTo(self.view.frame.height/4)
            .bottomToSuperview(50)
            .backgroundColor = .red
    }

    func additionalConfig() {
        movieListContainerView.backgroundColor = .systemRed
//        movieDetailsContainerView.backgroundColor = .systemBlue

        // Left
        searchHistoryLabel.text = "Search History"
        searchHistoryLabel.textAlignment = .center
        
        searchHistoryTableView.dataSource = self
        searchHistoryTableView.delegate = self
        
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        movieCollectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")

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
        
        movieReleaseDate.font = .systemFont(ofSize: 25, weight: .light)
        movieReleaseDate.textAlignment = .center
        movieReleaseDate.numberOfLines = 0
    }
}

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
        if let image = viewModel.movies[indexPath.row].posterImage {
            cell.imageView.image = UIImage(data: image)
        }
        cell.titleLabel.text = viewModel.movies[indexPath.row].title
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
//        return true
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//        
//    }
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
        self.movieCollectionView.reloadData()
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
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.colors = [UIColor.black.cgColor,
                                UIColor.clear.cgColor]
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

class CustomCell: UICollectionViewCell {
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let containerView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubviews([containerView])
        containerView.addSubviews([imageView, titleLabel])
        
        containerView.backgroundColor = .systemGreen
        containerView.layer.borderColor = UIColor.systemPurple.cgColor
        containerView.layer.borderWidth = 5.0
        containerView.layer.cornerRadius = 25
        containerView.sizeToSuperview()
        imageView.sizeToSuperview()
        imageView.image = UIImage(systemName: "star")
        titleLabel.text = "Title"
        titleLabel.textAlignment = .center
        titleLabel.widthToSuperview()
            .bottomToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
            if context.nextFocusedView == self {
                containerView.layer.borderColor = UIColor.white.cgColor
                containerView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//                titleLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            } else {
                containerView.layer.borderColor = UIColor.clear.cgColor
                containerView.transform = CGAffineTransform(scaleX: 1, y: 1)
                titleLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
}

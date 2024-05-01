//
//  MovieDetailViewController.swift
//  ensembleMoviesInOMDB
//
//  Created by Lucas C Barros on 2024-04-30.
//

import UIKit

enum Constants {
    /// OMDB documentation: http://www.omdbapi.com/
    static let baseAPIurl = "https://www.omdbapi.com/?apikey=36d78389"
}

//class MovieViewModel {
//    var movie: Movie?
//    var moviePoster: UIImage?
//    
//    func getMovie() {
//        
//    }
//}

class MovieDetailViewController: UIViewController {
    // MARK: Views
    let searchTextField = UITextField()
    let movieTitle = UILabel()
    let movieReleasedDate = UILabel()
    let searchButton = UIButton()
    let moviePosterView = UIImageView()
    
    // MARK: Properties
    var movie: Movie?
    var shouldSearch: Bool = true
//    var viewModel: MovieViewModel?

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

//        NetworkManager.shared.fetchPeople { response in
//            switch response {
//            case .success(let movie):
//                self.movie = movie
//                print("movie = ", movie)
//            case .failure(let error):
//                switch error {
//                case .invalidData:
//                    print("Invalid data")
//                case .invalidURL:
//                    print("Invalid url")
//                case .invalidResponse:
//                    print("Invalid response")
//                case .invalidJsonParse:
//                    print("Invalid Json Parse")
//                }
//            }
//        }
        
//        let task = Task {
//            do {
//                movie = try await NetworkManager.shared.getUser()
//                print(movie?.title)
//            } catch FetchError.invalidURL {
//                print("Invalid URL")
//            } catch FetchError.invalidResponse {
//                print("Invalid Response")
//            } catch FetchError.invalidData {
//                print("Invalid data")
//            } catch {
//                print("Unexpected Error")
//            }
//        }
    }
    
    // MARK: Actions
    @objc func tapSearchButton() {
        guard let searchText = searchTextField.text,
              !searchText.isEmpty else { return }
        
        NetworkManager.shared.searchMovieWith(title: searchText, completion: { response in
            
        })
    }
    
    @objc func tapToggleSearchFeatureButton() {
        navigationItem.rightBarButtonItem?.title = shouldSearch ? "Search" : "Hide"
        searchButton.isHidden = shouldSearch
        searchTextField.isHidden = shouldSearch
        shouldSearch.toggle()
    }
}

// MARK: Setup UI
extension MovieDetailViewController: ViewCodable {
    func addHierarchy() {
        self.view.addSubviews([
            searchTextField,
            searchButton,
            moviePosterView,
            movieTitle,
            movieReleasedDate])
    }
    
    func addConstraints() {
        searchTextField
            .topToSuperview(100)
            .leadingToSuperview(25)
            .heightTo(30)
        
        searchButton
            .leadingToTrailing(of: searchTextField, margin: 15)
            .trailingToSuperview(25)
            .widthTo(100)
            .topToTop(of: searchTextField)
            .heightOf(searchTextField)
            
        moviePosterView
            .topToBottom(of: searchTextField, margin: 25)
            .centerHorizontalToSuperView()
            .widthToSuperview(-50)
            .heightTo(300)
        
        movieTitle
            .topToBottom(of: moviePosterView, margin: 15)
            .centerHorizontalToSuperView()
            .widthToSuperview()
            .heightTo(50)
        
        movieReleasedDate
            .topToBottom(of: movieTitle)
            .centerHorizontalToSuperView()
            .widthToSuperview()
            .heightTo(30)
        
    }
    
    func additionalConfig() {
        searchTextField.placeholder = "Placeholder"
        searchTextField.textColor = .blue
        searchTextField.autocapitalizationType = .none
        searchTextField.leftViewMode = .always
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        searchTextField.backgroundColor = .white
        searchTextField.textColor = .black
        searchTextField.layer.cornerRadius = 15
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.gray.cgColor
        
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.backgroundColor = .systemBlue
        searchButton.layer.cornerRadius = 5
        searchButton.addTarget(self, action: #selector(tapSearchButton), for: .touchUpInside)
        
        moviePosterView.backgroundColor = .blue
        
        movieTitle.text = "Movie Title"
        movieTitle.textColor = .purple
        movieTitle.textAlignment = .center
        movieTitle.font = .systemFont(ofSize: 24, weight: .heavy)
            
        
        movieReleasedDate.text = "2024"
        movieReleasedDate.font = .systemFont(ofSize: 18, weight: .semibold)
        movieReleasedDate.textColor = .orange
        movieReleasedDate.textAlignment = .center
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hide",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(tapToggleSearchFeatureButton))
        
        self.view.backgroundColor = .white
    }
}

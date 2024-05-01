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
    let movieTitle = UILabel()
    let movieReleasedDate = UILabel()
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
}

// MARK: Setup UI
extension MovieDetailViewController: ViewCodable {
    func addHierarchy() {
        self.view.addSubviews([
            moviePosterView,
            movieTitle,
            movieReleasedDate])
    }
    
    func addConstraints() {
        moviePosterView
            .topToSuperview(toSafeArea: true)
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
        moviePosterView.backgroundColor = .blue
        
        movieTitle.text = movie?.title ?? "Movie Title"
        movieTitle.textColor = .purple
        movieTitle.textAlignment = .center
        movieTitle.font = .systemFont(ofSize: 24, weight: .heavy)
        
        movieReleasedDate.text = movie?.released ?? "2024"
        movieReleasedDate.font = .systemFont(ofSize: 18, weight: .semibold)
        movieReleasedDate.textColor = .orange
        movieReleasedDate.textAlignment = .center
        
        self.title = "Movie Details"
        self.view.backgroundColor = .white
    }
}

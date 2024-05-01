//
//  MovieSearchListViewController.swift
//  ensembleMoviesInOMDB
//
//  Created by Lucas C Barros on 2024-04-30.
//

import UIKit

class MovieSearchListViewController: UIViewController {
    // MARK: Views
    let headerView = UIView()
    let searchTextField = UITextField()
    let searchButton = UIButton()
    
    let movieTableView = UITableView()
    
    // MARK: Properties
    var movies: [Movie] = []
    var shouldSearch: Bool = true
//    var viewModel: MovieViewModel?

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Actions
    @objc func tapSearchButton() {
        guard let searchText = searchTextField.text,
              !searchText.isEmpty else { return }
        
        NetworkManager.shared.searchMovieWith(title: searchText, completion: { response in
            switch response {
            case .success(let search):
                self.movies = search.movies
            case.failure(let error):
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.movieTableView.reloadData()
            }
        })
    }
    
    @objc func tapToggleSearchFeatureButton() {
        
        searchButton.slideY(y: shouldSearch ? -30 : 100)
        searchTextField.slideY(y: shouldSearch ? -30 : 100)
        movieTableView.slideY(y: shouldSearch ? 0 : searchButton.frame.origin.y+30+25)
        
        navigationItem.rightBarButtonItem?.title = shouldSearch ? "Search" : "Hide search"
        shouldSearch.toggle()
    }
}

extension MovieSearchListViewController: ViewCodable {
    func addHierarchy() {
        self.view.addSubviews([
            searchTextField,
            searchButton,
            movieTableView,
            headerView,])
    }
    
    func addConstraints() {
        headerView
            .topToSuperview()
            .bottomToTop(of: searchTextField)
            .widthToSuperview()
            .backgroundColor = .white
        
        searchTextField
            .topToSuperview(toSafeArea: true)
            .leadingToSuperview(25)
            .heightTo(30)
        
        searchButton
            .leadingToTrailing(of: searchTextField, margin: 15)
            .trailingToSuperview(25)
            .widthTo(100)
            .topToTop(of: searchTextField)
            .heightOf(searchTextField)
            
        movieTableView
            .topToBottom(of: searchTextField, margin: 25)
            .centerHorizontalToSuperView()
            .widthToSuperview(-50)
            .bottomToSuperview()
    }
    
    func additionalConfig() {
        searchTextField.placeholder = "Search movie by title"
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
        
        movieTableView.dataSource = self
        movieTableView.delegate = self

        self.title = "Movies list"
        self.navigationController?.navigationBar.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hide search",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(tapToggleSearchFeatureButton))
        
        self.view.backgroundColor = .white
    }
}

extension MovieSearchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = movies[indexPath.row].title // "\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = MovieDetailViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.movie = movies[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

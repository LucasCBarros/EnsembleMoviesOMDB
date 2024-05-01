//
//  MovieSearchListViewController.swift
//  ensembleMoviesInOMDB
//
//  Created by Lucas C Barros on 2024-04-30.
//

import UIKit

class MovieSearchListViewController: UIViewController {
    // MARK: Views
    private let headerView = UIView()
    private let searchTextField = UITextField()
    private let searchButton = UIButton()
    private let movieTableView = UITableView()
    
    // MARK: Properties
    private var viewModel: MovieSearchListViewModelProtocol = MovieSearchListViewModel()
    private var shouldSearch: Bool = true

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupUI()
    }
    
    // MARK: Actions
    @objc func tapSearchButton() {
        guard let searchText = searchTextField.text,
              !searchText.isEmpty else { return }
        viewModel.searchForMovies(with: searchText)
    }
    
    @objc func tapToggleSearchFeatureButton() {
        // Hide search components with animation
        searchButton.hideSlideY(y: shouldSearch ? -30 : 100, shouldHide: shouldSearch)
        searchTextField.hideSlideY(y: shouldSearch ? -30 : 100, shouldHide: shouldSearch)
        movieTableView.hideSlideY(y: shouldSearch ? 0 : searchButton.frame.origin.y+30+25, shouldHide: false)
        
        navigationItem.rightBarButtonItem?.title = shouldSearch ? "Search" : "Hide search"
        shouldSearch.toggle()
    }
}

// MARK: Delegate Methods
extension MovieSearchListViewController: MovieSearchListDelegate {
    func updateMovieList() {
        self.movieTableView.reloadData()
    }
}

// MARK: Setup UI
extension MovieSearchListViewController: ViewCodable {
    func addHierarchy() {
        self.view.addSubviews([
            searchTextField,
            searchButton,
            movieTableView,
            headerView,])
    }
    
    func addConstraints() {
        addNavigationBarConstraints()
        addSearchBarConstraints()
        addTableViewConstraints()
    }
    
    func additionalConfig() {
        additionalSearchBarConfig()
        additionalTableViewConfig()
        additionalNavigationBarConfig()
        self.view.backgroundColor = .white
    }
}

// MARK: Setup SearchBar UI
extension MovieSearchListViewController {
    func addSearchBarConstraints() {
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
    }
    
    func additionalSearchBarConfig() {
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
    }
}

// MARK: Setup tableView UI
extension MovieSearchListViewController {
    func addTableViewConstraints() {
        movieTableView
            .topToBottom(of: searchTextField, margin: 25)
            .centerHorizontalToSuperView()
            .widthToSuperview(-50)
            .bottomToSuperview()
    }
    
    func additionalTableViewConfig() {
        movieTableView.dataSource = self
        movieTableView.delegate = self
    }
}

// MARK: Setup NavigationBar UI
extension MovieSearchListViewController {
    func addNavigationBarConstraints() {
        headerView
            .topToSuperview()
            .bottomToTop(of: searchTextField)
            .widthToSuperview()
            .backgroundColor = .white
    }
    
    func additionalNavigationBarConfig() {
        self.title = "Movies list"
        self.navigationController?.navigationBar.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hide search",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(tapToggleSearchFeatureButton))
    }
}

// MARK: TableView Setup
extension MovieSearchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.movies[indexPath.row].title // "\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let navigation = self.navigationController else { return }
        viewModel.navigateToMovieDetail(with: viewModel.movies[indexPath.row], navigation: navigation)
    }
}

//
//  MovieSearchListViewController.swift
//  ensembleMoviesInOMDB
//
//  Created by Lucas C Barros on 2024-04-30.
//

import QuickUIKitDevTools
import UIKit

class MovieSearchListViewController: UIViewController {
    // MARK: Views
    let headerView = UIView()
    let searchTextField = UITextField()
    let searchButton = UIButton()
    let movieTableView = UITableView()

    // MARK: Properties
    var viewModel: MovieSearchListViewModelProtocol? = MovieSearchListViewModel()
    var shouldSearch: Bool = true
    var withCustomCell: Bool = true

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.delegate = self
        setupUI()
    }

    // MARK: Actions
    @objc func tapSearchButton() {
        guard let searchText = searchTextField.text else { return }
        viewModel?.fetchMovies(with: searchText)
    }

    @objc func tapToggleSearchFeatureButton() {
        // Hide search components with animation
        searchButton.hideSlideY(yAxis: shouldSearch ? -30 : 100, shouldHide: shouldSearch)
        searchTextField.hideSlideY(yAxis: shouldSearch ? -30 : 100, shouldHide: shouldSearch)
        movieTableView.hideSlideY(yAxis: shouldSearch ? 1 : searchButton.frame.origin.y+30+25, shouldHide: false)

        navigationItem.rightBarButtonItem?.title = shouldSearch ? "Search" : "Hide search"
        shouldSearch.toggle()
    }

    @objc func tapCustomCellFeatureButton() {
        navigationItem.leftBarButtonItem?.title = withCustomCell ? "Generic cell" : "Custom cell"
        movieTableView.reloadData()
        withCustomCell.toggle()
    }
}

// MARK: - TableView Setup
extension MovieSearchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.movies.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if withCustomCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieSearchTableViewCell.identifier,
                                                           for: indexPath) as? MovieSearchTableViewCell else {
                fatalError("The tableView could not dequeue a MovieSearchTableViewCell in ViewController")
            }
            guard let movies = viewModel?.movies[indexPath.row] else { return UITableViewCell() }
            cell.configure(with: movies)
            cell.accessibilityLabel = "MovieSearchTableViewCell\(indexPath.row)"
            return cell
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = viewModel?.movies[indexPath.row].title
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let navigation = self.navigationController,
              let movies = viewModel?.movies[indexPath.row] else { return }
        viewModel?.navigateToMovieDetail(with: movies, navigation: navigation)
    }
}

// MARK: - Delegate Methods
extension MovieSearchListViewController: MovieSearchListDelegate {
    func updateMovieList() {
        self.movieTableView.reloadData()
    }

    func alertError(title: String, description: String) {
        popAlert(title: title, message: description)
    }
}

/* NOTE: I've separated each component into a different
 extension to exemplify how to isolate programmatic UI setup in a complex view
 This way we can close the code folding ribbons to view only relevant code */
// MARK: - Setup UI
extension MovieSearchListViewController: ViewCodable {
    func addHierarchy() {
        self.view.addSubviews([
            searchTextField,
            searchButton,
            movieTableView,
            headerView])
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

    func addAccessibility() {
        movieTableView.accessibilityLabel = "movieTableView"
    }
}

// MARK: - Setup SearchBar UI
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

// MARK: - Setup tableView UI
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
        movieTableView.register(MovieSearchTableViewCell.self, forCellReuseIdentifier: "MovieSearchTableViewCell")
    }
}

// MARK: - Setup NavigationBar UI
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Custom cell",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(tapCustomCellFeatureButton))
    }
}

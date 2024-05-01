//
//  MovieSearchViewController.swift
//  ensembleMoviesInOMDB
//
//  Created by Lucas C Barros on 2024-04-30.
//

import UIKit

class MovieSearchViewController: UIViewController {
    // MARK: Views
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
            
        })
    }
    
    @objc func tapToggleSearchFeatureButton() {
        navigationItem.rightBarButtonItem?.title = shouldSearch ? "Search" : "Hide"
        searchButton.isHidden = shouldSearch
        searchTextField.isHidden = shouldSearch
        shouldSearch.toggle()
    }
}

extension MovieSearchViewController: ViewCodable {
    func addHierarchy() {
        self.view.addSubviews([
            searchTextField,
            searchButton,
        movieTableView])
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
            
        movieTableView
            .topToBottom(of: searchTextField, margin: 25)
            .centerHorizontalToSuperView()
            .widthToSuperview(-50)
            .heightTo(300)
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
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hide",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(tapToggleSearchFeatureButton))
        
        self.view.backgroundColor = .white
    }
}

extension MovieSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)"
        cell.backgroundColor = .systemMint
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = MovieDetailViewController()
        viewController.modalPresentationStyle = .fullScreen
//        viewController.movie = movies[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

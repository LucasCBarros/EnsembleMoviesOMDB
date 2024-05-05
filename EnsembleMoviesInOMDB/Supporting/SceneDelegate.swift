//
//  SceneDelegate.swift
//  ensembleMoviesInOMDB
//
//  Created by Lucas C Barros on 2024-04-30.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        // init programmatic view
        let networkManager = NetworkManager()
        let viewModel = MovieSearchListViewModel(networkManager: networkManager)
        let viewController = MovieSearchListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.overrideUserInterfaceStyle = .light
        window.rootViewController = navigationController

        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

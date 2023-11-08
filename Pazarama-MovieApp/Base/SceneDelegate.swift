//
//  SceneDelegate.swift
//  Pazarama-MovieApp
//
//  Created by Kaan Yıldırım on 4.11.2023.
//

import UIKit
import Kingfisher

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
        ]
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationBarAppearance.backgroundColor = .black
        
        window = UIWindow(windowScene: scene)
        let movieService: MovieService = NetworkManager()
        let viewModel = HomeViewModel(movieService: movieService)
        let navigationController = UINavigationController(rootViewController: HomeView(viewModel: viewModel))
        
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.standardAppearance = navigationBarAppearance
        navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}


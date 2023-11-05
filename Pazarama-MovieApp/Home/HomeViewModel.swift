//
//  HomeViewModel.swift
//  Pazarama-MovieApp
//
//  Created by Kaan Yıldırım on 5.11.2023.
//

import Foundation

protocol HomeViewModelInterface {
    var view: HomeView? { get }
    func viewDidLoad()
}

class HomeViewModel: HomeViewModelInterface {
    var view: HomeView?
    
    // Dependency Injection
    private let movieService: MovieService
    
    // Delegate Pattern
    weak var output: HomeViewModelOutPut?
    
    init(movieService: MovieService) {
        self.movieService = movieService
    }
    
    func viewDidLoad() {
        view?.prepare()
    }
    
    func fetchSearchMovies(searchText: String) {
        movieService.getSearchMovies(search: searchText) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.output?.getMovies(movies)
                // print(movies)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}

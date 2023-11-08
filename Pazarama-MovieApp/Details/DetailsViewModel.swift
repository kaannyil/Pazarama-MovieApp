//
//  DetailsViewModel.swift
//  Pazarama-MovieApp
//
//  Created by Kaan Yıldırım on 5.11.2023.
//

import Foundation

protocol DetailsViewModelInterface {
    var view: DetailsView? { get }
    func viewDidLoad()
}

class DetailsViewModel: DetailsViewModelInterface {
    
    var view: DetailsView?
    private let movieService: MovieService
    weak var output: DetailsViewModelOutPut?
    
    init(movieService: MovieService) {
        self.movieService = movieService
    }
    
    func viewDidLoad() {
        view?.prepare()
    }
    
    func fetchMovieDetails(_ imdbID: String) {
        movieService.getMovieDetails(imdbID: imdbID) { [weak self] result in
            self?.changeLoading(isLoading: false)
            
            switch result {
            case .success(let movieDetails):
                self?.output?.getMovieDetails(movieDetails)
            case .failure(let error):
                self?.output?.getError(error)
            }
        }
    }
    
    func changeLoading(isLoading: Bool) {
        output?.changeLoading(isLoading)
    }
}

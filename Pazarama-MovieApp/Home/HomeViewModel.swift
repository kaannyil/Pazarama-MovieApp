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
    
    private let movieService: MovieService
    weak var output: HomeViewModelOutPut?
    
    private var totalResult: Double = 0
    private var currentPage = 1
    var isPaging = true
    
    init(movieService: MovieService) {
        self.movieService = movieService
    }
    
    func viewDidLoad() {
        view?.prepare()
    }
    
    func fetchSearchMovies(_ searchText: String) {
        movieService.getSearchMovies(search: searchText, page: String(currentPage)) { [weak self] result in
            self?.changeLoading(isLoading: false)
            
            switch result {
            case .success(let movies):
                self?.output?.getMovies(movies)
                self?.output?.changeNoMovieScreen(false)
                
                self?.totalResult = Double(movies.totalResults) ?? 0
            case .failure(let error):
                self?.output?.changeNoMovieScreen(true)
                self?.output?.getError(error)
            }
        }
    }
    
    func changeLoading(isLoading: Bool) {
        output?.changeLoading(isLoading)
    }
    
    func changePagination(isPaging: Bool) {
        output?.changePagination(isPaging)
    }
    
    func newSearching() {
        currentPage = 1
    }
    
    func scrollViewDidScroll(offsetY: CGFloat, contentHeight: CGFloat, height: CGFloat) {
        if offsetY > contentHeight - (2 * height), isPaging {
            output?.changePagination(true)
        }
    }
    
    func loadNextValues(_ text: String) {
        isPaging = false
        
        guard totalResult != 0 else {
            return
        }
        
        let divideTotalResult = Double(totalResult / 10)
        
        if divideTotalResult > Double(currentPage) {
            currentPage += 1
            fetchSearchMovies(text)
            
            print("Current Page: \(currentPage)")
        }
    }
}

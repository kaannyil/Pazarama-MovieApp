//
//  Pazarama_MovieAppTests.swift
//  Pazarama-MovieAppTests
//
//  Created by Kaan Yıldırım on 4.11.2023.
//

import XCTest
@testable import Pazarama_MovieApp

final class Pazarama_MovieAppTests: XCTestCase {

    private var movieService: MockMovieService!
    private var homeViewModel: HomeViewModel!
    private var homeOutPut: MockHomeViewModelOutPut!
    private var detailsViewModel: DetailsViewModel!
    private var detailsOutPut: MockDetailsViewModelOutPut!
    
    override func setUpWithError() throws {
        movieService = MockMovieService()
        
        homeViewModel = HomeViewModel(movieService: movieService)
        detailsViewModel = DetailsViewModel(movieService: movieService)
        
        homeOutPut = MockHomeViewModelOutPut()
        detailsOutPut = MockDetailsViewModelOutPut()
        
        homeViewModel.output = homeOutPut
        detailsViewModel.output = detailsOutPut
    }

    override func tearDownWithError() throws {
        movieService        = nil
        homeViewModel       = nil
        homeOutPut          = nil
        detailsViewModel    = nil
        detailsOutPut       = nil
    }

    // MARK: - Success Tests
    func testGetMovies_whenGetMoviesAPISuccess_showMovies() throws {
        let mockMovies: SearchMovies =
            .init(search: [
                Search(title: "Test Film", year: "2000", imdbID: "tt0000001", poster: "https://m.media-amazon.com/images/M/MV5BOTY4YjI2N2MtYmFlMC00ZjcyLTg3YjEtMDQyM2ZjYzQ5YWFkXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_SX300.jpg"),
                Search(title: "Test Film2", year: "2001", imdbID: "tt0000002", poster: "https://m.media-amazon.com/images/M/MV5BOTY4YjI2N2MtYmFlMC00ZjcyLTg3YjEtMDQyM2ZjYzQ5YWFkXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_SX300.jpg"),
                Search(title: "Test Film3", year: "2002", imdbID: "tt0000003", poster: "https://m.media-amazon.com/images/M/MV5BOTY4YjI2N2MtYmFlMC00ZjcyLTg3YjEtMDQyM2ZjYzQ5YWFkXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_SX300.jpg"),
            ], totalResults: "3", response: "True")
        
        movieService.getSearchMoviesMockResult = ("Test", "1", .success(mockMovies))
        homeViewModel.fetchSearchMovies("Test")
        
        XCTAssertEqual(homeOutPut.movies.search.count, 3)
        XCTAssertEqual(homeOutPut.movies.search[0].title, "Test Film")
        XCTAssertEqual(homeOutPut.movies.search[1].year, "2001")
        XCTAssertEqual(homeOutPut.movies.search[2].imdbID, "tt0000003")
    }
    
    func testGetMovieDetails_whenGetMovieDetailsAPISuccess_showMovieDetails() throws {
        let mockMovieDetails: MovieDetails =
            .init(title: "Test Film3", year: "2002", director: "Kaan Yildirim", actors: "Sezgin Ozturk", country: "Turkey", poster: "https://m.media-amazon.com/images/M/MV5BOTY4YjI2N2MtYmFlMC00ZjcyLTg3YjEtMDQyM2ZjYzQ5YWFkXkEyXkFqcGdeQXVyMTQxNzMzNDI@._V1_SX300.jpg",
                  imdbRating: "8.9", imdbID: "tt0000003")
        
        movieService.getMovieDetailsMockResult = ("tt0000003", .success(mockMovieDetails))
        detailsViewModel.fetchMovieDetails("tt0000003")
        
        XCTAssertEqual(detailsOutPut.movieDetails.title, "Test Film3")
        XCTAssertEqual(detailsOutPut.movieDetails.actors, "Sezgin Ozturk")
        XCTAssertEqual(detailsOutPut.movieDetails.imdbID, "tt0000003")
    }
    
    // MARK: - Failure Tests
    func testGetMovies_whenGetMoviesAPIFailure_showMoviesError() throws {
        let expectedError = ErrorTypes.parsingError
        let expectedString: String = "Test"
        
        movieService.getSearchMoviesMockResult = (expectedString, "1", .failure(.parsingError))
        homeViewModel.fetchSearchMovies(expectedString)
        
        XCTAssertEqual(homeOutPut.movieError, expectedError)
    }
    
    func testGetMovieDetails_whenGetMovieDetailsAPIFailure_showMovieDetailsError() throws {
        let expectedError = ErrorTypes.generalError
        let expectedID: String = "tt0000003"
        
        movieService.getMovieDetailsMockResult = (expectedID, .failure(.generalError))
        detailsViewModel.fetchMovieDetails(expectedID)
        
        XCTAssertEqual(detailsOutPut.movieError, expectedError)
    }
}

// MARK: - Mock Classes
private class MockMovieService: MovieService {
    var getSearchMoviesMockResult: (search: String, page: String, Result<Pazarama_MovieApp.SearchMovies, Pazarama_MovieApp.ErrorTypes>)?
    var getMovieDetailsMockResult: (imdbID: String, Result<Pazarama_MovieApp.MovieDetails, Pazarama_MovieApp.ErrorTypes>)?
    
    func getSearchMovies(search: String, page: String, completion: @escaping (Result<Pazarama_MovieApp.SearchMovies, Pazarama_MovieApp.ErrorTypes>) -> ()) {
        if let result = getSearchMoviesMockResult {
            let (_, _, mockResult) = result
            completion(mockResult)
        }
    }
    func getMovieDetails(imdbID: String, completion: @escaping (Result<Pazarama_MovieApp.MovieDetails, Pazarama_MovieApp.ErrorTypes>) -> ()) {
        if let result = getMovieDetailsMockResult {
            let (_, mockResult) = result
            completion(mockResult)
        }
    }
}

private class MockHomeViewModelOutPut: HomeViewModelOutPut {
    
    var movies: SearchMovies!
    var movieError: ErrorTypes!
    
    func getMovies(_ searchMovies: Pazarama_MovieApp.SearchMovies) {
        movies = searchMovies
    }
    func getError(_ errorType: Pazarama_MovieApp.ErrorTypes) {
        movieError = errorType
    }
    func changeNoMovieScreen(_ isNoData: Bool) {
    }
    func changeLoading(_ isLoading: Bool) {
    }
    func changePagination(_ isPaging: Bool) {
    }
}

private class MockDetailsViewModelOutPut: DetailsViewModelOutPut {
    
    var movieDetails: MovieDetails!
    var movieError: ErrorTypes!
    
    func getMovieDetails(_ movieDetails: Pazarama_MovieApp.MovieDetails) {
        self.movieDetails = movieDetails
    }
    func getError(_ errorType: Pazarama_MovieApp.ErrorTypes) {
        movieError = errorType
    }
    func changeLoading(_ isLoading: Bool) {
    }
}

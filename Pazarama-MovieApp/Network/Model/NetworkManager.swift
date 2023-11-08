//
//  NetworkManager.swift
//  Pazarama-MovieApp
//
//  Created by Kaan Yıldırım on 5.11.2023.
//

import Foundation

protocol MovieService {
    func getSearchMovies(search: String, page: String, completion: @escaping (Result<SearchMovies, 
                                                                              ErrorTypes>) -> ())
    func getMovieDetails(imdbID: String, completion: @escaping (Result<MovieDetails, ErrorTypes>) -> ())
}

class NetworkManager {
    private func request<T: Codable>(_ endPoint: EndPoint, 
                                     completion: @escaping (Result <T, ErrorTypes>) -> Void) {
        URLSession.shared.dataTask(with: endPoint.request()) { data, response, error in
            if error != nil {
                completion(.failure(.generalError))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode >= 200,
                    response.statusCode <= 299 else {
                completion(.failure(.responseError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            self.handleResponse(data: data) { response in
                completion(response)
            }
        }.resume()
    }
    
    private func handleResponse<T: Codable>(data: Data,
                                            completion: @escaping (Result<T, ErrorTypes>) -> ()) {
        do {
            let successData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(successData))
        } catch {
            completion(.failure(.parsingError))
        }
    }
}

extension NetworkManager: MovieService {
    func getSearchMovies(search: String, page: String, completion: @escaping (Result<SearchMovies, 
                                                                              ErrorTypes>) -> ()) {
        let endPoint = EndPoint.getSearchMovies(search: search, page: page)
        request(endPoint, completion: completion)
    }
    
    func getMovieDetails(imdbID: String, completion: @escaping (Result<MovieDetails, ErrorTypes>) -> ()) {
        let endPoint = EndPoint.getSearchMovieDetail(imdbID: imdbID)
        request(endPoint, completion: completion)
    }
}

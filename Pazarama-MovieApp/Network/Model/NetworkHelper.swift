//
//  NetworkHelper.swift
//  Pazarama-MovieApp
//
//  Created by Kaan Yıldırım on 5.11.2023.
//

import Foundation

enum ErrorTypes: String, Error {
    case noData = "No Data"
    case generalError = "General Error"
    case parsingError = "Parsing Error"
    case responseError = "Response Error"
}

enum HTTPMethod: String {
    case get = "GET"
}

protocol EndPointProtocol {
    var method: HTTPMethod { get }
    func request() -> URLRequest
}

enum EndPoint {
    case getSearchMovies(search: String, page: String)
    case getSearchMovieDetail(imdbID: String)
}

extension EndPoint: EndPointProtocol {
    
    var method: HTTPMethod {
        switch self {
        case .getSearchMovies: return .get
        case .getSearchMovieDetail: return .get
        }
    }
    
    func request() -> URLRequest {
        guard var components = URLComponents(string: BaseUrl.baseUrl) else {
            fatalError("URL ERROR !")
        }
        
        // Add Query Paramater
        if case .getSearchMovies(let search, let page) = self {
            components.queryItems = [
                URLQueryItem(name: "apikey", value: ApiKey.apiKey),
                URLQueryItem(name: "s", value: search),
                URLQueryItem(name: "page", value: page)
            ]
            print(components)
        } else if case .getSearchMovieDetail(let imdbID) = self {
            components.queryItems = [
                URLQueryItem(name: "apikey", value: ApiKey.apiKey),
                URLQueryItem(name: "i", value: imdbID)
            ]
            print(components)
        }
        
        // Add Request
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        
        return request
    }
}

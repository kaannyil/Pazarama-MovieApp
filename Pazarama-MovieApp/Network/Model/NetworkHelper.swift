//
//  NetworkHelper.swift
//  Pazarama-MovieApp
//
//  Created by Kaan Yıldırım on 5.11.2023.
//

import Foundation

enum ErrorTypes: String, Error {
    case invalidUrl = "Invalid URL"
    case noData = "No Data"
    case invalidRequest = "Invalid Request"
    case generalError = "General Error"
    case parsingError = "Parsing Error"
    case responseError = "Response Error"
}

enum HTTPMethod: String {
    case get = "GET"
}

protocol EndPointProtocol {
    // var path: String { get }
    var method: HTTPMethod { get }
    func request() -> URLRequest
}

enum EndPoint {
    case getSearchMovies(search: String)
    case getSearchMovieDetail(title: String)
}

extension EndPoint: EndPointProtocol {
    
    // var path: String {
    //     switch self {
    //     case .getSearchMovies(let search): return "\(search)"
    //     case .getSearchMovieDetail(let title): return "\(title)"
    //     }
    // }
    
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
        
        // Add path
        // components.path = path
        
        // Add Query Paramater
        if case .getSearchMovies(let search) = self {
            components.queryItems = [
                URLQueryItem(name: "apikey", value: ApiKey.apiKey),
                URLQueryItem(name: "s", value: search)
            ]
            print(components)
        } else if case .getSearchMovieDetail = self {
            components.queryItems = [
                URLQueryItem(name: "apikey", value: ApiKey.apiKey),
            ]
            print(components)
        }
        
        // Add Request
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        
        return request
    }
}

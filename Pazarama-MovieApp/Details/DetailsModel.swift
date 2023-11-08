//
//  DetailsModel.swift
//  Pazarama-MovieApp
//
//  Created by Kaan Yıldırım on 5.11.2023.
//

import Foundation

struct MovieDetails: Codable {
    let title, year: String
    let director: String
    let actors, country: String
    let poster: String
    let imdbRating, imdbID: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case director = "Director"
        case actors = "Actors"
        case country = "Country"
        case poster = "Poster"
        case imdbRating, imdbID
    }
}
